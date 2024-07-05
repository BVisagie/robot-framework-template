*** Settings ***
Documentation  A suite of example tests to do some basic illustrate validations against the target system,
...  hosted at: https://jsonplaceholder.typicode.com/

Resource  ../../../resources/project_json_placeholder/posts_endpoint.resource

*** Test Cases ***
Basic HTTP GET validations for the posts endpoint
  [Tags]  BASIC_API_TEST_1  EXAMPLE_SMOKE_TEST_PACK
  [Documentation]  The objective of this test is to interact with the system under test using an HTTP GET request
  ...  to the 'posts' URI, with some basic validations.
  Call and validate the posts endpoint using HTTP GET

HTTP GET validations for the comments endpoint with random post id parameter
  [Tags]  BASIC_API_TEST_2  EXAMPLE_SMOKE_TEST_PACK
  [Documentation]  The objective of this test is to interact with the system under test using an HTTP GET request
  ...  to the 'comments' URI, using a random postId and some basic validations. (as per site documentation)
  Call and validate the comments endpoint using random postId using HTTP GET