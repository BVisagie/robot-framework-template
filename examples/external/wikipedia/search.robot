*** Settings ***
Documentation     Optional Wikipedia search with teardown and bounded Browser assertions.

Library           Browser

Suite Setup       Open Wikipedia
Suite Teardown    Close Browser    ALL

Test Tags         external    ui


*** Variables ***
${WIKIPEDIA_BASE_URL}    %{WIKIPEDIA_BASE_URL=https://en.wikipedia.org/wiki/Main_Page}
${HEADLESS_BROWSER}      %{HEADLESS_BROWSER=true}


*** Test Cases ***
Search leads to the Robot Framework article
    [Documentation]    Exercise a real site only when this external demo is explicitly selected.
    Fill Text    id=searchInput    Robot Framework
    Press Keys    id=searchInput    Enter
    Get Text    id=firstHeading    ==    Robot Framework


*** Keywords ***
Open Wikipedia
    [Documentation]    Open a headless Chromium context on the configured Wikipedia URL.
    VAR    ${headless: bool}    ${HEADLESS_BROWSER}
    New Browser    chromium    headless=${headless}
    Set Browser Timeout    10 seconds
    New Context
    New Page    ${WIKIPEDIA_BASE_URL}
