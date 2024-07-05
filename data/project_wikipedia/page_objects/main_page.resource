*** Settings ***
Documentation  This is a location for storing page locator data related to the Wikipedia main page
...            https://playwright.dev/docs/pom#introduction

*** Variables ***

${main_page_simple_search_input}=  //input[@type='search']  # Needed a language agnostic hook here, as HTML values change based on language

