*** Settings ***
Documentation       Generic boilerplate browser setup, irrespective of system under test
...                 Playwright is the chosen UI automation framework https://playwright.dev/
...                 No project specific keywords should be placed within resources/common!

Resource            libraries/robot_framework/web_testing_library.resource
Resource            data/common/web_testing_data.resource


*** Keywords ***
Resolve headless browser setting
    [Documentation]    Prefer HEADLESS_BROWSER from the environment; otherwise use the project default.

    VAR    ${env_headless}=    %{HEADLESS_BROWSER=}
    IF    '${env_headless}' != ''
        VAR    ${headless}=    ${env_headless}
    ELSE
        VAR    ${headless}=    ${HEADLESS_BROWSER}
    END
    ${headless}=    Convert To Boolean    ${headless}
    RETURN    ${headless}

Setup a new browser and page instance
    [Documentation]    Using Playwright functionality and some global variables retrieved from
    ...    common/web_testing_data.resource, setup a new page.
    [Arguments]    ${url}

    ${headless}=    Resolve headless browser setting
    New Browser    chromium    headless=${headless}    slowMo=${SLOW_MO}
    New Context    viewport={'width': ${BROWSER_VIEWPORT_WIDTH}, 'height': ${BROWSER_VIEWPORT_HEIGHT}}
    New Page    ${url}
    # Deletes all cookies from the currently active browser context.
    Browser.Delete All Cookies

Open browser and context for suite
    [Documentation]    Open a single browser and context for the whole suite with env-aware headless setting.
    [Arguments]    ${base_url}

    ${headless}=    Resolve headless browser setting
    New Browser    chromium    headless=${headless}    slowMo=${SLOW_MO}
    New Context    viewport={'width': ${BROWSER_VIEWPORT_WIDTH}, 'height': ${BROWSER_VIEWPORT_HEIGHT}}
    New Page    ${base_url}

Close browser for suite
    [Documentation]    Close the currently open browser for the suite.

    Close Browser
