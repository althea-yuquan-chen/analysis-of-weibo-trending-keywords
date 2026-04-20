library(readr)
library(ggplot2)
library(stats)

emotion_data <- read_csv("emotion_data.csv")
emotion_data <- emotion_data[,-1]
emotion_data$sentiment <- emotion_data$sentiment - 0.5

emotion_data <- na.omit(emotion_data)
cor3 <- cor(emotion_data$sentiment, emotion_data$热度, method = "spearman")
# -0.03 无关

emotion_data$sentimentlevel <- NA
emotion_data$sentimentlevel[abs(emotion_data$sentiment) <= 0.15] <- "weak"
emotion_data$sentimentlevel[abs(emotion_data$sentiment) >= 0.35] <- "strong"
emotion_data$sentimentlevel[abs(emotion_data$sentiment) > 0.15 & abs(emotion_data$sentiment) < 0.35] <- "medium"
aovsentimenthotness <- aov(热度 ~ sentimentlevel, data = emotion_data)
summary(aovsentimenthotness)

ggplot(emotion_data, aes(x = sentiment)) +
  geom_histogram(fill='grey', colour = "steelblue", binwidth = 0.002) +
  labs(title = "Distribution of Sentiment Value")

emotion_data$sentimentlevel <- as.factor(emotion_data$sentimentlevel)
ggplot(emotion_data, aes(x=sentimentlevel,fill=sentimentlevel)) +
  geom_bar() +
  labs(title = "Sentiment Levels", x="sentiment level")