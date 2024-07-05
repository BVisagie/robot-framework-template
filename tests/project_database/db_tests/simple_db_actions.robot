*** Settings ***
Documentation  Some example test for illustration database interactions. Warning these are example only, no real
...  database information is provided. Please note that the database tests are not meant to be functional as including
...  real database details and running real queries are beyond the scope of this template repository at this time.

Resource  ../../../resources/project_database/db_actions_and_verifications.resource

*** Test Cases ***
Example non functioning Oracle database test
  [Tags]  NON_FUNCTIONING_DB_TEST  DO_NOT_RUN
  [Documentation]  The following Oracle database test is created for illustration purposes only, it will not function,
  ...  as with a template repository it would not be beneficial to host any kind db credential etc.
  Example Oracle database test


Example non functioning PostgreSQL database test
  [Tags]  NON_FUNCTIONING_DB_TEST  DO_NOT_RUN
  [Documentation]  The following PostgreSQL database test is created for illustration purposes only, it will not function,
  ...  as with a template repository it would not be beneficial to host any kind db credential etc.
  Example PostgreSQL database test