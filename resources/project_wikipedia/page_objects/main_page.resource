*** Settings ***
Documentation       This is a location for storing page locator data related to the Wikipedia main page
...                 https://playwright.dev/docs/pom#introduction


*** Variables ***
# Prefer the primary search input id; Wikipedia also renders a sticky duplicate type=search field.
${MAIN_PAGE_SIMPLE_SEARCH_INPUT}=       id=searchInput
