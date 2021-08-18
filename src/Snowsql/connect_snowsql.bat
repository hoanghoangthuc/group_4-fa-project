SET file_path=%cd%
cd..
cd..
cd Data\work
SET folder=%cd%
cd %file_path%
@echo off
cls

echo Session Start>> snowsql_log.txt

snowsql -a yr27995.southeast-asia.azure -u ThucHH -d PROJECT1 -w STAGE -s STAGE -r SYSADMIN -f %file_path%\put_snowsql.sql -D folder=%folder% -o output_file=snowsql_log.txt

echo Session Complete>> log/snowsql_log.txt
echo --------------------------------------------------------------------------------------->> log/snowsql_log.txt