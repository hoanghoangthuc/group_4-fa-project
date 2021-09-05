

create or replace procedure data_into_nds_location()
returns string
language javascript
as
$$ 
    var sql_command =` select max(t.LOCATION_ID) maxid from nds.location t`;
    var statement1 = snowflake.createStatement( {sqlText: sql_command} );
    var result_set1 = statement1.execute();
    result_set1.next();
    if (result_set1.getColumnValue(1)===null)
    {
    maxid=0;
    }
    else
    {
    maxid=result_set1.getColumnValue(1);
    }
    try {
    sql_command= `merge into nds.location
        using (select row_number() over (order by 1) rn,* from stage.location) t 
        on nds.location.uuid=t.uuid
        when matched then
        update set ADDRESS=t.ADDRESS,LAT=t.LAT,LONG=t.LONG,
                    CITY=t.CITY,COUNTRY_CODE=t.COUNTRY_CODE,COUNTRY_NAME=t.COUNTRY_NAME,STATES=t.STATES,LASTEDITEDBY=t.LASTEDITEDBY,LASTEDITEDWHEN=CURRENT_TIMESTAMP()
        when not matched then
        insert (LOCATION_ID,SOURCE_LOCATION_ID,ADDRESS,LAT,LONG,CITY,COUNTRY_CODE,COUNTRY_NAME,STATES,UUID,LASTEDITEDBY,LASTEDITEDWHEN)
                values (t.rn+:1,t.SOURCE_LOCATION_ID,t.ADDRESS,t.LAT,t.LONG,t.CITY,t.COUNTRY_CODE,t.COUNTRY_NAME,t.STATES,t.UUID,t.LASTEDITEDBY,CURRENT_TIMESTAMP())`
    statement1 = snowflake.createStatement( {sqlText: sql_command,binds:[maxid]});
    result_set1 = statement1.execute();
    result_set1.next();
    result = "Number of rows affected: " +result_set1.getColumnValue(1);
    }
    catch (err)  {
        result = "Failed";
        snowflake.execute({
        sqlText: `insert into UTILS.Error_log VALUES (?,?,?,?)`
        ,binds: [err.code, err.state, err.message, err.stackTraceTxt]});
        
    }
    return(result);
$$;



create or replace procedure data_into_nds_product()
returns string
language javascript
as
$$ 
    var sql_command =` select max(t.PRODUCT_ID) maxid from nds.product t`;
    var statement1 = snowflake.createStatement( {sqlText: sql_command} );
    var result_set1 = statement1.execute();
    result_set1.next();
    if (result_set1.getColumnValue(1)===null)
    {
    maxid=0;
    }
    else
    {
    maxid=result_set1.getColumnValue(1);
    }
    try {
    sql_command= `merge into nds.product
        using (select row_number() over (order by 1) rn,* from stage.product) t 
        on nds.product.uuid=t.uuid
        when matched then
        update set PRODUCT_NAME=t.PRODUCT_NAME,PRODUCT_CATEGORY=t.PRODUCT_CATEGORY,PRODUCT_CODE=t.PRODUCT_CODE,
                    WEIGHT=t.WEIGHT,LASTEDITEDBY=t.LASTEDITEDBY,LASTEDITEDWHEN=CURRENT_TIMESTAMP()
        when not matched then
        insert (PRODUCT_ID,SOURCE_PRODUCT_ID,PRODUCT_NAME,PRODUCT_CATEGORY,PRODUCT_CODE,WEIGHT,UUID,LASTEDITEDBY,LASTEDITEDWHEN)
                values (t.rn+:1,0,t.PRODUCT_NAME,t.PRODUCT_CATEGORY,t.PRODUCT_CODE,t.WEIGHT,t.UUID,t.LASTEDITEDBY,CURRENT_TIMESTAMP())`
    statement1 = snowflake.createStatement( {sqlText: sql_command,binds:[maxid]});
    result_set1 = statement1.execute();
    result_set1.next();
    result = "Number of rows affected: " +result_set1.getColumnValue(1);
    }
    catch (err)  {
        result = "Failed";
        snowflake.execute({
        sqlText: `insert into UTILS.Error_log VALUES (?,?,?,?)`
        ,binds: [err.code, err.state, err.message, err.stackTraceTxt]});
        
    }
    return(result);
$$;


