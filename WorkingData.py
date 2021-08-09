from WDcode import Work_Record
from WDcode import Work_Customer
from WDcode import Work_Location
from WDcode import Work_Product
from WDcode import Work_Warehouse


if __name__ == '__main__':
    print('Start Make Working Data.....')
    Work_Record() 
    Work_Warehouse() 
    Work_Location()
    Work_Customer()
    Work_Product()
    print('Done')