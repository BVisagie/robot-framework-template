*** Settings ***
Documentation       For documentation on the browser automation keywords used below, please look here:
...                 https://marketsquare.github.io/robotframework-browser/Browser.html

Resource            libraries/robot_framework/web_testing_library.resource
Resource            resources/common/commonly_used_web_testing_keywords.resource
Resource            resources/project_wikipedia/page_objects/index_of_all_page_objects.resource


*** Keywords ***
Search from language landing page and verify heading
    [Documentation]    Click a language entry, run a search, and verify the resulting page heading.
    [Arguments]    ${language_locator}    ${search_text}    ${expected_heading}

    Click    ${language_locator}
    Wait For Elements State    selector=${MAIN_PAGE_SIMPLE_SEARCH_INPUT}    state=stable    timeout=10s
    Type Text    ${MAIN_PAGE_SIMPLE_SEARCH_INPUT}    txt=${search_text}
    Press Keys    ${MAIN_PAGE_SIMPLE_SEARCH_INPUT}    Enter
    Wait For Elements State    selector=${MAIN_PAGE_HEADING}    state=stable    timeout=10s
    ${heading_text}=    Browser.Get Text    ${MAIN_PAGE_HEADING}
    Should Be Equal    ${heading_text}    ${expected_heading}

Navigate from the landing page to the main page and verify a basic search
    [Documentation]    Start a browser on Wikipedia, select a language, run a search, and verify the heading.
    [Arguments]    ${target_language}

    TRY
        Setup a new browser and page instance    ${WIKIPEDIA_BASE_URL}
        IF    '${target_language}' == 'English'
            Search from language landing page and verify heading
            ...    ${ENGLISH_LANGUAGE_BUTTON_BY_TITLE}
            ...    Great Britain
            ...    Great Britain
        ELSE IF    '${target_language}' == 'Portuguese'
            Search from language landing page and verify heading
            ...    ${PORTUGUESE_LANGUAGE_BUTTON_BY_XPATH}
            ...    Almourol
            ...    Castelo de Almourol
        ELSE
            Fail    Unsupported target language: ${target_language}
        END
    FINALLY
        Close Browser
    END
