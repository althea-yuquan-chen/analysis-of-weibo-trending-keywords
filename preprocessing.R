library(readr)
library(dplyr)
library(stringr)
library(do)
library(ggplot2)
library(stats)

hotlist <- read_csv("your path to hotlist")
hotlist <- subset(hotlist, select = -c(最高排名, 主持人)) # 删除用不上的列
hotlist <- hotlist[-63438, ] # 删除一个热度极端值
hotlist <- na.omit(hotlist) # 删除缺失值
hotlist$热度 <- as.numeric(hotlist$热度) # 数据类型转换
hotlist$日期 <- as.Date(hotlist$日期)
hotlist$上榜时间 <- as.numeric(hotlist$上榜时间)

## 分类合并
sort_data = str_split_fixed(hotlist$分类, "-",2)%>%data.frame()
sort_data = cbind(sort_data, hotlist)
sort_data <- subset(sort_data, select = -c(X2, 分类))
sort <- as.data.frame(table(sort_data$X1)) # 查看分类
sort_data$X1 <- Replace(sort_data$X1, from=c("电视剧", "综艺", "电影", "动漫","影视"),to = "影视")
sort_data$X1 <- Replace(sort_data$X1, from=c("明星", "搞笑", "搞笑幽默", "秀场", "CP"),to = "娱乐")
sort_data$X1 <- Replace(sort_data$X1, from=c("时事", "法律", "航空", "财经"),to = "新闻")
sort_data$X1 <- Replace(sort_data$X1, from=c("音乐", "游戏", "闲趣"),to = "游戏")
sort_data$X1 <- Replace(sort_data$X1, from=c("文学读书", "读书", "校园","教育"),to = "教育")
sort_data$X1 <- Replace(sort_data$X1, from=c("互联网", "数码", "IT技术","科技"),to = "科技")
sort_data$X1 <- Replace(sort_data$X1, from=c("美食", "美妆", "时尚", "旅游", "萌宠", "生活记录", "婚庆", "育儿"),to = "生活")
sort_data$X1 <- Replace(sort_data$X1, from=c("军事", "政务"),to = "政治")
sort_data$X1 <- Replace(sort_data$X1, from=c("汽车", "星座", "地区", "创意征集", "收藏", "美图", "设计","其他"),to = "其他")
sort_data$X1 <- Replace(sort_data$X1, from=c("科普","公益"),to = "公益")
sort_data$X1 <- Replace(sort_data$X1, from=c("运动健身","健康"),to = "健康")
sort_data$X1 <- Replace(sort_data$X1, from=c("历史", "艺术", "摄影", "宗教", "国学"),to = "文化")
sort_data$X1 <- Replace(sort_data$X1, from=c("电商", "直播", "职场", "行业", "房产", "家居"),to = "商业")
sort_data$X1 <- Replace(sort_data$X1, from=c("娱乐幽默"),to = "娱乐")


sort_data <- sort_data %>% rename(分类=X1)

write.csv(sort_data, "sort_data.csv")



## 字数列
wordcount = nchar(sort_data$名称)
sort_data <- cbind(sort_data, wordcount)
sort_data <- na.omit(sort_data)

## 字数与热度的相关性：字数无关，字数等级显著相关
cor1 <- cor(sort_data$wordcount, sort_data$热度, method = "pearson")
## 0.009无关

# 创建列"字数等级"
sort_data$levelnchar <- NA
sort_data$levelnchar[sort_data$wordcount >= 1 & sort_data$wordcount <= 4] <- 1
sort_data$levelnchar[sort_data$wordcount >= 5 & sort_data$wordcount <= 8] <- 2
sort_data$levelnchar[sort_data$wordcount >= 9 & sort_data$wordcount <= 12] <- 3
sort_data$levelnchar[sort_data$wordcount >= 13 & sort_data$wordcount <= 16] <- 4
sort_data$levelnchar[sort_data$wordcount >16] <- 5
aovncharhotness <- aov(热度 ~ levelnchar, data = sort_data)
summary(aovncharhotness)


## 上榜时间与热度的相关性
cor2 <- cor(sort_data$上榜时间, sort_data$热度, method = "spearman")
## 0.495 相关

## 分类与热度的相关性：显著相关
sort_data$分类 <- as.factor(sort_data$分类)
ggplot(sort_data, aes(x = 分类, y = 热度, colour = 分类)) +
  geom_boxplot() +
  labs(title = "Relationship between categories and Hotness", x="分类", y="热度")

aovsorthotness <- aov(热度~分类, data = sort_data)
summary(aovsorthotness)
summary(sort_data$热度)



work_data <- subset(sort_data, select = -c(wordcount))
work_data <- cbind(work_data, emotion_data$sentimentlevel)
names(work_data)[names(work_data) == 'emotion_data$sentimentlevel'] <- 'sentimentlevel'
write.csv(work_data, "work_data.csv")