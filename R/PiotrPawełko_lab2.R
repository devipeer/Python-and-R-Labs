library(ISLR)
library(ggplot2)
library(e1071)

# Task 1
heart <- read.csv("C:/Users/piotr/OneDrive/Pulpit/PiRaP_lab2/Heart.csv", header = TRUE, sep = ",")

t.test(heart$Chol ~ heart$Fbs)
t.test(heart$MaxHR ~ heart$AHD)
t.test(heart$RestBP ~ heart$Sex)

# Task 2

sample_size <- 2/3 * nrow(heart)
train_indeces <- sample(seq_len(nrow(heart)), size = sample_size)
train <- heart[train_indeces, ]
test <- heart[-train_indeces, ]

model_age <- lm(MaxHR ~ Age, data = train)
model_restBP<- lm(MaxHR ~ RestBP, data = train)
model_chol <- lm(MaxHR ~ Chol, data = train)

rsg_age = summary(model_age)$r.squared
rsg_restBP <- summary(model_restBP)$r.squared
rsg_chol<- summary(model_chol)$r.squared

testerr_age <- mean((test$Age * model_age$coef[-1] + model_age$coef[1] - test$MaxHR) ^ 2)
testerr_restBP <- mean((test$RestBP * model_restBP$coef[-1] + model_restBP$coef[1] - test$MaxHR) ^ 2)
testerr_chol <- mean((test$Chol * model_chol$coef[-1] + model_chol$coef[1] - test$MaxHR) ^ 2)

dat <- data.frame(x = heart$Age, y = heart$MaxHR)
mod <- glm(y ~ ., data = dat)
loo_err <- cv.glm(dat, mod)$delta # perform LOO crossvalidation
fold_err <- cv.glm(dat, mod, K = 20)$delta # perform crossvalidation 20 fold
print(loo_err)
print(fold_err)

# Task 3

train$AHD <- ifelse(train$AHD == "Yes",1,0)
test$AHD <- ifelse(test$AHD == "Yes",1,0)

mod_lrc <- glm(AHD ~ ., data=train, family = "binomial")
summary(mod_lrc)

lrc.y <- test$AHD
lrc.predy <- predict(mod_lrc, test)
err_lrc <- mean(lrc.y != lrc.predy) ## 

tab1 <- table(ActualValue = lrc.y, PredicteValue = lrc.predy>0.5)
missclasification_ <- 1-sum(diag(tab1))/sum(tab1)

## SVM

# Run SVM classification with a linear kernel, cost of a violation 10 and without data scaling
svmmod = svm(AHD ~ ., data=train, kernel="radial",cost=10)
summary(svmmod)
plot(svmmod, train)
print(svmmod)

svm.y <- test$AHD
svm.predy <- predict(svmmod, test)
err_svm <- mean(svm.y!=svm.predy) 

tab2<-table(ActualValue=svm.y, PredicteValue=svm.predy>0.5)
missclasification <- 1-sum(diag(tab2))/sum(tab2)

# Task 4

path <- "C:/Users/piotr/OneDrive/Pulpit/PiRaP_lab2/wine.data"
wine <- read.csv(path, header = FALSE) #we read the data using csv file
colnames(wine) <- c("Class", "Alcohol", "Malic acid", "Ash", "Alcalinity of ash", "Magnesium", "Total phenols", "Flavanoids", "Nonflavanoid phenols", "Proanthocyanins", "Color intensity", "Hue", "OD280/OD315 of diluted wines", "Proline")

labels <- wine$Class
labels <- as.vector(as.matrix(labels))

dist_1 <- dist(wine)

plot(hclust(dist_1, method="average"), labels = labels, main  = "Average", col = "blue")

par(mfrow=c(1,3))
plot(hclust(mydist,method="average"), labels=labels, main="Average", col="blue")

library(ade4)

cluster = kmeans(wine[,c(2,11)],3)
kmeansRes <- factor(cluster$cluster)
plot(wine[,c(2,11)], col = labels)
library(viridis)
s.class(wine[,c(2,11)], fac = kmeansRes, add.plot = TRUE, col=viridis(3))
