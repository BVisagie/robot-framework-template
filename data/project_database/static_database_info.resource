*** Settings ***
Documentation       An area to host all project specific static database data.


*** Variables ***
&{PROJECT_ORACLE_DB}=
...                             dbHost=exampleOracleHost
...                             dbPort=1540
...                             dbServiceName=exampleOracleServiceName
...                             dbUser=exampleOracleUser
...                             dbPassword=exampleOraclePassword
...                             dbServiceId=exampleOracleServiceId
...                             dbApiModuleName=oracledb

&{PROJECT_POSTGRESQL_DB}=
...                             dbHost=examplePostgreSQLHost
...                             dbPort=1540
...                             dbServiceName=examplePostgreSQLServiceName
...                             dbUser=examplePostgreSQLUser
...                             dbPassword=examplePostgreSQLPassword
...                             dbServiceId=examplePostgreSQLServiceId
...                             dbApiModuleName=psycopg2
