*** Settings ***
Documentation  A suite of example test(s) to do with basic searches on the Wikipedia website

Resource  ../../../resources/project_wikipedia/simple_search.resource

*** Test Cases ***
Basic search from the Wikipedia main page
  [Tags]  WIKIPEDIA_BASIC_SEARCH_TEST_1  EXAMPLE_SMOKE_TEST_PACK
  [Documentation]  The objective of this test is to navigate to Wikipedia and perform a basic search verifications
  [Template]  Navigate from the landing page to the main page and verify a basic search
  English
  Portuguese