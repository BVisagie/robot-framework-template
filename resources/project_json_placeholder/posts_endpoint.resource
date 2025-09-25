*** Settings ***
Documentation       All keywords that focus on interacting with the jsonplaceholder.typicode.com test API over HTTP GET

Resource            ../../libraries/robot_framework/common.resource
Resource            ../../libraries/robot_framework/requests_library.resource
Resource            ../../data/project_json_placeholder/environment_data.resource
Resource            ../common/commonly_used_validation_keywords.resource
# Notice how Python functions decorated with Robot Framework decorators are imported as libraries rather than resources.
Library             ../common_python/common_functions.py


*** Keywords ***
Call and validate the posts endpoint using HTTP GET
    [Documentation]    Simply does a HTTP GET request, ensuring 200 OK is received and then checking the JSON
    ...    response to not be empty.

    ${target_endpoint}=    Set Variable    ${PROJECT_JSON_BASE_URI}${PROJECT_JSON_POSTS_URI}

    ${response}=    RequestsLibrary.GET    url=${target_endpoint}    expected_status=200
    ${response_as_json}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${response_as_json}

Call and validate the comments endpoint using random postId using HTTP GET
    [Documentation]    Does an HTTP GET request with a random postId parameter in the URI, ensuring 200 OK is received
    ...    and then checking the JSON response with a couple of validations.

    ${target_endpoint}=    Set Variable    ${PROJECT_JSON_BASE_URI}${PROJECT_JSON_COMMENTS_URI}
    # as per site API documents 100 postId's should exist
    ${random_but_valid_post_id}=    get_random_int
    ...    min_value=1
    ...    max_value=100
    &{random_post_id_dictionary}=    Create Dictionary    postId=${random_but_valid_post_id}

    ${response}=    RequestsLibrary.GET
    ...    url=${target_endpoint}
    ...    params=${random_post_id_dictionary}
    ...    expected_status=200
    ${response_as_json}=    Set Variable    ${response.json()}
    Log    ${response_as_json}    # Logging this to file just as an example.
    Should Not Be Empty    ${response_as_json}
    Validate JSON Response Is List    ${response_as_json}
    Validate Each Item Has Required Keys within the Response    ${response_as_json}

Create JSONPlaceholder session
    [Documentation]    Create a RequestsLibrary session using the base URI for jsonplaceholder.

    Create Session    alias=jsonplaceholder    url=${PROJECT_JSON_BASE_URI}

Call and validate the posts endpoint using session
    [Documentation]    Use a pre-created session to GET the posts endpoint and validate.

    ${response}=    Get On Session    alias=jsonplaceholder    url=${PROJECT_JSON_POSTS_URI}    expected_status=200
    ${response_as_json}=    Set Variable    ${response.json()}
    Should Not Be Empty    Empty    ${response_as_json}

Call and validate the comments endpoint using random postId via session
    [Documentation]    Use a pre-created session to GET the comments endpoint with a random postId and validate.

    ${random_but_valid_post_id}=    get_random_int    min_value=1    max_value=100
    &{random_post_id_dictionary}=    Create Dictionary    postId=${random_but_valid_post_id}
    ${response}=    Get On Session
    ...    alias=jsonplaceholder
    ...    url=${PROJECT_JSON_COMMENTS_URI}
    ...    params=${random_post_id_dictionary}
    ...    expected_status=200
    ${response_as_json}=    Set Variable    ${response.json()}
    Validate JSON Response Is List    ${response_as_json}
    Validate Each Item Has Required Keys within the Response    ${response_as_json}

Validate Each Item Has Required Keys within the Response
    [Documentation]    Checks that each item within a given response consists of a: postId, id, name, email, body
    [Arguments]    ${response}
    ${required_keys}=    Create List    postId    id    name    email    body
    FOR    ${item}    IN    @{response}
        Dictionary Should Contain Key    ${item}    ${required_keys}[0]
        Dictionary Should Contain Key    ${item}    ${required_keys}[1]
        Dictionary Should Contain Key    ${item}    ${required_keys}[2]
        Dictionary Should Contain Key    ${item}    ${required_keys}[3]
        Dictionary Should Contain Key    ${item}    ${required_keys}[4]
    END
