*** Settings ***
Documentation       This is a location for storing some example static queries for both Oracle and PostgreSQL


*** Variables ***
${RETRIEVE_SOME_DATA_EXAMPLE_ORACLE}=
...                                             SELECT i.weight
...                                             FROM item i
...                                             WHERE i.no = :VAR_ITEM_NO

${RETRIEVE_SOME_DATA_EXAMPLE_POSTGRESQL}=
...                                             SELECT p.id
...                                             FROM product p
...                                             WHERE p.deleted = :BOOLEAN
...                                             AND p.item_number = :VAR_ITEM_NO
...                                             AND p.updated_date > ':VAR_UPDATED_DATE';
