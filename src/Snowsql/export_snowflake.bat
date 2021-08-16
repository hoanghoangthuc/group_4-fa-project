SET file_path=%cd%
cd..
cd..
cd Data\Export_snowflake
SET folder=%cd%
cd %file_path%
@echo off
cls

echo Export Start>> export_log.txt

snowsql -a kq42353.southeast-asia.azure -u NhatLQ3 -d PROJECT1 -w STAGE -s MODEL -r SYSADMIN -f %file_path%\export_snowsql.sql -D folder=%folder% -o output_file=export_log.txt

echo Export Complete>> export_log.txt
echo --------------------------------------------------------------------------------------->> export_log.txt