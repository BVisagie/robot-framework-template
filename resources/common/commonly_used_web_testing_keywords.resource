*** Settings ***
Documentation  Generic boilerplate browser setup, irrespective of system under test
...  Playwright is the chosen UI automation framework https://playwright.dev/
...  No project specific keywords should be placed within resources/common!

Resource  ../../libraries/robot_framework/web_testing_library.resource
Resource  ../../data/common/web_testing_data.resource

*** Keywords ***
Setup a new browser and page instance
  [Arguments]
  ...  ${url}

  New Browser  chromium  headless=${headless_browser}  slowMo=${slow_mo}
  New Context  viewport={'width': ${browser_viewport_width}, 'height': ${browser_viewport_height}}

  New Page  ${url}

  # Deletes all cookies from the currently active browser context.
  # Not strictly mandatory to do here.
  Browser.Delete All Cookies

