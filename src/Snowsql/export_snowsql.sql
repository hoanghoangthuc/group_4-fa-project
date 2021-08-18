!set variable_substitution=true;


select CURRENT_TIMESTAMP, CURRENT_USER;

select 'export DIMDATE from snowflake' as Process;
COPY INTO @%DIMDATE/Export_snowflake/DIMDATE.csv from PROJECT1.MODEL.DIMDATE file_format = (format_name ='CSV_FILE' compression=none) single = True max_file_size = 4900000000 OVERWRITE=TRUE;
GET @%DIMDATE/Export_snowflake/DIMDATE.csv file://&{folder};

select 'export DIMCUSTOMER from snowflake' as Process;
COPY INTO @%DIMCUSTOMER/Export_snowflake/DIMCUSTOMER.csv from PROJECT1.MODEL.DIMCUSTOMER file_format = (format_name ='CSV_FILE' compression=none) single = True max_file_size = 4900000000 OVERWRITE=TRUE;
GET @%DIMCUSTOMER/Export_snowflake/DIMCUSTOMER.csv file://&{folder};

select 'export DIMLOCATION_WAREHOUSE from snowflake' as Process;
COPY INTO @%DIMLOCATION_WAREHOUSE/Export_snowflake/DIMLOCATION_WAREHOUSE.csv from PROJECT1.MODEL.DIMLOCATION_WAREHOUSE file_format = (format_name ='CSV_FILE' compression=none) single = True max_file_size = 4900000000 OVERWRITE=TRUE;
GET @%DIMLOCATION_WAREHOUSE/Export_snowflake/DIMLOCATION_WAREHOUSE.csv file://&{folder};

select 'export DIMLOCATION_CUSTOMER from snowflake' as Process;
COPY INTO @%DIMLOCATION_CUSTOMER/Export_snowflake/DIMLOCATION_CUSTOMER.csv from PROJECT1.MODEL.DIMLOCATION_CUSTOMER file_format = (format_name ='CSV_FILE' compression=none) single = True max_file_size = 4900000000 OVERWRITE=TRUE;
GET @%DIMLOCATION_CUSTOMER/Export_snowflake/DIMLOCATION_CUSTOMER.csv file://&{folder};

select 'export DIMPRODUCT from snowflake' as Process;
COPY INTO @%DIMPRODUCT/Export_snowflake/DIMPRODUCT.csv from PROJECT1.MODEL.DIMPRODUCT file_format = (format_name ='CSV_FILE' compression=none) single = True max_file_size = 4900000000 OVERWRITE=TRUE;
GET @%DIMPRODUCT/Export_snowflake/DIMPRODUCT.csv file://&{folder};

select 'export DIMWAREHOUSE from snowflake' as Process;
COPY INTO @%DIMWAREHOUSE/Export_snowflake/DIMWAREHOUSE.csv from PROJECT1.MODEL.DIMWAREHOUSE file_format = (format_name ='CSV_FILE' compression=none) single = True max_file_size = 4900000000 OVERWRITE=TRUE;
GET @%DIMWAREHOUSE/Export_snowflake/DIMWAREHOUSE.csv file://&{folder};

select 'export FACTRECORD from snowflake' as Process;
COPY INTO @%FACTRECORD/Export_snowflake/FACTRECORD.csv from PROJECT1.MODEL.FACTRECORD file_format = (format_name ='CSV_FILE' compression=none) single = True max_file_size = 4900000000 OVERWRITE=TRUE;
GET @%FACTRECORD/Export_snowflake/FACTRECORD.csv file://&{folder};




--!quit