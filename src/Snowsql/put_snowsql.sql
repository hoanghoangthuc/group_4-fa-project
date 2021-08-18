!set variable_substitution=true;


select CURRENT_TIMESTAMP, CURRENT_USER;
select 'Put file to STAGEGING.PRODUCT' as Process;



-- >> Copy from stage @Product to database.schema.table (product)
PUT file:///&{folder}/*Product*.csv @%Product;
COPY INTO PROJECT1.STAGE.Product purge = true file_format = CSV_FILE pattern = '.*Product.csv.gz'  ;

PUT file:///&{folder}/*Location*.csv @%Location;
COPY INTO PROJECT1.STAGE.Location  purge = true file_format = CSV_FILE pattern = '.*Location.csv.gz' ;

PUT file:///&{folder}/*Customer*.csv @%Customer;
COPY INTO PROJECT1.STAGE.Customer  purge = true  file_format = CSV_FILE pattern = '.*Customer.csv.gz';

PUT file:///&{folder}/*Datetime*.csv @%Datetime;
COPY INTO PROJECT1.STAGE.Datetime  purge = true  file_format = CSV_FILE pattern = '.*Datetime.csv.gz' ;

PUT file:///&{folder}/*Warehouse*.csv @%Warehouse;
COPY INTO PROJECT1.STAGE.Warehouse  purge = true  file_format = CSV_FILE pattern = '.*Warehouse.csv.gz' ;

PUT file:///&{folder}/*Record*.csv @%Record;
COPY INTO PROJECT1.STAGE.Record  purge = true  file_format = CSV_FILE pattern = '.*Record.csv.gz'  ;
--!quit