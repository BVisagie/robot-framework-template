*** Settings ***
Documentation       Generic boilerplate browser setup, irrespective of system under test
...                 Playwright is the chosen UI automation framework https://playwright.dev/
...                 No project specific keywords should be placed within resources/common!

Resource            ../../libraries/robot_framework/web_testing_library.resource
Resource            ../../data/common/web_testing_data.resource


*** Keywords ***
Setup a new browser and page instance
    [Documentation]    Using Playwright functionality and some global variables retrieved from
    ...    common/web_testing_data.resource, setup a new page.
    [Arguments]    ${url}

    ${env_headless}=    Get Environment Variable    HEADLESS_BROWSER
    ${headless}=    Set Variable If    '${env_headless}'!=''    ${env_headless}    ${HEADLESS_BROWSER}
    ${headless}=    Convert To Boolean    ${headless}

    New Browser    chromium    headless=${headless}    slowMo=${SLOW_MO}
    New Context    viewport={'width': ${BROWSER_VIEWPORT_WIDTH}, 'height': ${BROWSER_VIEWPORT_HEIGHT}}

    New Page    ${url}

    # Deletes all cookies from the currently active browser context.
    # Not strictly mandatory to do here.
    Browser.Delete All Cookies

Open browser and context for suite
    [Documentation]    Open a single browser and context for the whole suite with env-aware headless setting.
    [Arguments]    ${base_url}

    ${env_headless}=    Get Environment Variable    HEADLESS_BROWSER
    ${headless}=    Set Variable If    '${env_headless}'!=''    ${env_headless}    ${HEADLESS_BROWSER}
    ${headless}=    Convert To Boolean    ${headless}

    New Browser    chromium    headless=${headless}    slowMo=${SLOW_MO}
    New Context    viewport={'width': ${BROWSER_VIEWPORT_WIDTH}, 'height': ${BROWSER_VIEWPORT_HEIGHT}}
    New Page    ${base_url}

Close browser for suite
    [Documentation]    Close the currently open browser for the suite.

    Close Browser
