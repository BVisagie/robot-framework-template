*** Settings ***
Documentation     Optional public-service demonstration; not part of default discovery or CI.

Library           RequestsLibrary

Suite Setup       Create Session    jsonplaceholder    ${JSONPLACEHOLDER_BASE_URL}
Suite Teardown    Delete All Sessions

Test Tags         external    api


*** Variables ***
${JSONPLACEHOLDER_BASE_URL}    %{JSONPLACEHOLDER_BASE_URL=https://jsonplaceholder.typicode.com}


*** Test Cases ***
Comments belong to the requested post
    [Documentation]    GET a fixed post ID and check the returned relationship.
    VAR    ${post_id: int}    1
    VAR    &{parameters}    postId=${post_id}
    ${response}    GET On Session
    ...    jsonplaceholder    /comments    params=${parameters}    expected_status=200    timeout=10
    VAR    ${comments}    ${response.json()}
    Should Not Be Empty    ${comments}
    FOR    ${comment}    IN    @{comments}
        Should Be Equal    ${comment}[postId]    ${post_id}
        Should Not Be Empty    ${comment}[email]
    END
