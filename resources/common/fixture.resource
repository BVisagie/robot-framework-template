*** Settings ***
Documentation    Start a disposable local HTTP/SQLite fixture with native Robot lifecycle keywords.

# Suite scope keeps fixture handles available to setup, tests, and teardown.
Library          OperatingSystem
Library          Process
Library          RequestsLibrary


*** Variables ***
${FIXTURE_PROCESS}      ${None}
${FIXTURE_DIRECTORY}    ${None}
${CATALOG_URL}          ${None}
${CATALOG_DB}           ${None}


*** Keywords ***
Start catalog fixture
    [Documentation]    Start the current Python interpreter on an available port and wait for readiness.
    [Arguments]    ${seed}=${EXECDIR}${/}data${/}catalog.yaml    ${startup_timeout}=10 seconds
    IF    $FIXTURE_PROCESS is not None
        Fail    Catalog fixture is already running.
    END
    ${python}    Evaluate    sys.executable    modules=sys
    ${directory}    Evaluate    tempfile.mkdtemp(prefix="rf-catalog-")    modules=tempfile
    VAR    ${FIXTURE_DIRECTORY}    ${directory}    scope=SUITE
    VAR    ${log_directory}    ${OUTPUT_DIR}${/}fixtures${/}${SUITE NAME}
    Create Directory    ${log_directory}
    ${process}    Start Process
    ...    ${python}
    ...    ${EXECDIR}${/}fixtures${/}catalog_app.py
    ...    --database    ${directory}${/}catalog.db
    ...    --ready-file    ${directory}${/}ready.json
    ...    --seed    ${seed}
    ...    stdout=${log_directory}${/}stdout.log
    ...    stderr=${log_directory}${/}stderr.log
    VAR    ${FIXTURE_PROCESS}    ${process}    scope=SUITE
    TRY
        Wait for catalog fixture    ${startup_timeout}
    EXCEPT    AS    ${error}
        Fail    Catalog startup failed: ${error}. See ${log_directory}${/}stderr.log.
    END

Wait for catalog fixture
    [Documentation]    Retry readiness while the process lives; report crashes without waiting out the timeout.
    [Arguments]    ${startup_timeout}
    VAR    ${error}    Startup record has not been written.
    WHILE    True    limit=${startup_timeout}    on_limit=pass
        ${running}    Is Process Running    ${FIXTURE_PROCESS}
        IF    not $running
            ${result}    Wait For Process    ${FIXTURE_PROCESS}
            Fail    Catalog process exited with code ${result.rc}
        END
        TRY
            Catalog fixture should be ready
        EXCEPT    AS    ${error}
            Sleep    100 milliseconds
        ELSE
            RETURN
        END
    END
    Fail    Catalog did not become ready within ${startup_timeout}: ${error}

Catalog fixture should be ready
    [Documentation]    Read the atomic startup record and verify the HTTP health endpoint.
    File Should Exist    ${FIXTURE_DIRECTORY}${/}ready.json
    ${text}    Get File    ${FIXTURE_DIRECTORY}${/}ready.json
    ${ready}    Evaluate    json.loads($text)    modules=json
    GET    ${ready}[url]/health    expected_status=200    timeout=1
    VAR    ${CATALOG_URL}    ${ready}[url]    scope=SUITE
    VAR    ${CATALOG_DB}    ${ready}[database]    scope=SUITE

Reset catalog fixture
    [Documentation]    Restore the shared seed data before each test.
    POST    ${CATALOG_URL}/api/reset    expected_status=200    timeout=5

Stop catalog fixture
    [Documentation]    Close sessions and stop the process even after a partially completed setup.
    TRY
        Delete All Sessions
    FINALLY
        TRY
            IF    $FIXTURE_PROCESS is not None
                Terminate Process    ${FIXTURE_PROCESS}    kill=${True}
            END
        FINALLY
            IF    $FIXTURE_DIRECTORY is not None
                Remove Directory    ${FIXTURE_DIRECTORY}    recursive=${True}
            END
            VAR    ${FIXTURE_PROCESS}    ${None}    scope=SUITE
            VAR    ${FIXTURE_DIRECTORY}    ${None}    scope=SUITE
            VAR    ${CATALOG_URL}    ${None}    scope=SUITE
            VAR    ${CATALOG_DB}    ${None}    scope=SUITE
        END
    END
