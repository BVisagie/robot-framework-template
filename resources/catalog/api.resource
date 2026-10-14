*** Settings ***
Documentation    RequestsLibrary actions shared by API and UI journey examples.

Library          RequestsLibrary
Resource         resources/common/fixture.resource


*** Keywords ***
Start catalog API
    [Documentation]    Start the local fixture and create a bounded HTTP session.
    Start catalog fixture
    Create Session    catalog    ${CATALOG_URL}

Create catalog item
    [Documentation]    Create a known item and return the persisted API representation.
    [Arguments]    ${name}    ${quantity: int}
    VAR    &{item}    name=${name}    quantity=${quantity}
    ${response}    POST On Session    catalog    /api/items    json=${item}    expected_status=201    timeout=5
    RETURN    ${response.json()}

Get catalog item
    [Documentation]    Retrieve an existing item by its typed identifier.
    [Arguments]    ${item_id: int}
    ${response}    GET On Session    catalog    /api/items/${item_id}    expected_status=200    timeout=5
    RETURN    ${response.json()}

Update catalog item
    [Documentation]    Replace a record using typed input and return the updated representation.
    [Arguments]    ${item_id: int}    ${name}    ${quantity: int}
    VAR    &{item}    name=${name}    quantity=${quantity}
    ${response}    PUT On Session
    ...    catalog    /api/items/${item_id}    json=${item}    expected_status=200    timeout=5
    RETURN    ${response.json()}

Delete catalog item
    [Documentation]    Delete a created item during teardown.
    [Arguments]    ${item_id: int}
    ${response}    DELETE On Session    catalog    /api/items/${item_id}    expected_status=204    timeout=5
    Should Be Empty    ${response.content}
