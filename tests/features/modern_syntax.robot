*** Settings ***
Documentation    Executable examples of features introduced across Robot Framework 7.x.

Library          libraries/example_library.py
Variables        data/catalog.yaml

Test Tags        features    local


*** Variables ***
${DEMO_TOKEN: Secret}            %{RF_DEMO_TOKEN=template-demo-token}
${INVALID_DEMO_TOKEN: Secret}    %{RF_INVALID_DEMO_TOKEN=incorrect-demo-token}


*** Test Cases ***
VAR supports typed scalars lists and dictionaries
    [Documentation]    VAR arrived in 7.0 and native type conversion in 7.3.
    VAR    ${quantity: int}    5
    VAR    @{identifiers: int}    1    2    3
    VAR    &{counts: int}    guides=5    handbooks=3
    Should Be Equal    ${quantity}    ${CATALOG_SEED}[0][quantity]
    Should Be Equal As Integers    ${identifiers}[1]    2
    Should Be Equal    ${counts}[guides]    ${quantity}

Typed user keyword arguments convert data rows
    [Documentation]    Robot 7.3 converts template strings to integer arguments.
    [Template]    Combined quantity should be
    2    3    5
    0    4    4

Python type aliases convert keyword arguments
    [Documentation]    Robot 7.5 recognizes Python type aliases in library signatures.
    [Metadata]    Feature    Python type alias conversion
    ${quantity}    Calculate stock quantity    2    shipment=3
    Should Be Equal As Integers    ${quantity}    5
    Run Keyword And Expect Error    *cannot be converted*    Calculate stock quantity    many

GROUP gives related steps a name in the log
    [Documentation]    Robot 7.2 GROUP shares the current scope; reusable actions belong in keywords.
    GROUP    Check the shared YAML seed data
        Length Should Be    ${CATALOG_SEED}    3
        FOR    ${item}    IN    @{CATALOG_SEED}
            Should Be True    $item["quantity"] >= 0
        END
    END

Native exception handling always executes FINALLY
    [Documentation]    TRY and RETURN predate 7.x and remain useful for resource cleanup.
    VAR    ${cleanup_ran: bool}    false
    TRY
        Calculate stock quantity    -1
    EXCEPT    ValueError: Quantity must be non-negative.
        Log    Expected validation error was handled.
    ELSE
        Fail    Negative quantity should have failed.
    FINALLY
        VAR    ${cleanup_ran: bool}    true
    END
    Should Be True    ${cleanup_ran}

Secret arguments stay wrapped at the Python boundary
    [Documentation]    Robot 7.4 masks Secret values, including arguments and failure logs.
    [Metadata]    Feature    Secret variables
    Verify demo token    ${DEMO_TOKEN}
    Run Keyword And Expect Error    ValueError: Demo token rejected.    Verify demo token    ${INVALID_DEMO_TOKEN}


*** Keywords ***
Combined quantity should be
    [Documentation]    Typed native user keyword arguments require no manual Convert To Integer calls.
    [Arguments]    ${quantity: int}    ${shipment: int}    ${expected: int}
    ${actual}    Calculate stock quantity    ${quantity}    ${shipment}
    Should Be Equal    ${actual}    ${expected}
