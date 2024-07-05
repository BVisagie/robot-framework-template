*** Settings ***
Documentation  This is a location for storing some example static queries for both Oracle and PostgreSQL

*** Variables ***

${retrieve_some_data_example_oracle}=
...  SELECT i.weight
...    FROM item i
...   WHERE i.no = :VAR_ITEM_NO

${retrieve_some_data_example_postgresql}=
...  SELECT p.id
...  FROM product p
...  WHERE p.deleted = :BOOLEAN
...    AND p.item_number = :VAR_ITEM_NO
...    AND p.updated_date > ':VAR_UPDATED_DATE';