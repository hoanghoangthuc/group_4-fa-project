SET file_path=%cd%
cd..
cd..
cd Data\Export_snowflake
SET folder=%cd%
cd %file_path%
@echo off
cls

echo Export Start>> export_log.txt

snowsql -a yr27995.southeast-asia.azure -u ThucHH -d PROJECT1 -w WAREHOUSE -s MODEL -r SYSADMIN -f %file_path%\export_snowsql.sql -D folder=%folder% -o output_file=export_log.txt

echo Export Complete>> export_log.txt
echo --------------------------------------------------------------------------------------->> export_log.txt