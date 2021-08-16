!set variable_substitution=true;


select CURRENT_TIMESTAMP, CURRENT_USER;
select 'Export file to /Export_snowflake' as Process;


--PUT file:///&{folder}/*Warehouse*.csv @%Warehouse;
COPY INTO '@%DIMDATE/Export_snowflake/' from PROJECT1.MODEL.DIMDATE file_format = (format_name ='CSV_FILE' compression='GZIP') OVERWRITE=TRUE;
GET @%DIMDATE/Export_snowflake/ file://&{folder};

COPY INTO '@%DIMCUSTOMER/Export_snowflake/' from PROJECT1.MODEL.DIMCUSTOMER file_format = (format_name ='CSV_FILE' compression='GZIP') OVERWRITE=TRUE;
GET @%DIMCUSTOMER/Export_snowflake/ file://&{folder};

COPY INTO '@%DIMLOCATION/Export_snowflake/' from PROJECT1.MODEL.DIMLOCATION file_format = (format_name ='CSV_FILE' compression='GZIP') OVERWRITE=TRUE;
GET @%DIMLOCATION/Export_snowflake/ file://&{folder};

COPY INTO '@%DIMPRODUCT/Export_snowflake/' from PROJECT1.MODEL.DIMPRODUCT file_format = (format_name ='CSV_FILE' compression='GZIP') OVERWRITE=TRUE;
GET @%DIMPRODUCT/Export_snowflake/ file://&{folder};

COPY INTO '@%DIMWAREHOUSE/Export_snowflake/' from PROJECT1.MODEL.DIMWAREHOUSE file_format = (format_name ='CSV_FILE' compression='GZIP') OVERWRITE=TRUE;
GET @%DIMWAREHOUSE/Export_snowflake/ file://&{folder};

COPY INTO '@%FACTRECORD/Export_snowflake/' from PROJECT1.MODEL.FACTRECORD file_format = (format_name ='CSV_FILE' compression='GZIP') OVERWRITE=TRUE;
GET @%FACTRECORD/Export_snowflake/ file://&{folder};




--!quit