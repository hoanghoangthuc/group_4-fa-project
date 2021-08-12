import os
import random
from datetime import datetime
from faker import Faker 
import pandas as pd
import numpy as np
fake = Faker()
Faker.seed(0)  
from datetime import timedelta 

def  Rawurl():
    os.chdir('..')
    os.makedirs('Data', exist_ok=True)   
    Datalink=os.getcwd()+'\Data'
    os.chdir(Datalink)
    Datalinks=os.getcwd()
    os.makedirs('Raw', exist_ok=True)   
    os.makedirs('Working', exist_ok=True)
    return Datalinks+'\Raw'



#create warehouse
def create_Warehouse(RECORD_COUNT,Lc):
    time_stampe = datetime.now().strftime("%Y_%m_%d-%I_%M_%S_%p")
    Warehouse_ID=[]
    Warehouse_Name =[]
    Warehouse_cost = []
    address=[]
    location_id=[]
    States=[]
    Lat=[]
    Long=[]
    datalocation=Lc
    indexlocationk=generatePassword(RECORD_COUNT,len(datalocation))
    for i in range(RECORD_COUNT):
        Warehouse_ID.append(fake.random_int(0,6)),
        indexlocation=indexlocationk[i]
        Warehouse_cost.append(fake.random_int(1000,3000))
        indexlocationk.append(indexlocation)
        address.append(datalocation['Address'][indexlocation])
        location_id.append(datalocation['Location_ID'][indexlocation])
        States.append(datalocation['States'][indexlocation])
        Lat.append(datalocation['Lat'][indexlocation])
        Long.append(datalocation['Long'][indexlocation])
        Warehouse_Name.append(str(str(States[i])+'_WH'+str(indexlocation)))
        
    dict = {
        'Warehouse_ID': Warehouse_ID,
        'Warehouse_Name': Warehouse_Name,
        'Warehouse_cost': Warehouse_cost,
        'Location_ID':location_id,
        'Address':address,
        'States':States,
        'Lat':Lat,
        'Long': Long
    }

    df = pd.DataFrame(dict)    #lưu ý dấu ngoặc đơn
    return df




#create_record
def create_record(Index_count,startdate,enddate,Pr,Cu,Wh):
    fake = Faker()
    Faker.seed(0) 
    df=pd.DataFrame(columns=['Order_ID','Product_ID','Customer_ID','Product_Values','Unit_Cost',
    'General_Price','Tax','Profit','Total_Cost','Date_Order','Date_Ship','Date_due', 'Ship_Distance', 'Ship_Cost'])
    Ra_Pro=Pr
    Ra_Cus=Cu
    Ra_Wah=Wh
    for i in range(Index_count):
        Order_ID=fake.random_int(0,56892)
        Pro_in=random.randint(1, len(Ra_Pro)-1)
        Cus_in=random.randint(0, len(Ra_Cus)-1)
        Wah_in=random.randint(0, len(Ra_Wah)-1)
        Product_ID=Ra_Pro['Product_ID'][Pro_in]
        Customer_ID=Ra_Cus['Customer_ID'][Cus_in]
        # diền ship vào đay ship là tiền ship (lat,long của cus,,,, lat long của warehosue)
        Ship_Distance = distance(Ra_Cus['Lat'][Cus_in],Ra_Cus['Long'][Cus_in],Ra_Wah['Lat'][Wah_in],Ra_Wah['Long'][Wah_in])
        Ship_Cost = shipping_cost(Ship_Distance)
        Product_Values = float(Ra_Pro['Standard_Cost'][Pro_in]) + float(Ra_Pro['General_Price'][Pro_in])
        Unit_Cost = Ra_Pro['Standard_Cost'][Pro_in]
        General_Price = Ra_Pro['General_Price'][Pro_in]
        Tax = Product_Values/10
        Profit = random.randint(5,30)
        Total_Cost = Product_Values*(100+Profit)/100 + Tax + Ship_Cost
        Date_Order = fake.date_between(start_date = startdate, end_date = enddate)
        Date_Ship = fake.date_between(start_date = Date_Order, end_date = Date_Order + timedelta(days=10))   
        Date_due=fake.date_between(start_date = Date_Order, end_date = Date_Order + timedelta(days=10))
        
        to_append = [Order_ID,Product_ID, Customer_ID,Product_Values,Unit_Cost,General_Price,Tax
                    ,Profit,Total_Cost,Date_Order,Date_Ship,Date_due, Ship_Distance, Ship_Cost]
        a_series = pd.Series(to_append, index = df.columns)
        df = df.append(a_series, ignore_index=True)
    return df