create or replace procedure data_into_nds_customer()
returns string
language javascript
as
$$ 
    var sql_command =` select max(t.CUSTOMER_ID) maxid from nds.customer t`;
    var statement1 = snowflake.createStatement( {sqlText: sql_command} );
    var result_set1 = statement1.execute();
    result_set1.next();
    if (result_set1.getColumnValue(1)===null)
    {
    maxid=0;
    }
    else
    {
    maxid=result_set1.getColumnValue(1);
    }
    try {
    sql_command= `merge into nds.customer
        using (select row_number() over (order by 1) rn,sc.*,nl.LOCATION_ID n_locationid from stage.customer sc 
              inner join stage.location sl on sc.LOCATION_ID=sl.LOCATION_ID 
              inner join nds.location nl on nl.uuid=sl.uuid) t 
        on nds.customer.uuid=t.uuid
        when matched then
        update set NAME=t.NAME,USERNAME=t.USERNAME,SEX=t.SEX,
                    MAIL=t.MAIL,BIRTHDATE=t.BIRTHDATE,LOCATION_ID=t.n_locationid,PHONE=t.PHONE,LASTEDITEDBY=t.LASTEDITEDBY,LASTEDITEDWHEN=CURRENT_TIMESTAMP()
        when not matched then
        insert (CUSTOMER_ID,SOURCE_CUSTOMER_ID,NAME,USERNAME,SEX,MAIL,BIRTHDATE,LOCATION_ID,PHONE,UUID,LASTEDITEDBY,LASTEDITEDWHEN)
                values (t.rn+:1,0,t.NAME,t.USERNAME,t.SEX,t.MAIL,t.BIRTHDATE,t.n_locationid,t.PHONE,t.UUID,t.LASTEDITEDBY,CURRENT_TIMESTAMP())`
    statement1 = snowflake.createStatement( {sqlText: sql_command,binds:[maxid]});
    result_set1 = statement1.execute();
    result_set1.next();
    result = "Number of rows affected: " +result_set1.getColumnValue(1);
    }
    catch (err)  {
        result = "Failed";
        snowflake.execute({
        sqlText: `insert into UTILS.Error_log VALUES (?,?,?,?)`
        ,binds: [err.code, err.state, err.message, err.stackTraceTxt]});
        
    }
    return(result);
$$;


create or replace procedure data_into_nds_supplier()
returns string
language javascript
as
$$ 
    var sql_command =` select max(t.SUPPLIER_ID) maxid from nds.supplier t`;
    var statement1 = snowflake.createStatement( {sqlText: sql_command} );
    var result_set1 = statement1.execute();
    result_set1.next();
    if (result_set1.getColumnValue(1)===null)
    {
    maxid=0;
    }
    else
    {
    maxid=result_set1.getColumnValue(1);
    }
    try {
    sql_command= `merge into nds.supplier
        using (select row_number() over (order by 1) rn,ss.*,nl.LOCATION_ID n_locationid from stage.supplier ss 
              inner join stage.location sl on ss.LOCATION_ID=sl.LOCATION_ID 
              inner join nds.location nl on nl.uuid=sl.uuid) t 
        on nds.supplier.uuid=t.uuid
        when matched then
        update set SUPPLIER_NAME=t.SUPPLIER_NAME,LOCATION_ID=t.n_locationid,LASTEDITEDBY=t.LASTEDITEDBY,LASTEDITEDWHEN=CURRENT_TIMESTAMP()
        when not matched then
        insert (SUPPLIER_ID,SOURCE_SUPPLIER_ID,SUPPLIER_NAME,LOCATION_ID,UUID,LASTEDITEDBY,LASTEDITEDWHEN)
                values (t.rn+:1,0,t.SUPPLIER_NAME,t.n_locationid,t.UUID,t.LASTEDITEDBY,CURRENT_TIMESTAMP())`
    statement1 = snowflake.createStatement( {sqlText: sql_command,binds:[maxid]});
    result_set1 = statement1.execute();
    result_set1.next();
    result = "Number of rows affected: " +result_set1.getColumnValue(1);
    }
    catch (err)  {
        result = "Failed";
        snowflake.execute({
        sqlText: `insert into UTILS.Error_log VALUES (?,?,?,?)`
        ,binds: [err.code, err.state, err.message, err.stackTraceTxt]});
        
    }
    return(result);
$$;

