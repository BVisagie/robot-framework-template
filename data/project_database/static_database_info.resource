*** Settings ***
Documentation  An area to host all project specific static database data.

*** Variables ***

&{project_oracle_db}=
...  dbHost=exampleOracleHost
...  dbPort=1540
...  dbServiceName=exampleOracleServiceName
...  dbUser=exampleOracleUser
...  dbPassword=exampleOraclePassword
...  dbServiceId=exampleOracleServiceId
...  dbApiModuleName=oracledb

&{project_postgresql_db}=
...  dbHost=examplePostgreSQLHost
...  dbPort=1540
...  dbServiceName=examplePostgreSQLServiceName
...  dbUser=examplePostgreSQLUser
...  dbPassword=examplePostgreSQLPassword
...  dbServiceId=examplePostgreSQLServiceId
...  dbApiModuleName=psycopg2