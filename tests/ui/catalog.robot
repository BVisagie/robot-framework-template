*** Settings ***
Documentation     Browser examples against a local page with predictable data and stable selectors.

Resource          resources/catalog/ui.resource
Variables         data/catalog.yaml

Suite Setup       Start catalog UI
Suite Teardown    Stop catalog UI
Test Setup        Open fresh catalog page
Test Teardown     Close Context

Test Tags         ui    local


*** Test Cases ***
Filter the catalog using YAML data rows
    [Documentation]    Browser assertions wait for the rendered result without fixed sleeps.
    FOR    ${case}    IN    @{SEARCH_CASES}
        Filter catalog items    ${case}[query]
        Catalog should contain only    ${case}[expected_name]
    END

Create an item using the browser form
    [Documentation]    Verify the success message and the newly rendered row.
    [Metadata]    Requirement    catalog-create-ui
    Add item through catalog form    New UI handbook    4
    Filter catalog items    New UI handbook
    Catalog should contain only    New UI handbook
    Get Text    ${CATALOG_ROWS}    contains    4

Item names are rendered as text
    [Documentation]    Names containing HTML remain literal text in the page.
    Add item through catalog form    <b>Reader's handbook</b>    1
    Filter catalog items    Reader's handbook
    Catalog should contain only    <b>Reader's handbook</b>
    Get Element Count    css=#items b    ==    0
