*** Settings ***
Documentation     Deterministic HTTP examples against the disposable local catalog.

Library           Collections
Resource          resources/catalog/api.resource
Variables         data/catalog.yaml

Suite Setup       Start catalog API
Suite Teardown    Stop catalog fixture
Test Setup        Reset catalog fixture

Test Tags         api    local


*** Test Cases ***
List returns the seeded records and JSON content type
    [Documentation]    Verify concrete data rather than only response shape.
    [Metadata]    Requirement    catalog-list
    ${response}    GET On Session    catalog    /api/items    expected_status=200    timeout=5
    Should Contain    ${response.headers}[Content-Type]    application/json
    Should Be Equal    ${response.json()}    ${CATALOG_SEED}

Filters return only matching records
    [Documentation]    Exercise predictable YAML data rows and assert the requested value.
    FOR    ${case}    IN    @{SEARCH_CASES}
        VAR    &{parameters}    q=${case}[query]
        ${response}    GET On Session
        ...    catalog    /api/items    params=${parameters}    expected_status=200    timeout=5
        VAR    ${items}    ${response.json()}
        Length Should Be    ${items}    1
        Should Be Equal    ${items}[0][name]    ${case}[expected_name]
    END

Known identifier returns the expected item
    [Documentation]    Use a typed resource keyword to retrieve the first seed record.
    ${item}    Get catalog item    1
    Should Be Equal    ${item}    ${CATALOG_SEED}[0]

Create update and delete persist across requests
    [Documentation]    Demonstrate the complete HTTP lifecycle with value assertions.
    ${created}    Create catalog item    New handbook    4
    ${saved}    Get catalog item    ${created}[id]
    Should Be Equal    ${saved}    ${created}
    ${updated}    Update catalog item    ${created}[id]    Revised handbook    7
    Should Be Equal    ${updated}[name]    Revised handbook
    ${saved}    Get catalog item    ${created}[id]
    Should Be Equal As Integers    ${saved}[quantity]    7
    Delete catalog item    ${created}[id]
    GET On Session    catalog    /api/items/${created}[id]    expected_status=404    timeout=5

Missing identifiers return an explicit error
    [Documentation]    An expected failure status is a passing negative scenario.
    ${response}    GET On Session    catalog    /api/items/999    expected_status=404    timeout=5
    Should Be Equal    ${response.json()}[error]    Item not found.
    VAR    ${quantity: int}    1
    VAR    &{item}    name=Missing item    quantity=${quantity}
    PUT On Session    catalog    /api/items/999    json=${item}    expected_status=404    timeout=5
    DELETE On Session    catalog    /api/items/999    expected_status=404    timeout=5

Invalid input is rejected without changing the catalog
    [Documentation]    Reject negative counts, booleans, missing fields, and empty names.
    FOR    ${item}    IN    @{INVALID_ITEMS}
        ${response}    POST On Session
        ...    catalog    /api/items    json=${item}    expected_status=400    timeout=5
        Should Contain    ${response.json()}[error]    non-negative integer
    END
    ${response}    GET On Session    catalog    /api/items    expected_status=200    timeout=5
    Should Be Equal    ${response.json()}    ${CATALOG_SEED}

Malformed JSON and invalid UTF-8 receive a bounded error response
    [Documentation]    Both decoding failures return HTTP 400 and leave the seed data intact.
    ${invalid_utf8}    Evaluate    bytes.fromhex('ff')
    VAR    @{payloads}    {invalid-json    ${invalid_utf8}
    FOR    ${payload}    IN    @{payloads}
        ${response}    POST On Session
        ...    catalog    /api/items    data=${payload}    expected_status=400    timeout=5
        Should Contain    ${response.json()}[error]    non-empty name
    END
    ${response}    GET On Session    catalog    /api/items    expected_status=200    timeout=5
    Should Be Equal    ${response.json()}    ${CATALOG_SEED}

Quotes in names remain literal data
    [Documentation]    The fixture binds SQL values so quotes do not modify a query.
    VAR    ${name}    Reader's guide; DROP TABLE items; --
    ${created}    Create catalog item    ${name}    1
    ${saved}    Get catalog item    ${created}[id]
    Should Be Equal    ${saved}[name]    ${name}
    ${response}    GET On Session    catalog    /api/items    expected_status=200    timeout=5
    Length Should Be    ${response.json()}    4
