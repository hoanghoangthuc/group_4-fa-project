	/****** Object: CREATE DATABASE    Script Date: 8/11/2021 5:55:21 PM ******/
	/****** Object: CREATE tABLE    Script Date: 8/11/2021 5:55:21 PM ******/
	/****** Object: CREATE PRIMARY KEY [Stagging].[Customer]    Script Date: 8/11/2021 5:55:21 PM ******/
	/****** Object: CREATE FOREIGN KEY    Script Date: 8/11/2021 5:55:21 PM ******/
	IF DB_ID('MiniProject1') IS NOT NULL
	DROP DATABASE MiniProject1;
	Go
	CREATE DATABASE [MiniProject1];
	go
	USE [MiniProject1]
	GO
	CREATE SCHEMA Stagging
	go

	/****** Object:  Create Table [Stagging].[datedimension]    Script Date: 8/11/2021 5:55:21 PM ******/
	/****** Object:  If you need more time chane (Date and DateADD)    Script Date: 8/11/2021 5:55:21 PM ******/

	Create table [Stagging].[DateDimension] (
		TheDate Date not null primary key,
		TheDay  int not null,
		TheDayName  varchar(20) not null,
		TheWeek  int not null ,
		TheISOWeek int not null,
		TheDayOfWeek  int not null,
		TheMonth        int not null,
		TheMonthName    varchar(20) not null,
		TheQuarter      int not null,
		TheYear         int not null,
		TheFirstOfMonth date not null,
		TheLastOfYear   date not null,
		TheDayOfYear   int not null)

	DECLARE @StartDate  date = '20170101'; --change start year from here--

	DECLARE @CutoffDate date = DATEADD(DAY, -1, DATEADD(YEAR, 1, @StartDate)); --change number year have use from start in DateADD (a, year should change,start year)

	;WITH seq(n) AS 
	(
	  SELECT 0 UNION ALL SELECT n + 1 FROM seq
	  WHERE n < DATEDIFF(DAY, @StartDate, @CutoffDate)
	),
	d(d) AS 
	(
	  SELECT DATEADD(DAY, n, @StartDate) FROM seq
	),
	src AS
	(
	  SELECT
		TheDate         = CONVERT(date, d),
		TheDay          = DATEPART(DAY,       d),
		TheDayName      = DATENAME(WEEKDAY,   d),
		TheWeek         = DATEPART(WEEK,      d),
		TheISOWeek      = DATEPART(ISO_WEEK,  d),
		TheDayOfWeek    = DATEPART(WEEKDAY,   d),
		TheMonth        = DATEPART(MONTH,     d),
		TheMonthName    = DATENAME(MONTH,     d),
		TheQuarter      = DATEPART(Quarter,   d),
		TheYear         = DATEPART(YEAR,      d),
		TheFirstOfMonth = DATEFROMPARTS(YEAR(d), MONTH(d), 1),
		TheLastOfYear   = DATEFROMPARTS(YEAR(d), 12, 31),
		TheDayOfYear    = DATEPART(DAYOFYEAR, d)
	  FROM d
	)
	Insert Into  [Stagging].[DateDimension]
	SELECT *
	From src
	 ORDER BY TheDate
	 OPTION (MAXRECURSION 0);

	/****** Object: create Table [Stagging].[Customer]    Script Date: 8/11/2021 5:55:21 PM ******/

	CREATE TABLE [Stagging].[Customer](
		[Customer_ID] int NOT NULL primary key,
		[name] [varchar](20) NOT NULL,
		[username] [varchar](50) NOT NULL,
		[sex] [varchar](1) NOT NULL,
		[mail] [varchar](100) NOT NULL,
		[birthdate] Datetime NULL,
		[Location_ID] int NOT NULL,
		[Phone] [varchar](15) not NUll
	) ON [PRIMARY]
	GO

	/****** Object: create Table [Stagging].[LoCation]    Script Date: 8/11/2021 5:55:21 PM ******/

	CREATE TABLE [Stagging].[Location](
		[Location_ID] Int NOT NULL primary key,
		[Address] [varchar](100) NOT NULL,
		[Lat] float NOT NULL,
		[Long] float NOT NULL,
		[Post_Code] int NOT NULL,
		[City] [varchar](20) NOT NULL,
		[Country_code] [varchar](2) NOT NULL,
		[Country_name] [varchar](20) NOT NULL,
		[States] [varchar](30) NOT NULL
	) ON [PRIMARY]
	GO

	/****** Object:  Create Table [Stagging].[Product]    Script Date: 8/11/2021 5:55:21 PM ******/

	CREATE TABLE [Stagging].[Product](
		[Warehouse_ID] int NOT NULL,
		[Product_ID] int not NULL primary key,
		[Product_Name] [varchar](50) NOT NULL,
		[Product_SubCategory] [varchar](50) NULL,
		[Product_Color] [varchar](20) NOt NULL,
		[Standard_Cost] float NOT NULL,
		[General_Price] float NOT NULL,
		[Product_Number] int NOT NULL,
		[Sale_DateStart] Datetime NULL,
		[Sale_DateEnd] Datetime NULL,
		[Import_Flag] BIT NULL
	) ON [PRIMARY]
	GO

	/****** Object:  Create Table [Stagging].[record]    Script Date: 8/11/2021 5:55:21 PM ******/

	CREATE TABLE [Stagging].[Record](
		[Order_ID] int NOT NULL ,
		[Product_ID] int not NULL,
		[Customer_ID] int not NULL,
		[Product_Values] float not NULL,
		[General_Price] float not NULL,
		[Tax] float not NULL,
		[Total_Cost] float not NULL,
		[Date_Order] date not NULL,
		[Date_Ship] date not NULL,
		[Date_due] date not NULL,
		[Ship_Distance] float not NULL,
		[Ship_Cost] float not NULL
		CONSTRAINT PK_RECORD PRIMARY KEY ([PRODUCT_ID],[Customer_ID],[Date_Order])
	) ON [PRIMARY]
	GO

	/****** Object:  Create Table [Stagging].[Warehouse]    Script Date: 8/11/2021 5:55:21 PM ******/

	CREATE TABLE [Stagging].[Warehouse](
		[Warehouse_ID] int not NULL primary key,
		[Warehouse_Name] [varchar](100) not NULL,
		[Warehouse_cost] float not NULL,
		[Location_ID] int not NULL
	) ON [PRIMARY]
	GO

	/****** Object:  Foregin Key    Script Date: 8/11/2021 5:55:21 PM ******/

	ALTER TABLE [Stagging].[Customer]
	ADD CONSTRAINT FK_Customer
	FOREIGN KEY (Location_ID) REFERENCES [Stagging].[Location](Location_ID);

	ALTER TABLE [Stagging].[Warehouse]
	ADD CONSTRAINT FK_warehouse
	FOREIGN KEY (Location_ID) REFERENCES [Stagging].[Location](Location_ID);

	ALTER TABLE [Stagging].[Product]
	ADD CONSTRAINT FK_Product
	FOREIGN KEY (Warehouse_ID) REFERENCES [Stagging].[Warehouse](Warehouse_ID);

	ALTER TABLE [Stagging].[Record]
	ADD CONSTRAINT FK_record_product
	FOREIGN KEY (Product_ID) REFERENCES [Stagging].[Product](Product_ID);

	ALTER TABLE [Stagging].[Record]
	ADD CONSTRAINT FK_record_Customer
	FOREIGN KEY (Customer_ID) REFERENCES [Stagging].[Customer](Customer_ID);

	ALTER TABLE [Stagging].[Record]
	ADD CONSTRAINT FK_record_Date_Order
	FOREIGN KEY (Date_Order) REFERENCES [Stagging].[DateDimension](TheDate);

	ALTER TABLE [Stagging].[Record]
	ADD CONSTRAINT FK_record_Date_due
	FOREIGN KEY (Date_due) REFERENCES [Stagging].[DateDimension](TheDate);

	ALTER TABLE [Stagging].[Record]
	ADD CONSTRAINT FK_record_Date_Ship
	FOREIGN KEY (Date_Ship) REFERENCES [Stagging].[DateDimension](TheDate);
	GO

	/* Trigger*/
	/* Trigger*/
	/* Trigger*/


	/* Trigger Dathang */
	CREATE TRIGGER Dathang ON Stagging.Record AFTER INSERT AS 
	BEGIN
		UPDATE Stagging.Product
		SET Product_Number = Product_Number - (
			SELECT count(Order_ID)
			FROM inserted
			WHERE Product_ID = Stagging.Product.Product_ID
			Group by Product_ID
		)
		FROM Stagging.Product
		JOIN inserted ON Stagging.Product.Product_ID = inserted.Product_ID
	END
	GO
	/* Trigger capnhat */
	CREATE TRIGGER capnhat on Stagging.Record after update AS
	BEGIN
	   UPDATE Stagging.Product 
	   SET Product_Number = Product_Number -
		   (SELECT count(Order_ID) FROM inserted WHERE Product_ID = Stagging.Product.Product_ID Group by Product_ID) +
		   (SELECT count(Order_ID) FROM deleted WHERE Product_ID = Stagging.Product.Product_ID Group by Product_ID)
	   FROM Stagging.Product 
	   JOIN deleted ON Stagging.Product.Product_ID = deleted.Product_ID
	end
	GO
	/* Trigger huyhang */
	create TRIGGER huydathang ON Stagging.Record FOR DELETE AS 
	BEGIN
		UPDATE Stagging.Product
		SET Product_Number = Product_Number + 
		(SELECT count(Order_ID) FROM deleted WHERE Product_ID = Stagging.Product.Product_ID Group by Product_ID)
		FROM Stagging.Product 
		JOIN deleted ON Stagging.Product.Product_ID = deleted.Product_ID
	END
