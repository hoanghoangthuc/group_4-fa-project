USE DATABASE PROJECT2;

-- as
MERGE INTO NDS.Product as t
USING Stage.Product as s
ON t.uuid = s.uuid
WHEN MATCHED
    THEN 
        UPDATE SET t.Product_Code = s.Product_Code, t.Product_Name = s.Product_Name, t.Product_Category = s.Product_Category,
        t.Weight = s.Weight , t.LastEditedBy = s.LastEditedBy, t.LastEditedWhen = s.LastEditedWhen
WHEN NOT MATCHED
    THEN
        INSERT (Source_Product_ID,Product_Code,Product_Name,Product_Category,Weight,uuid,LastEditedBy,LastEditedWhen)
        VALUES (s.Product_ID,s.Product_Code,s.Product_Name,s.Product_Category,s.Weight,s.uuid,s.LastEditedBy,s.LastEditedWhen);

-- as
MERGE INTO NDS.Location as t
USING Stage.Location as s
ON t.uuid = s.uuid
WHEN MATCHED
	THEN
		UPDATE SET t.Address = s.Address , t.City = s.City , t.Country_code = s.Country_code , t.Country_name = s.Country_name,
		t.States = s.States , t.LastEditedBy = s.LastEditedBy, t.LastEditedWhen = s.LastEditedWhen
WHEN NOT MATCHED
	THEN
		INSERT (Source_Location_ID,Address,Lat,Long,City,Country_code,Country_name,States,uuid,LastEditedBy,LastEditedWhen)
		VALUES (s.Location_ID,s.Address,s.Lat,s.Long,s.City,s.Country_code,s.Country_name,s.States,s.uuid,s.LastEditedBy,s.LastEditedWhen);
        
-- as
MERGE INTO NDS.Customer as t
USING (SELECT a.Customer_ID,a.name,a.username,a.sex,a.mail,a.birthdate,b.Location_ID,a.Phone,a.uuid,a.LastEditedBy,a.LastEditedWhen
		FROM Stage.Customer a
		JOIN NDS.Location b
		ON a.Location_ID = b.Source_Location_ID) as s
ON t.uuid = s.uuid
WHEN MATCHED
	THEN
		UPDATE SET t.name = s.name, t.username = s.username, t.sex = s.sex, t.mail = s.mail, t.birthdate = s.birthdate, t.Location_ID = s.Location_ID,
        t.Phone = s.Phone, t.uuid = s.uuid, t.LastEditedBy = s.LastEditedBy, t.LastEditedWhen = s.LastEditedWhen
WHEN NOT MATCHED
    THEN
        INSERT (Source_Customer_ID,name,username,sex,mail,birthdate,Location_ID,Phone,uuid,LastEditedBy,LastEditedWhen)
        VALUES (s.Customer_ID,s.name,s.username,s.sex,s.mail,s.birthdate,s.Location_ID,s.Phone,s.uuid,LastEditedBy,LastEditedWhen);


-- as        
MERGE INTO NDS.Supplier as t
USING 
    (SELECT a.Supplier_ID,a.Supplier_Name,b.Location_ID,a.uuid,a.LastEditedBy,a.LastEditedWhen
        FROM Stage.Supplier a
        JOIN NDS.Location b
        ON a.Location_ID = b.Source_Location_ID) as s
ON t.uuid = s.uuid
WHEN MATCHED
    THEN
        UPDATE SET t.Supplier_Name = s.Supplier_Name, t.Location_ID = s.Location_ID,
        t.LastEditedBy = s.LastEditedBy, t.LastEditedWhen = s.LastEditedWhen
WHEN NOT MATCHED
    THEN
        INSERT (Source_Supplier_ID,Supplier_Name,Location_ID,uuid,LastEditedBy,LastEditedWhen)
        VALUES (s.Supplier_ID,s.Supplier_Name,s.Location_ID,s.uuid,s.LastEditedBy,s.LastEditedWhen);
            
-- as
MERGE INTO NDS.Warehouse as t
USING 
    (SELECT a.Warehouse_ID,a.Warehouse_Name,a.Warehouse_cost,b.Location_ID,a.uuid,a.LastEditedBy,a.LastEditedWhen
        FROM Stage.Warehouse a
        JOIN NDS.Location b
        ON a.Location_ID = b.Source_Location_ID) as s
