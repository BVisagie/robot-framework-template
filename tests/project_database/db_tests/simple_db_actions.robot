*** Settings ***
Documentation       Some example tests for illustrating database interactions. Warning! These are examples only, as no 
...                 real database information is provided.

Resource            ../../../resources/project_database/db_actions_and_verifications.resource


*** Test Cases ***
Example non functioning Oracle database test
    [Documentation]    The following Oracle database test is created for illustration purposes only! This database test
    ...    is not meant to be functional as including real database details and running real queries are beyond the
    ...    scope of this template repository.
    [Tags]    non_functioning_db_test    do_not_run
    Example Oracle database test

Example non functioning PostgreSQL database test
    [Documentation]    The following PostgreSQL database test is created for illustration purposes only! This database test
    ...    is not meant to be functional as including real database details and running real queries are beyond the
    ...    scope of this template repository.
    [Tags]    non_functioning_db_test    do_not_run
    Example PostgreSQL database test
