import pandas as pd
from snownlp import SnowNLP

# 读取CSV文件
csv_file = r"E:\课题\2023暑期科研\data-algo\sort_data.csv"
data = pd.read_csv(csv_file)

# 获取文本列名，假设列名为"text"
text_column = "名称"

# 创建情感标注函数
def sentiment_analysis(text):
    s = SnowNLP(text)
    sentiment_score = s.sentiments
    return sentiment_score

# 对文本列进行情感标注
data["sentiment"] = data[text_column].apply(sentiment_analysis)

# 保存结果到新的CSV文件
output_csv_file = r"E:\课题\2023暑期科研\data-algo\emotion_data.csv"
data.to_csv(output_csv_file, index=False)

