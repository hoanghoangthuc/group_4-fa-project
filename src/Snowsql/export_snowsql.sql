!set variable_substitution=true;


select CURRENT_TIMESTAMP, CURRENT_USER;

select 'Export DimDate from snowflake' as Process;
COPY INTO @%DimDate/Export_snowflake/DimDate.csv from DimDate file_format = (format_name ='stage.csv_file' compression=none) single = True max_file_size = 5000000000 OVERWRITE=TRUE;
GET @%DimDate/Export_snowflake/DimDate.csv file://&{folder};

select 'Export DimLocation from snowflake' as Process;
COPY INTO @%DimLocation/Export_snowflake/DimLocation.csv from DimLocation file_format = (format_name ='stage.csv_file' compression=none) single = True max_file_size = 5000000000 OVERWRITE=TRUE;
GET @%DimLocation/Export_snowflake/DimLocation.csv file://&{folder};

select 'Export DimWarehouse from snowflake' as Process;
COPY INTO @%DimWarehouse/Export_snowflake/DimWarehouse.csv from DimWarehouse file_format = (format_name ='stage.csv_file' compression=none) single = True max_file_size = 5000000000 OVERWRITE=TRUE;
GET @%DimWarehouse/Export_snowflake/DimWarehouse.csv file://&{folder};

select 'Export DimProduct from snowflake' as Process;
COPY INTO @%DimProduct/Export_snowflake/DimProduct.csv from DimProduct file_format = (format_name ='stage.csv_file' compression=none) single = True max_file_size = 5000000000 OVERWRITE=TRUE;
GET @%DimProduct/Export_snowflake/DimProduct.csv file://&{folder};

select 'Export FactImport from snowflake' as Process;
COPY INTO @%FactImport/Export_snowflake/FactImport.csv from FactImport file_format = (format_name ='stage.csv_file' compression=none) single = True max_file_size = 5000000000 OVERWRITE=TRUE;
GET @%FactImport/Export_snowflake/FactImport.csv file://&{folder};

select 'Export FactExport from snowflake' as Process;
COPY INTO @%FactExport/Export_snowflake/FactExport.csv from FactExport file_format = (format_name ='stage.csv_file' compression=none) single = True max_file_size = 5000000000 OVERWRITE=TRUE;
GET @%FactExport/Export_snowflake/FactExport.csv file://&{folder};

!quit