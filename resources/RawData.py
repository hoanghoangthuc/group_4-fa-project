from RDcode import CreateDataRaw
from RDcode import Rawurl
import os
from distutils.dir_util import copy_tree



if __name__ == '__main__':

    link_raw, link_working=Rawurl()

    print('Start Make Raw Data.....')
    
    df_l,df_s,df_W,df_c,df_P,df_sto,df_imp, df_R=CreateDataRaw() # make generate data
    print('Loading Data Raw to folder Raw.....')

    df_l.to_csv(link_raw+'\Raw_Location.csv',index=False)
    df_W.to_csv(link_raw+'\Raw_WareHouse.csv',index=False)
    df_c.to_csv(link_raw+'\Raw_Customer.csv',index=False)
    df_P.to_csv(link_raw+'\Raw_Product.csv',index=False)
    df_R.to_csv(link_raw+'\Raw_Record.csv',index=False)
    df_s.to_csv(link_raw+'\Raw_Supplier.csv',index=False)
    df_sto.to_csv(link_raw+'\Raw_Storage.csv',index=False)
    df_imp.to_csv(link_raw+'\Raw_Import.csv',index=False)
    
    print('Loading Data Raw to folder Working........')
    df_l.to_csv(link_working+'\Working_Location.csv',index=False)
    df_W.to_csv(link_working+'\Working_WareHouse.csv',index=False)
    df_c.to_csv(link_working+'\Working_Customer.csv',index=False)
    df_P.to_csv(link_working+'\Working_Product.csv',index=False)
    df_R.to_csv(link_working+'\Working_Record.csv',index=False)
    df_s.to_csv(link_working+'\Working_Supplier.csv',index=False)
    df_sto.to_csv(link_working+'\Working_Storage.csv',index=False)
    df_imp.to_csv(link_working+'\Working_Import.csv',index=False)
    print('Done')
