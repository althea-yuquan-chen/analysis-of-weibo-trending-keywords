library(ggplot2)
library(ggthemes)
frequency_data <- as.data.frame(table(sort_data$分类))
colnames(frequency_data) <- c("分类", "频次")

ggplot(frequency_data, aes(x = reorder(分类, -频次), y = 频次, fill = 分类)) +
  geom_histogram(stat="identity") +
  labs(title = "Frequency of categories", x = "分类", y="频次")


# 使用ggplot2创建核密度图
ggplot(data = sort_data, aes(x = 热度)) +
  geom_density(fill = "steelblue", color = "black") +
  labs(title = "Kernel Density Plot of Hotness", x = "Value", y = "Density")
summary(sort_data$热度)



sorts <- as.data.frame(table(hotlist$分类))
sort <- as.data.frame(table(sort_data$分类))

work_data <- sort_data


work_data$日期 <- as.Date(work_data$日期)
ggplot(work_data, aes(x = 日期)) +
  geom_line(stat = "count", lty = 1, aes(colour = 分类)) +
  scale_x_date(date_breaks = "3 month") +#设置x轴的间距
  labs(title='逐月分类-频次图', x="日期", y="频次") +#添加标题
  theme(plot.title = element_text(hjust=0.5)) +
  scale_color_tableau()

ggplot(sort_data, aes(x=日期, y=热度)) +
  geom_line(aes(colour = 分类)) +
  scale_x_date(date_breaks = "3 month")


