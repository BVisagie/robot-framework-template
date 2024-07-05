*** Settings ***
Documentation  Whenever a query has values that will need to be modified at runtime, this may be achieved using the
...  below method of adding an identifier to be used in a regular expression find and replace into the given query.

*** Variables ***
${regex_pattern_item_no}                                (:VAR_ITEM_NO)
${regex_pattern_boolean}                                (:BOOLEAN)
${regex_pattern_updated_date}                           (:VAR_UPDATED_DATE)