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
    Stop fixture and verify cleanup

Failed startup still allows complete cleanup
    [Documentation]    Report a crashed process before the default 10-second wait and preserve its cause.
    [Timeout]    5 seconds
    ${error}    Run Keyword And Expect Error
    ...    Catalog startup failed: Catalog process exited with code 1.*
    ...    Start catalog fixture    ${EXECDIR}${/}missing-seed.yaml
    VAR    ${stderr_path}    ${OUTPUT_DIR}${/}fixtures${/}${SUITE NAME}${/}stderr.log
    Should Contain    ${error}    ${stderr_path}
    ${stderr}    Get File    ${stderr_path}
    Should Contain    ${stderr}    FileNotFoundError
    Should Contain    ${stderr}    missing-seed.yaml
    Stop fixture and verify cleanup


*** Keywords ***
Stop fixture and verify cleanup
    [Documentation]    Preserve handles so cleanup can be checked after the suite variables are cleared.
    VAR    ${process}    ${FIXTURE_PROCESS}
    VAR    ${directory}    ${FIXTURE_DIRECTORY}
    Stop catalog fixture
    Process Should Be Stopped    ${process}
    Directory Should Not Exist    ${directory}
