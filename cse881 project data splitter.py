import pandas as pd
import numpy as np
import os
path="/Users/wudical/Desktop"
os.chdir(path)
data=pd.read_csv('train.csv')


df_by_date = data[:10].groupby("hour")
for (date, date_df) in df_by_date:
    filename = ("time%s" % ) + ".csv"
    date_df.to_csv(filename)


data_by_hour = data.groupby("hour")
for (hour, hour_data) in data_by_hour:
    filename = ("time%s" % hour) + ".csv"
    hour_data.to_csv(filename)


