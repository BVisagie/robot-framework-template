*** Settings ***
Documentation  This is a location for storing page locator data related to the Wikipedia landing page
...            https://playwright.dev/docs/pom#introduction

*** Variables ***

# Pre login screen landing page
${english_language_button_by_title}=  //a[@title='English — Wikipedia — The Free Encyclopedia']
${portuguese_language_button_by_xpath}=  //strong[text()='Português']