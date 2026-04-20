import requests
import datetime
import json
import pandas as pd


# 构造日期范围
begin = datetime.date(2021,1,1)
end = datetime.date(2023,7,31)
d = begin
delta = datetime.timedelta(days=1)
datelist=[]
while d <= end:
    datelist.append(d.strftime("%Y-%m-%d"))
    d += delta

for i in datelist:
    url = "https://google-api.zhaoyizhe.com/google-api/index/mon/sec?date={}".format(i)
    headers = {'User-agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36',
            "Connection":"close"}
    r = requests.get(url, headers=headers)
    result = r.content.decode('utf-8')
    con_dict = json.loads(result)
    HSL_dict = con_dict['data']
    if not HSL_dict:
            print(i)
    if HSL_dict:
        HSL_df = pd.DataFrame(HSL_dict)
        HSL_df = HSL_df.drop(['_id','date','strDate','dates','icon','clickNum','location','num','screenId'], axis=1)
        HSL_df.columns=['名称','热度','上榜时间','最高排名','分类','主持人']
        HSL_df.insert(loc=1, column='日期', value=i)
        HSL_df.to_csv("C:\\Users\\17293\\Desktop\\hotlist.csv", mode='a', index=False)


