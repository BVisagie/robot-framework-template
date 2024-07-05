*** Settings ***
Documentation  For documentation on the browser automation keywords used below, please look here:
...            https://marketsquare.github.io/robotframework-browser/Browser.html

Resource  ../../libraries/robot_framework/web_testing_library.resource
Resource  ../common/commonly_used_web_testing_keywords.resource
Resource  ../../data/project_wikipedia/page_objects/index_of_all_page_objects.resource

*** Keywords ***
Navigate from the landing page to the main page and verify a basic search
  [Arguments]
  ...  ${target_language}

  Setup a new browser and page instance  https://www.wikipedia.org/

  IF  '${target_language}'=='English'
    Click  ${english_language_button_by_title}
    Wait For Elements State  ${main_page_simple_search_input}  visible
    Type Text  ${main_page_simple_search_input}  txt=Great Britain
    Press Keys  ${main_page_simple_search_input}  Enter
    Wait For Elements State  ${main_page_heading}  visible
    ${heading_text}=  Browser.Get Text  ${main_page_heading}
    Should Be Equal  ${heading_text}  Great Britain
    Close Browser

  ELSE IF  '${target_language}'=='Portuguese'
    Click  ${portuguese_language_button_by_xpath}
    Wait For Elements State  ${main_page_simple_search_input}  visible
    Type Text  ${main_page_simple_search_input}  txt=Almourol
    Press Keys  ${main_page_simple_search_input}  Enter
    Wait For Elements State  ${main_page_heading}  visible
    ${heading_text}=  Browser.Get Text  ${main_page_heading}
    Should Be Equal  ${heading_text}  Castelo de Almourol
    Close Browser
  END