#productcall
def product_create():
    Productnamehave=['Bike','Phone','Clother','Watch',
                'Laptop','Jewelry','Sticker','Mattress',"Lamp"]
    Color=fake.color_name()
    SubCategory=np.random.choice(Productnamehave) 
    Name= SubCategory + Color + str(fake.random_int(0,56892))
    return Name, SubCategory, Color
# call this to create_Product():
def create_product(RECORD_COUNT,startdate,enddate,Wh):
    df=pd.DataFrame(columns=['NoID','Product_ID','Product_Name', 'Product_SubCategory',
                   'Product_Color','Standard_Cost','General_Price','Product_Number',
                    'Sale_DateStart','Sale_DateEnd','Import_Flag','Warehouse_ID'])
    dataWH=Wh
    for i in range(RECORD_COUNT):
        No_ID=i+1 #no_ID 
        WarehouseID=np.random.choice(dataWH['Warehouse_ID']) #warehouse_ID
        Product_ID=fake.random_int(0,56892) # Product_ID
        Product_name, Product_SubCategory, Pro_Color=product_create() #take product name,SubCategory, Color
        Price =(fake.random_int(0,50000)) #standcost
        GeneralPrice=fake.random_int(0,500) # price cost fee
        Product_Number=fake.random_int(0,10000) # product_ID
        SaleDateStart=fake.date_between(start_date=startdate, end_date=enddate) #date time start sale
        SaleDateEnd=fake.date_between(start_date=startdate, end_date=enddate)   #date time end sale
        if SaleDateEnd<SaleDateStart:
            SaleDateEnd=None 
        ImportFlag=fake.random_int(0,1) #Import Product
        #values to list to pandas
        to_append = [No_ID,Product_ID, Product_name,Product_SubCategory,Pro_Color,Price,GeneralPrice
                     ,Product_Number,SaleDateStart,SaleDateEnd,ImportFlag,WarehouseID]
        a_series = pd.Series(to_append, index = df.columns)
        df = df.append(a_series, ignore_index=True)
    return df 

#create location
def create_location(Index_count):
    fake = Faker()
    Faker.seed(0) 
    df=pd.DataFrame(columns=['Location_ID','Address','Lat','Long','Post_Code','City','Country_code','Country_name','States'])
    for i in range(Index_count):
        Product_ID=fake.random_int(0,56892)
        Address=fake.street_address()
        m=fake.local_latlng(country_code='US', coords_only=False)
        lat=m[0]
        long=m[1]
        city=m[2]
        postcode=fake.postcode()
        Country_code=m[3]
        Country_name='America'
        States=m[4][8:]
        to_append=[Product_ID, Address, lat, long,postcode,city, Country_code,Country_name,States]
        a_series = pd.Series(to_append, index = df.columns)
        df = df.append(a_series, ignore_index=True)
    return df




#create Customer
def create_Customer(RECORD_COUNT,Lc):
    time_stampe = datetime.now().strftime("%Y_%m_%d-%I_%M_%S_%p")
    data_value = []
    data=Lc
    #print(data)
    columns = fake.profile().keys()
    columns=list(columns)
    columns.append('Location_ID')
    columns.append('Address')
    columns.append('States')
    columns.append('Lat')
    columns.append('Long')
    columns.append('Customer_ID')
    for i in range(RECORD_COUNT):
        indexlocation=np.random.choice(len(data))
        location_id=data['Location_ID'][indexlocation]
        address=data['Address'][indexlocation]
        States=data['States'][indexlocation]
        Lat=data['Lat'][indexlocation]
        Long=data['Long'][indexlocation]
        Customer_ID=fake.random_int(10000,99999)
        a=fake.profile().values()
        listcus=list(a)
        listcus.append(location_id)
        listcus.append(address)
        listcus.append(States)
        listcus.append(Lat)
        listcus.append(Long)
        listcus.append(Customer_ID)
        data_value.append(listcus)
    df = pd.DataFrame(data_value, columns = columns)
    return df


#create list no dulicate
def generatePassword(i,k) :
    lis = []
    while len(lis)<i:
        #This checks to see if there are duplicate numbers
        r = random.randint(0,k-1)
        if r not in lis :
            lis.append(r)
    return lis

#create count ship code
def shipping_cost(distance):
    if float(distance) < 300:
        cost = 0
    elif float(distance) >= 300:
        cost = (distance - 300)*0.02
    return round(cost,3)

#create distance
def distance(lat1, lon1, lat2, lon2):
    lat1=round(float(lat1),3)
    lon1=round(float(lon1),3)
    lat2=round(float(lat2),3)
    lon2=round(float(lon2),3)
    from math import cos, asin, sqrt, pi
    p = pi/180
    a = 0.5 - cos((lat2-lat1)*p)/2 + cos(lat1*p) * cos(lat2*p) * (1-cos((lon2-lon1)*p))/2
    return round(12742 * asin(sqrt(a)),3) #2*R*asin...
   