ON t.uuid = s.uuid
WHEN MATCHED
    THEN
        UPDATE SET t.Warehouse_Name = s.Warehouse_Name, t.Warehouse_cost = s.Warehouse_cost, t.Location_ID = s.Location_ID,
        t.LastEditedBy = s.LastEditedBy, t.LastEditedWhen = s.LastEditedWhen
WHEN NOT MATCHED
    THEN
        INSERT (Source_Warehouse_ID,Warehouse_Name,Warehouse_cost,Location_ID,uuid,LastEditedBy,LastEditedWhen)
        VALUES (s.Warehouse_ID,s.Warehouse_Name,s.Warehouse_cost,s.Location_ID,s.uuid,s.LastEditedBy,s.LastEditedWhen);
       
-- as
MERGE INTO NDS.Storage as t
USING 
    (SELECT a.StorageID,b.Product_ID,c.Warehouse_ID,a.Capacity,a.Quantity,a.uuid,a.LastEditedBy,a.LastEditedWhen
        FROM Stage.Storage a
        JOIN NDS.Product b
        ON a.Product_ID = b.Source_Product_ID
        JOIN NDS.Warehouse c
        ON a.Warehouse_ID = c.Source_Warehouse_ID) as s
ON t.uuid = s.uuid
WHEN MATCHED
    THEN
        UPDATE SET t.Warehouse_ID = s.Warehouse_ID, t.Capacity = s.Capacity, t.Quantity = s.Quantity,
        t.LastEditedBy = s.LastEditedBy, t.LastEditedWhen = s.LastEditedWhen
WHEN NOT MATCHED
    THEN
        INSERT (Source_StorageID,Product_ID,Warehouse_ID,Capacity,Quantity,uuid,LastEditedBy,LastEditedWhen)
        VALUES (s.StorageID,s.Product_ID,s.Warehouse_ID,s.Capacity,s.Quantity,s.uuid,s.LastEditedBy,s.LastEditedWhen);

-- as
INSERT INTO NDS.Import(Source_Import_ID,Product_ID,Warehouse_ID,Supplier_ID,
	Quantity,Ship_Distance,Ship_Cost,Import_Date,uuid,LastEditedBy,LastEditedWhen)
SELECT a.Import_ID,b.Product_ID,c.Warehouse_ID,d.Supplier_ID,a.Quantity,a.Ship_Distance,a.Ship_Cost,
	a.Import_Date,a.uuid,a.LastEditedBy,a.LastEditedWhen
  FROM Stage.Import a
  JOIN NDS.Product b
  ON a.Product_ID = b.Source_Product_ID
  JOIN NDS.Warehouse c
  ON a.Warehouse_ID = c.Source_Warehouse_ID
  JOIN NDS.Supplier d
  ON a.Supplier_ID = d.Source_Supplier_ID;
  
-- as
INSERT INTO NDS.Export(Source_Order_ID,Product_ID,Customer_ID,Quantity,Date_Order,Date_Ship,
       Date_due,Ship_Distance,Ship_Cost,uuid,LastEditedBy,LastEditedWhen)
SELECT a.Order_ID,b.Product_ID,c.Customer_ID,a.Quantity,a.Date_Order,a.Date_Ship,
  a.Date_due,a.Ship_Distance,a.Ship_Cost,a.uuid,a.LastEditedBy,a.LastEditedWhen
  FROM Stage.Export a
  JOIN NDS.Product b
  ON a.Product_ID = b.Product_Code
  JOIN NDS.Customer c
  ON a.Customer_ID = c.Source_Customer_ID;

-- DimLocation
MERGE INTO Model.DimLocation t
USING (SELECT l.Location_ID,l.Lat,l.Long,l.Address,l.City,l.States,l.Country_code,l.Country_name
       FROM Stage.Location sl
       JOIN NDS.Location l
       ON sl.Location_ID = l.Source_Location_ID) as s
ON t.Location_ID = s.Location_ID
WHEN MATCHED
    THEN 
        UPDATE SET t.Address = s.Address, t.City = s.City, t.States = s.States,
        t.Country_code = s.Country_code , t.Country_name = s.Country_name
WHEN NOT MATCHED
    THEN
        INSERT (Location_ID,Lat,Long,Address,City,States,Country_code,Country_name)
        VALUES (s.Location_ID,s.Lat,s.Long,s.Address,s.City,s.States,s.Country_code,s.Country_name);

-- DimProduct
MERGE INTO Model.DimProduct as t
USING (SELECT p.Product_ID,p.Product_Code,p.Product_Name,p.Product_Category,p.Weight
       FROM Stage.Product sp
       JOIN NDS.Product p
       ON sp.Product_ID = p.Source_Product_ID) as s
