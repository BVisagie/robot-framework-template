*** Settings ***
Documentation    Browser lifecycle for the local UI, with a fresh context for each test.

Library          Browser
Resource         resources/common/fixture.resource
Resource         resources/catalog/pages/catalog_page.resource


*** Variables ***
${HEADLESS_BROWSER}    %{HEADLESS_BROWSER=true}


*** Keywords ***
Open catalog browser
    [Documentation]    Prefer a CLI headless override, then the environment, then the true default.
    VAR    ${headless: bool}    ${HEADLESS_BROWSER}
    New Browser    chromium    headless=${headless}
    Set Browser Timeout    5 seconds

Open fresh catalog page
    [Documentation]    Reset data and open a fresh browser context for this test.
    Reset catalog fixture
    New Context    viewport={"width": 1280, "height": 800}
    New Page    ${CATALOG_URL}
    Get Element Count    ${CATALOG_ROWS}    ==    3

Start catalog UI
    [Documentation]    Start the fixture and browser for a UI suite.
    Start catalog fixture
    Open catalog browser

Stop catalog UI
    [Documentation]    Stop the fixture even if browser shutdown fails.
    TRY
        Close Browser    ALL
    FINALLY
        Stop catalog fixture
    END
