SET file_path=%cd%
cd..
cd..
cd Log\SnowSQLLog
SET logpath=%cd%
cd..
cd..
cd Data\Export_snowflake
SET folder=%cd%
cd %file_path%
SET logdate=%date:~-4%%date:~3,2%%date:~0,2%
@echo off
cls

SET SNOWSQL_ACCOUNT=%1
SET SNOWSQL_USER=%2
SET SNOWSQL_PWD=%3

echo Unload Start>> "%logpath%"/snowsql"%logdate%".txt

snowsql -d Project2 -s Model -w PROJECT2_WH -r SYSADMIN -f "%file_path%\export_snowsql.sql" -D folder="%folder%" -o output_file="%logpath%"\snowsql"%logdate%".txt

echo Unload Complete>> "%logpath%"/snowsql"%logdate%".txt
echo --------------------------------------------------------------------------------------->> "%logpath%"/snowsql"%logdate%".txt