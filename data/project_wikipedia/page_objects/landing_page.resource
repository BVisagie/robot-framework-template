*** Settings ***
Documentation       This is a location for storing page locator data related to the Wikipedia landing page
...                 https://playwright.dev/docs/pom#introduction


*** Variables ***
# Pre login screen landing page
${ENGLISH_LANGUAGE_BUTTON_BY_TITLE}=        //a[@title='English — Wikipedia — The Free Encyclopedia']
${PORTUGUESE_LANGUAGE_BUTTON_BY_XPATH}=     //strong[text()='Português']
