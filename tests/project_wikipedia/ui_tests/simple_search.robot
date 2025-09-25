*** Settings ***
Documentation       A suite of example test(s) to do with basic searches on the Wikipedia website

Resource            ../../../resources/project_wikipedia/simple_search.resource


*** Test Cases ***
Basic search from the Wikipedia main page
    [Documentation]    The objective of this test is to navigate to Wikipedia and perform a basic search verifications
    [Tags]    wikipedia_basic_search_test_1    example_smoke_test_pack
    [Template]    Navigate from the landing page to the main page and verify a basic search
    English
    Portuguese
