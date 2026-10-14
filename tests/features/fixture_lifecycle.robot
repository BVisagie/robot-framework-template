*** Settings ***
Documentation    Verify fixture processes and temporary files are cleaned on normal and failed startup.

Resource         resources/common/fixture.resource

Test Teardown    Stop catalog fixture

Test Tags        features    local


*** Test Cases ***
Stopping a fixture closes its process and removes its database
    [Documentation]    Explicit stop is safe to call again during test teardown.
    Start catalog fixture
    Run Keyword And Expect Error    Catalog fixture is already running.    Start catalog fixture
    VAR    ${process}    ${FIXTURE_PROCESS}
    VAR    ${directory}    ${FIXTURE_DIRECTORY}
    Stop catalog fixture
    Process Should Be Stopped    ${process}
    Directory Should Not Exist    ${directory}

Failed startup still allows complete cleanup
    [Documentation]    A missing seed file produces a bounded startup failure with preserved stderr.
    Run Keyword And Expect Error
    ...    Catalog startup failed:*
    ...    Start catalog fixture    ${EXECDIR}${/}missing-seed.yaml    200 milliseconds
    VAR    ${process}    ${FIXTURE_PROCESS}
    VAR    ${directory}    ${FIXTURE_DIRECTORY}
    Stop catalog fixture
    Process Should Be Stopped    ${process}
    Directory Should Not Exist    ${directory}
