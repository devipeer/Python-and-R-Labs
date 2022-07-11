# Piotr Pawe³ko 
# PIRaP lab 1 R
# 15.03.2022


rm(list = ls())

library(ISLR)
library(ggcorrplot)
library(ggplot2)
library(dplyr)
data(Credit)
attach(Credit)

head(Credit)
summary(Credit)

# Task 1

CreditCheck <- function(v) {
  for (i in seq_along(v)) {
    if (Credit$ID[i] != v[i]) {
      return("different")
    }
  }
  return("identical")
}
raws <- apply(Credit, 2, CreditCheck)
Credit$ID = as.character(Credit$ID)
charCredit <- apply(Credit, 2, CreditCheck)
Credit <- Credit[charCredit == "different"]


# Task 2 

quant_vars <- data.frame(Credit$Income, Credit$Limit, Credit$Rating, Credit$Cards, Credit$Age, Credit$Education, Credit$Balance)


pearsonCor <- cor(quant_vars, method=c("pearson"))

CorrelationPlot <- ggcorrplot(pearsonCor, type="lower", lab=TRUE, lab_size=3, colors= c("green","yellow","red"))
plot(CorrelationPlot)


BalanceLimitPlot <- ggplot(Credit,aes(Balance,Limit)) + geom_smooth(method = "lm", col = "orange", se = FALSE,) + 
  geom_point(aes(col = Income)) + labs(title = "Task 2", subtitle = "Balance and Limit correlation", caption = "Credit data")

plot(BalanceLimitPlot)

BalanceRatingPlot <- ggplot(Credit,aes(Balance,Rating)) + geom_smooth(method = "lm", col = "orange", se = FALSE,) + 
  geom_point(aes(col = Income)) + labs(title = "Task 2", subtitle = "Balance and Rating correlation", caption = "Credit data")

plot(BalanceRatingPlot)


# Task 3
MeanIncome <- aggregate(Credit$Income, by=list(Credit$Ethnicity), FUN=mean)
SdIncome <- aggregate(Credit$Income, by=list(Credit$Ethnicity), FUN=sd)

Task3Plot <- ggplot(Credit, aes(Income)) + geom_density(aes(fill = factor(Ethnicity)), alpha = 0.7)
plot(Task3Plot)


# Task 4
library(dplyr)
sortedData <- arrange(Credit,Balance,desc(Income))


# Task 5
Credit$Task5 <- factor(ifelse(Credit$Age > 60, "Old", "Young")) 
MeanQuantVars <- aggregate(quant_vars, by=list(Credit$Task5), FUN=mean)

# Task 6
Task6Plot <- ggplot(Credit,aes(x = Student, y = Balance, fill = Gender)) + geom_boxplot() +
  scale_fill_brewer(palette = "Accent") +
  labs(title = ("Credit card balance for students vs non-students")) + theme_bw()
plot(Task6Plot)

