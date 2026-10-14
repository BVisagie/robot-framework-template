*** Settings ***
Documentation    Stable selectors and interactions for the local catalog page.

Library          Browser


*** Variables ***
${CATALOG_SEARCH}      css=#search
${CATALOG_ROWS}        css=#items tr
${CATALOG_NAME}        css=#name
${CATALOG_QUANTITY}    css=#quantity
${CATALOG_SUBMIT}      css=button[type=submit]
${CATALOG_STATUS}      css=#status


*** Keywords ***
Filter catalog items
    [Documentation]    Type a filter and let Browser assertions wait for the matching response.
    [Arguments]    ${query}
    Fill Text    ${CATALOG_SEARCH}    ${query}

Catalog should contain only
    [Documentation]    Retry assertions until exactly one matching row is visible.
    [Arguments]    ${name}
    Get Element Count    ${CATALOG_ROWS}    ==    1
    Get Text    ${CATALOG_ROWS}    contains    ${name}

Add item through catalog form
    [Documentation]    Submit the form and verify its accessible success message.
    [Arguments]    ${name}    ${quantity: int}
    Fill Text    ${CATALOG_NAME}    ${name}
    Fill Text    ${CATALOG_QUANTITY}    ${quantity}
    Click    ${CATALOG_SUBMIT}
    Get Text    ${CATALOG_STATUS}    ==    Added ${name}