ON t.Product_ID = s.Product_ID
WHEN MATCHED AND Currently = 1
    THEN 
        UPDATE SET t.Currently = 0;
        
INSERT INTO Model.DimProduct (Product_ID,Product_Code,Product_Name,Product_Category,Weight,Currently)
(SELECT p.Product_ID,p.Product_Code,p.Product_Name,p.Product_Category,p.Weight,1 
 FROM Stage.Product sp
 JOIN NDS.Product p
 ON sp.Product_ID = p.Source_Product_ID);

-- DimWarehouse
MERGE INTO Model.DimWarehouse t
USING (SELECT w.Warehouse_ID, w.Warehouse_name, w.Warehouse_cost, l.Lat, l.Long 
       FROM Stage.Warehouse sw
       JOIN NDS.WAREHOUSE w
       ON sw.Warehouse_ID = w.Source_Warehouse_ID
       JOIN NDS.Location l
       ON w.Location_ID = l.Location_ID) s
ON t.Warehouse_ID = s.Warehouse_ID
WHEN MATCHED
    THEN 
        UPDATE SET t.Warehouse_name = s.Warehouse_name, t.Warehouse_cost = s.Warehouse_cost
WHEN NOT MATCHED
    THEN
        INSERT (Warehouse_ID,Warehouse_name,Warehouse_cost,Lat,Long)
        VALUES (s.Warehouse_ID,s.Warehouse_name,s.Warehouse_cost,s.Lat,s.Long);

-- FactImport
INSERT INTO Model.FactImport (ImportDate, DepartureLocationKey, ArrivalLocationKey, WarehouseKey, ProductKey, Quantity, TotalWeight, ShipDistance, ShipCost)
(SELECT i.Import_Date, ls.LocationKey as DepartureLocationKey, lw.LocationKey as ArrivalLocationKey, w.WarehouseKey, p.ProductKey,
        i.Quantity, i.Quantity * p.Weight as TotalWeight, i.Ship_Distance, i.Ship_Cost
FROM Stage.Import si
JOIN NDS.Import i
ON si.Import_ID = i.Source_Import_ID
JOIN Model.DimProduct p
ON i.Product_ID = p.Product_ID
JOIN Model.DimWarehouse w
ON i.Warehouse_ID = w.Warehouse_ID
JOIN NDS.Supplier s
ON i.Supplier_ID = s.Supplier_ID
JOIN Model.DimLocation ls
ON ls.Location_ID = s.Location_ID
JOIN NDS.Warehouse nw
ON i.Warehouse_ID = nw.Warehouse_ID
JOIN Model.DimLocation lw
ON nw.Location_ID = lw.Location_ID);

-- FactExport
INSERT INTO Model.FactExport (ExportDate, DepartureLocationKey, ArrivalLocationKey, WarehouseKey, ProductKey, ShipLate, Quantity, TotalWeight, ShipDistance, ShipCost)
(SELECT e.Date_ship, lw.LocationKey as DepartureLocationKey, lc.LocationKey as ArrivalLocationKey, w.WarehouseKey, p.ProductKey,
        GREATEST(0,DATEDIFF(day,e.Date_Due, e.Date_ship)) as ShipLate, e.Quantity, e.Quantity * p.Weight as TotalWeight, e.Ship_Distance, e.Ship_Cost
FROM Stage.Export se
JOIN NDS.Export e
ON se.Order_ID = e.Source_Order_ID 
JOIN Model.DimProduct p
ON e.Product_ID = p.Product_ID
JOIN NDS.Storage st
ON e.Product_ID = st.Product_ID
JOIN Model.DimWarehouse w
ON st.Warehouse_ID = w.Warehouse_ID
JOIN NDS.Customer c
ON e.Customer_ID = c.Customer_ID
JOIN Model.DimLocation lc
ON c.Location_ID = lc.Location_ID
JOIN NDS.Warehouse nw
ON st.Warehouse_ID = nw.Warehouse_ID
JOIN Model.DimLocation lw
ON nw.Location_ID = lw.Location_ID);

-- as
TRUNCATE TABLE Stage.Customer;
TRUNCATE TABLE Stage.Product;
TRUNCATE TABLE Stage.Location;
TRUNCATE TABLE Stage.Import;
TRUNCATE TABLE Stage.Export;
TRUNCATE TABLE Stage.Supplier;
TRUNCATE TABLE Stage.Warehouse;
TRUNCATE TABLE Stage.Storage;
  