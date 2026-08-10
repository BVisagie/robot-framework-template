*** Settings ***
Documentation       Some example test actions that will be performed during database interactions.

Resource            resources/common/commonly_used_database_keywords.resource
Resource            resources/common/commonly_used_keywords.resource
Resource            data/project_database/static_database_info.resource
Resource            data/project_database/dummy_queries.resource
Resource            data/project_database/regex_templates_for_queries.resource
Library             resources/common_python/common_functions.py


*** Variables ***
# Optional environment overrides. Empty defaults keep suite import working when vars are unset.
${ENV_DB_HOST}=                 %{DB_HOST=}
${ENV_DB_PORT}=                 %{DB_PORT=}
${ENV_DB_SERVICE_NAME}=         %{DB_SERVICE_NAME=}
${ENV_DB_USER}=                 %{DB_USER=}
${ENV_DB_PASSWORD: Secret}=     %{DB_PASSWORD=}
${ENV_DB_API_MODULE}=           %{DB_API_MODULE=}


*** Keywords ***
Example Oracle database test
    [Documentation]    Select query focused test example (Oracle)

    ${random_item_number}=    get_random_int    min_value=1    max_value=1000

    # The below keyword will modify the static query retrieve_some_data_example_oracle in place, thereby replacing
    # :VAR_ITEM_NO within the query with the provided value.
    ${oracle_query}=    Modify the given query replacing an item placeholder with the actual item
    ...    target_query=${RETRIEVE_SOME_DATA_EXAMPLE_ORACLE}
    ...    target_item_no=${random_item_number}

    ${oracle_query_result_row}=    Execute SQL Query
    ...    query=${oracle_query}
    ...    target_database_information_dictionary=&{PROJECT_ORACLE_DB}

    # Dummy assertion that the weight of the given item as retrieved by the query is equal to 500
    Should Be Equal
    ...    ${oracle_query_result_row}
    ...    500

Example PostgreSQL database test
    [Documentation]    Select query focused test example (PostgreSQL)

    ${random_item_number}=    get_random_int    min_value=1    max_value=1000
    ${updated_date_time_stamp}=    Generate DateTime String With Minutes Offset
    ...    date_time_format=%Y-%m-%d %H:%M
    ...    minutes_offset=2

    ${postgresql_query}=    Modify the given query adding a Item, Updated Date and Boolean
    ...    target_query=${RETRIEVE_SOME_DATA_EXAMPLE_POSTGRESQL}
    ...    target_item_no=${random_item_number}
    ...    target_updated_date_time=${updated_date_time_stamp}
    ...    target_bool=${False}

    ${postgresql_query_result_row}=    Execute SQL Query
    ...    query=${postgresql_query}
    ...    target_database_information_dictionary=&{PROJECT_POSTGRESQL_DB}

    # Dummy assertion that the id of the given item as retrieved by the query is equal to 12345
    Should Be Equal
    ...    ${postgresql_query_result_row}
    ...    12345

Modify the given query adding a Item, Updated Date and Boolean
    [Documentation]    Convenience keyword meant to quickly add Item, Updated Date Time and Boolean for to the given
    ...    query.
    [Arguments]    ${target_query}
    ...    ${target_item_no}
    ...    ${target_updated_date_time}
    ...    ${target_bool}

    ${target_query}=    Modify the given query replacing an item placeholder with the actual item
    ...    target_query=${target_query}
    ...    target_item_no=${target_item_no}
    ${target_query}=    Modify the given query replacing an updated date placeholder with the actual updated date
    ...    target_query=${target_query}
    ...    target_updated_date=${target_updated_date_time}
    ${target_query}=    Modify the given query adding a target boolean
    ...    target_query=${target_query}
    ...    target_bool=${target_bool}
    RETURN    ${target_query}

Modify the given query replacing an item placeholder with the actual item
    [Documentation]    Within the given query string find :VAR_ITEM_NO and replace with the correct item number,
    ...    example: 8946. Warning: currently this keyword does not support comments left in the query, as there is no
    ...    cleanup or linearizing done on the query.
    [Arguments]    ${target_query}
    ...    ${target_item_no}

    ${result}=    Modify a string replacing desired value based on the provided regex pattern
    ...    target_query=${target_query}
    ...    regex_pattern=${REGEX_PATTERN_ITEM_NO}
    ...    replace_with_value=${target_item_no}
    RETURN    ${result}

