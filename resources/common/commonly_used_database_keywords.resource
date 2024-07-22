*** Settings ***
Documentation       A suite of Keywords meant to cover all the common database actions that might need to occur.
...                 No project specific keywords should be placed within resources/common!

Resource            ../../libraries/robot_framework/database_library.resource
Resource            ../../libraries/robot_framework/common.resource
Resource            commonly_used_validation_keywords.resource


*** Keywords ***
Open connection to target database
    [Documentation]    TODO
    [Arguments]    &{target_database_information_dictionary}

    Is Dictionary Empty    &{target_database_information_dictionary}

    Log    Now attempting to connect to target test database: ${target_database_information_dictionary.dbHost}

    TRY
        DatabaseLibrary.connect to database
        ...    dbapiModuleName=${target_database_information_dictionary.dbApiModuleName}
        ...    dbName=${target_database_information_dictionary.dbServiceName}
        ...    dbUsername=${target_database_information_dictionary.dbUser}
        ...    dbPassword=${target_database_information_dictionary.dbPassword}
        ...    dbHost=${target_database_information_dictionary.dbHost}
        ...    dbPort=${target_database_information_dictionary.dbPort}
    EXCEPT    DatabaseError: ORA-12545: Connect failed because target host or object does not exist    AS    ${msg}
        Fail    Not connected to db. Perhaps your VPN connection has disconnected?    ${msg}
    END

Close connection from the current database
    TRY
        DatabaseLibrary.Disconnect From Database
    EXCEPT    AttributeError: 'NoneType' object has no attribute 'close'    AS    ${msg}
        Fail    Failed to disconnect From Database ${msg}
    END

Execute SQL Query
    [Documentation]    Small wrapper around DatabaseLibrary.Query, to check whether the type of statement matches the
    ...    content. With a retry mechanism, if you need it.
    [Arguments]    ${query}
    ...    ${target_database_information_dictionary}
    ...    ${timeout}=5 seconds
    ...    ${retry_interval}=1 second
    ...    ${fail_timeout}=2 minutes
    [Timeout]    ${fail_timeout}
    [Documentation]    Small wrapper around DatabaseLibrary.Query, to check whether the type of statement matches the
    ...    content. With a retry mechanism, if you need it.

    LOG    ${query}
    Should Not Match Regexp
    ...    ${query}
    ...    ^\\s*update\\s
    ...    msg=This SQL statement is not just a select! Contains: update. Use: 'Execute Sql Statement'.
    Should Not Match Regexp
    ...    ${query}
    ...    ^\\s*delete\\s
    ...    msg=This SQL statement is not just a select! Contains: delete. Use: 'Execute Sql Statement'.
    Should Not Match Regexp
    ...    ${query}
    ...    ^\\s*insert\\s
    ...    msg=This SQL statement is not just a select! Contains: insert. Use: 'Execute Sql Statement'.

    Open connection to target database    &{target_database_information_dictionary}

    ${result}=    Wait Until Keyword Succeeds    ${timeout}    ${retry_interval}    DatabaseLibrary.Query    ${query}

    Close connection from the current database

    RETURN    ${result}

Execute SQL Statement
    [Documentation]    Small wrapper around DatabaseLibrary.Execute Sql String, to check whether the type of statement
    ...    matches the content.
    [Arguments]    ${statement}
    ...    ${target_database_information_dictionary}
    ...    ${timeout}=5 minutes
    ...    ${omitTrailingSemicolon}=${True}
    [Timeout]    ${timeout}

    LOG    ${statement}
    Should Contain Any
    ...    ${statement}
    ...    begin
    ...    declare
    ...    update
    ...    insert
    ...    delete
    ...    ignore_case=True
    ...    msg=This SQL statement does not seem to be a statement! Perhaps use: 'Execute sql query'.

    Open connection to target database    ${target_database_information_dictionary}

    DatabaseLibrary.Set Auto Commit    autoCommit=${True}
    DatabaseLibrary.Execute Sql String
    ...    sqlString=${statement}
    ...    omitTrailingSemicolon=${omitTrailingSemicolon} # See documentation regarding omitTrailingSemicolon.

    Close connection from the current database

Modify a string replacing desired value based on the provided regex pattern
    [Documentation]    Generic string function, within the given string find a value based on given regex and replace
    ...    with the value provided. Warning: this keyword does not support comments left inside of the target_query
    ...    query.
    [Arguments]    ${target_query}
    ...    ${regex_pattern}
    ...    ${replace_with_value}

    ${updated_query}=    Replace String Using Regexp
    ...    string=${target_query}
    ...    pattern=${regex_pattern}
    ...    replace_with=${replace_with_value}
    RETURN    ${updated_query}