create or replace procedure data_into_nds_warehouse()
returns string
language javascript
as
$$ 
    var sql_command =` select max(t.WAREHOUSE_ID) maxid from nds.warehouse t`;
    var statement1 = snowflake.createStatement( {sqlText: sql_command} );
    var result_set1 = statement1.execute();
    result_set1.next();
    if (result_set1.getColumnValue(1)===null)
    {
    maxid=0;
    }
    else
    {
    maxid=result_set1.getColumnValue(1);
    }
    try {
    sql_command= `merge into nds.warehouse
        using (select row_number() over (order by 1) rn,sw.*,nl.LOCATION_ID n_locationid from stage.warehouse sw
              inner join stage.location sl on sw.LOCATION_ID=sl.LOCATION_ID 
              inner join nds.location nl on nl.uuid=sl.uuid) t 
        on nds.warehouse.uuid=t.uuid
        when matched then
        update set WAREHOUSE_NAME=t.WAREHOUSE_NAME,WAREHOUSE_COST=t.WAREHOUSE_COST,LOCATION_ID=t.n_locationid,LASTEDITEDBY=t.LASTEDITEDBY,LASTEDITEDWHEN=CURRENT_TIMESTAMP()
        when not matched then
        insert (WAREHOUSE_ID,SOURCE_WAREHOUSE_ID,WAREHOUSE_NAME,WAREHOUSE_COST,LOCATION_ID,UUID,LASTEDITEDBY,LASTEDITEDWHEN)
                values (t.rn+:1,0,t.WAREHOUSE_NAME,t.WAREHOUSE_COST,t.n_locationid,t.UUID,t.LASTEDITEDBY,CURRENT_TIMESTAMP())`
    statement1 = snowflake.createStatement( {sqlText: sql_command,binds:[maxid]});
    result_set1 = statement1.execute();
    result_set1.next();
    result = "Number of rows affected: " +result_set1.getColumnValue(1);
    }
    catch (err)  {
        result = "Failed";
        snowflake.execute({
        sqlText: `insert into UTILS.Error_log VALUES (?,?,?,?)`
        ,binds: [err.code, err.state, err.message, err.stackTraceTxt]});
        
    }
    return(result);
$$;




create or replace procedure data_into_nds_storage()
returns string
language javascript
as
$$ 
    var sql_command =` select max(t.STORAGEID) maxid from nds.storage t`;
    var statement1 = snowflake.createStatement( {sqlText: sql_command} );
    var result_set1 = statement1.execute();
    result_set1.next();
    if (result_set1.getColumnValue(1)===null)
    {
    maxid=0;
    }
    else
    {
    maxid=result_set1.getColumnValue(1);
    }
    try {
    sql_command= `merge into nds.storage
        using (select row_number() over (order by 1) rn,ss.*,np.product_id n_product_id,nw.WAREHOUSE_ID n_WAREHOUSE_ID from stage.storage ss
              inner join stage.product sp on sp.product_id=ss.product_id
              inner join nds.product np on np.uuid=sp.uuid
              inner join stage.warehouse sw on sw.WAREHOUSE_ID=ss.WAREHOUSE_ID
              inner join nds.warehouse nw on nw.uuid=sw.uuid) t 
        on nds.storage.uuid=t.uuid
        when matched then
        update set PRODUCT_ID=t.n_product_id,WAREHOUSE_ID=t.n_WAREHOUSE_ID,CAPACITY=t.CAPACITY,QUANTITY=t.QUANTITY,LASTEDITEDBY=t.LASTEDITEDBY,LASTEDITEDWHEN=CURRENT_TIMESTAMP()
        when not matched then
        insert (STORAGEID,SOURCE_STORAGEID,PRODUCT_ID,WAREHOUSE_ID,CAPACITY,QUANTITY,UUID,LASTEDITEDBY,LASTEDITEDWHEN)
                values (t.rn+:1,0,t.n_product_id,t.n_WAREHOUSE_ID,t.CAPACITY,t.QUANTITY,t.UUID,t.LASTEDITEDBY,CURRENT_TIMESTAMP())`
    statement1 = snowflake.createStatement( {sqlText: sql_command,binds:[maxid]});
    result_set1 = statement1.execute();
    result_set1.next();
    result = "Number of rows affected: " +result_set1.getColumnValue(1);
    }
    catch (err)  {
        result = "Failed";
        snowflake.execute({
        sqlText: `insert into UTILS.Error_log VALUES (?,?,?,?)`
        ,binds: [err.code, err.state, err.message, err.stackTraceTxt]});
        
    }
    return(result);
$$;


