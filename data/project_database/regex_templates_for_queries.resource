*** Settings ***
Documentation       Whenever a query has values that will need to be modified at runtime, this may be achieved using the
...                 below method of adding an identifier to be used in a regular expression find and replace into the
...                 given query.


*** Variables ***
${REGEX_PATTERN_ITEM_NO}            (:VAR_ITEM_NO)
${REGEX_PATTERN_BOOLEAN}            (:BOOLEAN)
${REGEX_PATTERN_UPDATED_DATE}       (:VAR_UPDATED_DATE)
