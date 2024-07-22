*** Settings ***
Documentation       Intended to host a collection of common / generic validation keywords that might be used in any
...    project. No project specific keywords should be placed within resources/common!


*** Keywords ***
Validate JSON Response Is List
    [Documentation]    This keyword ensures that the given JSON response is a list. ${is_list} Uses the Evaluate keyword
    ...    to execute Python's isinstance function, which checks if the provided response is of type list.
    [Arguments]    ${response}
    ${is_list}=    Evaluate    isinstance(${response}, list)
    Should Be True    ${is_list}    The response should be a list.

Is Dictionary Empty
    [Documentation]    Based on the given dictionaries length determine if it's empty.
    [Arguments]    &{dictionary}
    ${dictionary_length}=    Get Length    ${dictionary}
    IF    ${dictionary_length} == 0    The dictionary is empty.
