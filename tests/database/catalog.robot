*** Settings ***
Documentation     Working DatabaseLibrary examples using a fresh local SQLite database.

Resource          resources/common/fixture.resource
Resource          resources/catalog/database.resource

Suite Setup       Start catalog database
Suite Teardown    Stop catalog database
Test Setup        Reset catalog fixture

Test Tags         database    local


*** Test Cases ***
Seed record can be retrieved with bound parameters
    [Documentation]    Check typed arguments and concrete query results.
    [Metadata]    Requirement    catalog-storage
    Catalog database item should match    1    Robot Framework guide    5

Insert binds a name containing an apostrophe
    [Documentation]    SQL placeholders keep data separate from the query.
    VAR    ${item_id: int}    10
    VAR    ${quantity: int}    4
    VAR    @{parameters}    ${item_id}    Reader's handbook    ${quantity}
    Execute SQL String
    ...    INSERT INTO items (id, name, quantity) VALUES (?, ?, ?)
    ...    parameters=${parameters}
    Catalog database item should match    ${item_id}    Reader's handbook    ${quantity}

Update and delete change only the selected row
    [Documentation]    Use bound values for both statements and assertions.
    VAR    ${quantity: int}    9
    VAR    ${item_id: int}    2
    VAR    @{update_parameters}    ${quantity}    ${item_id}
    Execute SQL String    UPDATE items SET quantity = ? WHERE id = ?    parameters=${update_parameters}
    Catalog database item should match    2    SQLite handbook    9
    VAR    @{delete_parameters}    ${item_id}
    Execute SQL String    DELETE FROM items WHERE id = ?    parameters=${delete_parameters}
    ${rows}    Query    SELECT * FROM items WHERE id = ?    parameters=${delete_parameters}
    Should Be Empty    ${rows}
    Catalog database item should match    1    Robot Framework guide    5

An explicit rollback restores the original quantity
    [Documentation]    Read an uncommitted update, roll it back, and verify the original value.
    Execute SQL String    UPDATE items SET quantity = 99 WHERE id = 1    no_transaction=${True}
    TRY
        Catalog database item should match    1    Robot Framework guide    99    no_transaction=${True}
    FINALLY
        Execute SQL String    ROLLBACK    no_transaction=${True}
    END
    Catalog database item should match    1    Robot Framework guide    5


*** Keywords ***
Start catalog database
    [Documentation]    Start the fixture before connecting DatabaseLibrary.
    Start catalog fixture
    Open catalog database    ${CATALOG_DB}

Stop catalog database
    [Documentation]    Close the fixture even if database disconnect fails.
    TRY
        Disconnect From All Databases
    FINALLY
        Stop catalog fixture
    END
