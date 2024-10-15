*** Settings ***
Documentation       For documentation on the browser automation keywords used below, please look here:
...                 https://marketsquare.github.io/robotframework-browser/Browser.html

Resource            ../../libraries/robot_framework/web_testing_library.resource
Resource            ../common/commonly_used_web_testing_keywords.resource
Resource            ../../data/project_wikipedia/page_objects/index_of_all_page_objects.resource


*** Keywords ***
Navigate from the landing page to the main page and verify a basic search
    [Documentation]    The objective of this keyword is to start a new browser instance with wikipedia, and perform
    ...    a number of actions resulting in a verification of navigation to the intended language specific page.
    [Arguments]    ${target_language}

    Setup a new browser and page instance    https://www.wikipedia.org/

    IF    '${target_language}'=='English'
        Click    ${ENGLISH_LANGUAGE_BUTTON_BY_TITLE}
        Wait For Elements State    selector=${MAIN_PAGE_SIMPLE_SEARCH_INPUT}    state=stable    timeout=10s
        Type Text    ${MAIN_PAGE_SIMPLE_SEARCH_INPUT}    txt=Great Britain
        Press Keys    ${MAIN_PAGE_SIMPLE_SEARCH_INPUT}    Enter
        Wait For Elements State    selector=${MAIN_PAGE_HEADING}    state=stable    timeout=10s
        ${heading_text}=    Browser.Get Text    ${MAIN_PAGE_HEADING}
        Should Be Equal    ${heading_text}    Great Britain
        Close Browser
    ELSE IF    '${target_language}'=='Portuguese'
        Click    ${PORTUGUESE_LANGUAGE_BUTTON_BY_XPATH}
        Wait For Elements State    selector=${MAIN_PAGE_SIMPLE_SEARCH_INPUT}    state=stable    timeout=10s
        Type Text    ${MAIN_PAGE_SIMPLE_SEARCH_INPUT}    txt=Almourol
        Press Keys    ${MAIN_PAGE_SIMPLE_SEARCH_INPUT}    Enter
        Wait For Elements State    selector=${MAIN_PAGE_HEADING}    state=stable    timeout=10s
        ${heading_text}=    Browser.Get Text    ${MAIN_PAGE_HEADING}
        Should Be Equal    ${heading_text}    Castelo de Almourol
        Close Browser
    END