create or replace procedure data_into_nds_export()
returns string
language javascript
as
$$ 
    var sql_command =` select max(t.ORDER_ID) maxid from nds.export t`;
    var statement1 = snowflake.createStatement( {sqlText: sql_command} );
    var result_set1 = statement1.execute();
    result_set1.next();
    if (result_set1.getColumnValue(1)===null)
    {
    maxid=0;
    }
    else
    {
    maxid=result_set1.getColumnValue(1);
    }
    try {
    sql_command= `merge into nds.export
        using (select row_number() over (order by 1) rn,se.*,np.product_id n_product_id,nc.CUSTOMER_ID n_CUSTOMER_ID from stage.export se
              inner join stage.product sp on sp.product_id=se.CUSTOMER_ID
              inner join nds.product np on np.uuid=sp.uuid
              inner join stage.customer sc on sc.CUSTOMER_ID=se.CUSTOMER_ID
              inner join nds.customer nc on nc.uuid=sc.uuid) t 
        on nds.export.uuid=t.uuid
        when matched then
        update set PRODUCT_ID=t.n_product_id,CUSTOMER_ID=t.n_CUSTOMER_ID,QUANTITY=t.QUANTITY,DATE_ORDER=t.DATE_ORDER,DATE_SHIP=t.DATE_SHIP,DATE_DUE=t.DATE_DUE,SHIP_DISTANCE=t.SHIP_DISTANCE,SHIP_COST=t.SHIP_COST,
                LASTEDITEDBY=t.LASTEDITEDBY,LASTEDITEDWHEN=CURRENT_TIMESTAMP()
        when not matched then
        insert (ORDER_ID,SOURCE_ORDER_ID,PRODUCT_ID,CUSTOMER_ID,QUANTITY,DATE_ORDER,DATE_SHIP,DATE_DUE,SHIP_DISTANCE,SHIP_COST,UUID,LASTEDITEDBY,LASTEDITEDWHEN)
                values (t.rn+:1,0,t.n_product_id,t.n_CUSTOMER_ID,t.QUANTITY,t.DATE_ORDER,t.DATE_SHIP,t.DATE_DUE,t.SHIP_DISTANCE,t.SHIP_COST,t.UUID,t.LASTEDITEDBY,CURRENT_TIMESTAMP())`
    statement1 = snowflake.createStatement( {sqlText: sql_command,binds:[maxid]});
    result_set1 = statement1.execute();
    result_set1.next();
    result = "Number of rows affected: " +result_set1.getColumnValue(1);
    }
    catch (err)  {
        result = "Failed";
        snowflake.execute({
        sqlText: `insert into UTILS.Error_log VALUES (?,?,?,?)`
        ,binds: [err.code, err.state, err.message, err.stackTraceTxt]});
        
    }
    return(result);
$$;



create or replace procedure data_into_nds_import()
returns string
language javascript
as
$$ 
    var sql_command =` select max(t.IMPORTID) maxid from nds.import t`;
    var statement1 = snowflake.createStatement( {sqlText: sql_command} );
    var result_set1 = statement1.execute();
    result_set1.next();
    if (result_set1.getColumnValue(1)===null)
    {
    maxid=0;
    }
    else
    {
    maxid=result_set1.getColumnValue(1);
    }
    try {
    sql_command= `merge into nds.import
        using (select row_number() over (order by 1) rn,si.*,np.product_id n_product_id,nw.WAREHOUSE_ID n_WAREHOUSE_ID,ns.SUPPLIER_ID n_SUPPLIER_ID from stage.import si
              inner join stage.WAREHOUSE sw on sw.WAREHOUSE_ID=si.WAREHOUSE_ID
              inner join nds.WAREHOUSE nw on nw.uuid=sw.uuid
              inner join stage.PRODUCT sp on sp.PRODUCT_ID=si.PRODUCT_ID
              inner join nds.PRODUCT np on np.uuid=sp.uuid
              inner join stage.SUPPLIER ss on ss.SUPPLIER_ID=si.SUPPLIER_ID
              inner join nds.SUPPLIER ns on ns.SUPPLIER_ID=ss.SUPPLIER_ID) t 
        on nds.import.uuid=t.uuid
        when matched then
        update set PRODUCT_ID=t.n_product_id,WAREHOUSE_ID=t.n_WAREHOUSE_ID,SUPPLIER_ID=t.n_SUPPLIER_ID,QUANTITY=t.QUANTITY,SHIP_DISTANCE=t.SHIP_DISTANCE,SHIP_COST=t.SHIP_COST,IMPORT_DATE=t.IMPORT_DATE,
                LASTEDITEDBY=t.LASTEDITEDBY,LASTEDITEDWHEN=CURRENT_TIMESTAMP()
        when not matched then
        insert (IMPORTID,SOURCE_IMPORT_ID,PRODUCT_ID,WAREHOUSE_ID,SUPPLIER_ID,QUANTITY,SHIP_DISTANCE,SHIP_COST,IMPORT_DATE,UUID,LASTEDITEDBY,LASTEDITEDWHEN)
                values (t.rn+:1,0,t.n_product_id,t.n_WAREHOUSE_ID,t.n_SUPPLIER_ID,t.QUANTITY,t.SHIP_DISTANCE,t.SHIP_COST,t.IMPORT_DATE,t.UUID,t.LASTEDITEDBY,CURRENT_TIMESTAMP())`
    statement1 = snowflake.createStatement( {sqlText: sql_command,binds:[maxid]});
    result_set1 = statement1.execute();
    result_set1.next();
    result = "Number of rows affected: " +result_set1.getColumnValue(1);
    }
    catch (err)  {
        result = "Failed";
        snowflake.execute({
        sqlText: `insert into UTILS.Error_log VALUES (?,?,?,?)`
        ,binds: [err.code, err.state, err.message, err.stackTraceTxt]});
        
    }
    return(result);
$$;
