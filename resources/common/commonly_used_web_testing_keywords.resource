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

    New Browser    chromium    headless=${HEADLESS_BROWSER}    slowMo=${SLOW_MO}
    New Context    viewport={'width': ${BROWSER_VIEWPORT_WIDTH}, 'height': ${BROWSER_VIEWPORT_HEIGHT}}

    New Page    ${url}

    # Deletes all cookies from the currently active browser context.
    # Not strictly mandatory to do here.
    Browser.Delete All Cookies
