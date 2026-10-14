*** Settings ***
Documentation     A small API to UI to database journey reusing the same local fixture.

Resource          resources/catalog/api.resource
Resource          resources/catalog/database.resource
Resource          resources/catalog/ui.resource

Suite Setup       Start catalog journey
Suite Teardown    Stop catalog journey
Test Setup        Open fresh catalog page
Test Teardown     Close Context

Test Tags         ui    journey    local


*** Test Cases ***
An API-created item appears in the UI and database
    [Documentation]    Reuse domain keywords across layers and delete the created record in FINALLY.
    [Metadata]    Requirement    catalog-cross-layer
    ${item}    Create catalog item    Journey handbook    6
    TRY
        Reload
        Filter catalog items    ${item}[name]
        Catalog should contain only    ${item}[name]
        Catalog database item should match    ${item}[id]    ${item}[name]    6
    FINALLY
        Delete catalog item    ${item}[id]
    END


*** Keywords ***
Start catalog journey
    [Documentation]    Share one HTTP server and database across the three client libraries.
    Start catalog API
    Open catalog database    ${CATALOG_DB}
    Open catalog browser

Stop catalog journey
    [Documentation]    Always attempt database, browser, session, and fixture cleanup.
    TRY
        Disconnect From All Databases
    FINALLY
        Stop catalog UI
    END
