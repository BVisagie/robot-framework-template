*** Settings ***
Documentation    SQLite connections and parameterized queries for standalone and journey examples.

Library          DatabaseLibrary


*** Keywords ***
Open catalog database
    [Documentation]    Connect to this suite's disposable SQLite database.
    [Arguments]    ${database}
    Connect To Database    sqlite3    database=${database}

Catalog database item should match
    [Documentation]    Assert a bound query result; preserve an open transaction when requested.
    [Arguments]    ${item_id: int}    ${name}    ${quantity: int}    ${no_transaction: bool}=${False}
    VAR    @{parameters}    ${item_id}
    ${rows}    Query
    ...    SELECT name, quantity FROM items WHERE id = ?
    ...    parameters=${parameters}    no_transaction=${no_transaction}
    Length Should Be    ${rows}    1
    Should Be Equal    ${rows}[0][0]    ${name}
    Should Be Equal As Integers    ${rows}[0][1]    ${quantity}
