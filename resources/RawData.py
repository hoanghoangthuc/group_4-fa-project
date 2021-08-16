from RDcode import CreateDataRaw
from RDcode import Rawurl
import os
from distutils.dir_util import copy_tree



if __name__ == '__main__':
    link_raw, link_working=Rawurl()

    print('Start Make Raw Data.....')
    
    df_l,df_w,df_C,df_P,df_R=CreateDataRaw() # make generate data
    print('Loading Data Raw to folder Raw.....')

    df_l.to_csv(link_raw+'\Raw_Location.csv',index=False)
    df_w.to_csv(link_raw+'\Raw_WareHouse.csv',index=False)
    df_C.to_csv(link_raw+'\Raw_Customer.csv',index=False)
    df_P.to_csv(link_raw+'\Raw_Product.csv',index=False)
    df_R.to_csv(link_raw+'\Raw_Record.csv',index=False)
    
    print('Loading Data Raw to folder Working........')

    df_l.to_csv(link_working+'\Working_Location.csv',index=False)
    df_w.to_csv(link_working+'\Working_WareHouse.csv',index=False)
    df_C.to_csv(link_working+'\Working_Customer.csv',index=False)
    df_P.to_csv(link_working+'\Working_Product.csv',index=False)
    df_R.to_csv(link_working+'\Working_Record.csv',index=False)
    print('Done')
