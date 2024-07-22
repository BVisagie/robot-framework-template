*** Settings ***
Documentation       This is a location for storing page locator data related to the Wikipedia main page
...                 https://playwright.dev/docs/pom#introduction


*** Variables ***
# Needed a language agnostic hook here, as HTML values change based on language
${MAIN_PAGE_SIMPLE_SEARCH_INPUT}=       //input[@type='search']
