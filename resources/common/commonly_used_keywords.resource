*** Settings ***
Documentation       This is a location for storing shared keywords that may be applicable to any project.
...                 No project specific keywords should be placed within resources/common!

Resource            ../../libraries/robot_framework/common.resource


*** Keywords ***
Generate DateTime String
    [Documentation]    Generates a date and time string based on the given format expectation
    ...    Defaults to: %d%m%H%M%S example: 1311152025
    [Arguments]    ${date_time_format}=%d%m%H%M%S

    ${result}=    Get Current Date    result_format=${date_time_format}
    RETURN    ${result}

Generate DateTime String With Hour Offset
    [Documentation]    Generates a date and time string based on the given format expectation with an optional hour
    ...    offset. Defaults to: %d%m%H%M%S example: 1311152025
    [Arguments]    ${date_time_format}=%d%m%H%M%S
    ...    ${hour_offset}=1

    ${now}=    Get Current Date
    ${result}=    Subtract Time From Date
    ...    date=${now}
    ...    time=${hour_offset} hour
    ...    result_format=${date_time_format}

    RETURN    ${result}

Generate DateTime String With Day Offset
    [Documentation]    Generates a date and time string based on the given format expectation with an optional day
    ...    offset. Defaults to: %d%m%H%M%S example: 1311152025
    [Arguments]    ${date_time_format}=%d%m%H%M%S
    ...    ${day_offset}=0

    ${now}=    Get Current Date
    ${result}=    Subtract Time From Date    date=${now}    time=${day_offset} day    result_format=${date_time_format}

    RETURN    ${result}

Convert JSON to Dict
    [Documentation]    This function converts a JSON string to a RobotFramework dictionary.
    [Arguments]    ${json_string}

    ${dict}=    Evaluate    json.loads(''${json_string}'')    json
    RETURN    ${dict}

Generate DateTime String With Minutes Offset
    [Documentation]    Generates a date and time string based on the given format expectation with an optional minutes
    ...    offset. Defaults to: %d%m%H%M%S example: 1311152025
    [Arguments]    ${date_time_format}=%d%m%H%M%S
    ...    ${minutes_offset}=0

    ${now}=    Get Current Date
    ${result}=    Subtract Time From Date
    ...    date=${now}
    ...    time=${minutes_offset} minutes
    ...    result_format=${date_time_format}

    RETURN    ${result}