Pick env value or default
    [Documentation]    Return ${env_value} when non-empty, otherwise ${default_value}.
    [Arguments]    ${env_value}    ${default_value}

    IF    '${env_value}' != ''
        RETURN    ${env_value}
    ELSE
        RETURN    ${default_value}
    END

Resolve database password from secret or default
    [Documentation]    Prefer RF 7.4 Secret env override when set; otherwise use the static default string.
    [Arguments]    ${default_password}

    ${secret_password}=    Evaluate    $ENV_DB_PASSWORD.value
    IF    '${secret_password}' != ''
        RETURN    ${secret_password}
    ELSE
        RETURN    ${default_password}
    END

Build database info dictionary from environment
    [Documentation]    Build a database info dictionary using environment variables if present; falls back to provided
    ...    defaults. Password prefers the RF 7.4 Secret env value when set.
    [Arguments]    &{defaults}

    ${db_host}=    Pick env value or default    ${ENV_DB_HOST}    ${defaults.dbHost}
    ${db_port}=    Pick env value or default    ${ENV_DB_PORT}    ${defaults.dbPort}
    ${db_service_name}=    Pick env value or default    ${ENV_DB_SERVICE_NAME}    ${defaults.dbServiceName}
    ${db_user}=    Pick env value or default    ${ENV_DB_USER}    ${defaults.dbUser}
    ${db_api_module_name}=    Pick env value or default    ${ENV_DB_API_MODULE}    ${defaults.dbApiModuleName}
    ${db_password}=    Resolve database password from secret or default    ${defaults.dbPassword}
    VAR    &{result}=
    ...    dbHost=${db_host}
    ...    dbPort=${db_port}
    ...    dbServiceName=${db_service_name}
    ...    dbUser=${db_user}
    ...    dbPassword=${db_password}
    ...    dbApiModuleName=${db_api_module_name}
    RETURN    &{result}

Modify the given query replacing an updated date placeholder with the actual updated date
    [Documentation]    Within the given query string find :VAR_UPDATED_DATE and replace with the correct updated date
    ...    value, example 2024-04-12 14:14. Warning: currently this keyword does not support comments left in the query,
    ...    as there is no cleanup or linearizing done on the query.
    [Arguments]    ${target_query}
    ...    ${target_updated_date}

    ${result}=    Modify a string replacing desired value based on the provided regex pattern
    ...    target_query=${target_query}
    ...    regex_pattern=${REGEX_PATTERN_UPDATED_DATE}
    ...    replace_with_value=${target_updated_date}
    RETURN    ${result}

Modify the given query adding a target boolean
    [Documentation]    Within the given query string find :BOOLEAN and replace with the provided boolean.
    ...    Warning: currently this keyword does not support comments left in the query, as there is no cleanup
    ...    or linearizing done on the query.
    [Arguments]    ${target_query}
    ...    ${target_bool}

    ${result}=    Modify a string replacing desired value based on the provided regex pattern
    ...    target_query=${target_query}
    ...    regex_pattern=${REGEX_PATTERN_BOOLEAN}
    ...    replace_with_value=${target_bool}
    RETURN    ${result}

Demonstrate building database info dictionary from environment (no connection)
    [Documentation]    Compose a DB info dictionary using environment variables (if set), falling back to provided
    ...    defaults. This keyword does not open a database connection.
    [Arguments]    ${defaults}=${PROJECT_POSTGRESQL_DB}

    &{db}=    Build database info dictionary from environment    &{defaults}
    Dictionary Should Contain Key    &{db}    dbHost
    Dictionary Should Contain Key    &{db}    dbPort
    Dictionary Should Contain Key    &{db}    dbServiceName
    Dictionary Should Contain Key    &{db}    dbUser
    Dictionary Should Contain Key    &{db}    dbApiModuleName
    Log
    ...    DB config (redacted): host=${db.dbHost} port=${db.dbPort}
    ...    db=${db.dbServiceName} user=${db.dbUser} module=${db.dbApiModuleName}
