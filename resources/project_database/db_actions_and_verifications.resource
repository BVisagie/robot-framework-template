*** Settings ***
Documentation       Some example test actions that will be performed during database interactions.

Resource            ../common/commonly_used_database_keywords.resource
Resource            ../common/commonly_used_keywords.resource
Resource            ../../data/project_database/static_database_info.resource
Resource            ../../data/project_database/dummy_queries.resource
Resource            ../../data/project_database/regex_templates_for_queries.resource
Library             ../common_python/common_functions.py


*** Keywords ***
Example Oracle database test
    [Documentation]    Select query focused test example (Oracle)

    ${random_item_number}=    get_random_int    min_value=1    max_value=1000

    # The below keyword will modify the static query retrieve_some_data_example_oracle in place, thereby replacing
    # :VAR_ITEM_NO within the query with the provided value.
    ${RETRIEVE_SOME_DATA_EXAMPLE_ORACLE}=
    ...    Modify the given query replacing an item placeholder with the actual item
    ...    target_query=${RETRIEVE_SOME_DATA_EXAMPLE_ORACLE}
    ...    target_item_no=${random_item_number}

    ${oracle_query_result_row}=    Execute SQL Query
    ...    query=${RETRIEVE_SOME_DATA_EXAMPLE_ORACLE}
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

    ${RETRIEVE_SOME_DATA_EXAMPLE_POSTGRESQL}=    Modify the given query adding a Item, Updated Date and Boolean
    ...    target_query=${RETRIEVE_SOME_DATA_EXAMPLE_POSTGRESQL}
    ...    target_item_no=${random_item_number}
    ...    target_updated_date_time=${updated_date_time_stamp}
    ...    target_bool=${False}

    ${postgresql_query_result_row}=    Execute SQL Query
    ...    query=${RETRIEVE_SOME_DATA_EXAMPLE_POSTGRESQL}
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

    # 1)
    ${target_query}=    Modify the given query replacing an item placeholder with the actual item
    ...    target_query=${target_query}
    ...    target_item_no=${target_item_no}

    # 2)
    ${target_query}=    Modify the given query replacing an updated date placeholder with the actual updated date
    ...    target_query=${target_query}
    ...    target_updated_date=${target_updated_date_time}

    # 3)
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
