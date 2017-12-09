setwd("/Users/wudical/Desktop/CSE881project")

####################################################################
# One hot form data for 5 variables
####################################################################
require(xgboost)
library("Matrix")
x_train <- read.csv("x_train.csv", header = FALSE)
y_train <- read.csv("y_train.csv", header = FALSE)
x_test <- read.csv("x_test.csv", header = FALSE)
y_test <- read.csv("y_test.csv", header = FALSE)

x_train_try <- as.matrix(x_train)
x_train_xgb <- as(x_train_try, "dgCMatrix")
y_train_try <- as.matrix(y_train)
y_train_try <- as.numeric(y_train_try[,1])


x_test_try <- as.matrix(x_test)
x_test_xgb <- as(x_test_try, "dgCMatrix")
y_test_try <- as.matrix(y_test)
y_test_try <- as.numeric(y_test_try[,1])


### put data in "xgb.DMatrix"
dtrain <- xgb.DMatrix(data = x_train_xgb, label = y_train_try)
dtest <- xgb.DMatrix(data = x_test_xgb, label = y_test_try)

### Build XGboost model
watchlist <- list(train = dtrain, test = dtest)  #for xgb.train

### Xgboost Cross Validation, 1000 rounds
set.seed(1122)
xgbcv <- xgb.cv(data = dtrain, metrics = list("error","auc"), max_depth = 4, eta = 0.05, nthread = 2, nfold = 3, nround=1000, objective = "binary:logistic")
# mutate(max_prob = max.col(., ties.method = "last"), label = y_train_try)

### Plot of errors evaluation
e <- data.frame(xgbcv$evaluation_log)
### error
plot(e$iter, e$train_error_mean, col='blue',type = 'l', lty = "dotted",xlab = "Iteration number", ylab = "Training & Testing error", main = "Iteration against error")
lines(e$iter, e$test_error_mean, col='red', type = 'l')
legend(800, 0.256, legend=c("test", "train"), col=c("red", "blue"), lty=1:2, cex=0.8)

### auc
#plot(e$iter, e$train_auc_mean, col='blue',type = 'l', lty = 'dotted',xlab = "Iteration number", ylab = "AUC", main = "Iteration against AUC")
#lines(e$iter, e$test_auc_mean, col='red', type = 'l')
#legend(800, 0.256, legend=c("test", "train"), col=c("red", "blue"), lty=1:2, cex=0.8)


### Xgboost model
set.seed(0612)
bstSparse <- xgb.train(data = dtrain, watchlist = watchlist, max_depth = 4, eta = 0.05, nthread = 2, nrounds = 500, objective = "binary:logistic")
pred <- predict(bstSparse, newdata = dtest)

# Create the confusion matrix
library(caret)
pred.resp <- ifelse(pred >= 0.5, 1, 0)
confusionMatrix(pred.resp, y_test_try, positive="1")

### Plot the ROC curve
library(ROCR)

# Use ROCR package to plot ROC Curve
xgb.pred <- prediction(pred, y_test_try)
xgb.perf <- performance(xgb.pred, "tpr", "fpr")

plot(xgb.perf,
     avg="threshold",
     colorize=TRUE,
     lwd=1,
     main="ROC Curve w/ Thresholds",
     print.cutoffs.at=seq(0, 1, by=0.05),
     text.adj=c(-0.5, 0.5),
     text.cex=0.5)
grid(col="lightgray")
axis(1, at=seq(0, 1, by=0.1))
axis(2, at=seq(0, 1, by=0.1))
abline(v=c(0.1, 0.3, 0.5, 0.7, 0.9), col="lightgray", lty="dotted")
abline(h=c(0.1, 0.3, 0.5, 0.7, 0.9), col="lightgray", lty="dotted")
lines(x=c(0, 1), y=c(0, 1), col="black", lty="dotted")







####################################################################
# One hot form data for 12 variables
####################################################################
require(xgboost)
library("Matrix")

data_train <- read.csv("xxx_trainF.csv", header = F)
data_test <- read.csv("xxx_testF.csv", header = F)

x_train <- data_train
y_train <- read.csv("y_train.csv", header = FALSE)
x_test <- data_test
y_test <- read.csv("y_test.csv", header = FALSE)

x_train_try <- as.matrix(x_train)
x_train_xgb <- as(x_train_try, "dgCMatrix")
y_train_try <- as.matrix(y_train)
y_train_try <- as.numeric(y_train_try[,1])


x_test_try <- as.matrix(x_test)
x_test_xgb <- as(x_test_try, "dgCMatrix")
y_test_try <- as.matrix(y_test)
y_test_try <- as.numeric(y_test_try[,1])


### put data in "xgb.DMatrix"
dtrain <- xgb.DMatrix(data = x_train_xgb, label = y_train_try)
dtest <- xgb.DMatrix(data = x_test_xgb, label = y_test_try)

### Build XGboost model
watchlist <- list(train = dtrain, test = dtest)  #for xgb.train

### Xgboost Cross Validation, 1000 rounds
set.seed(112233)
xgbcv <- xgb.cv(data = dtrain, metrics = list("error","auc"), max_depth = 4, eta = 0.05, nthread = 2, nfold = 3, nround=1000, objective = "binary:logistic")
# mutate(max_prob = max.col(., ties.method = "last"), label = y_train_try)

### Plot of errors evaluation
e <- data.frame(xgbcv$evaluation_log)
### error
plot(e$iter, e$train_error_mean, col='blue',type = 'l', lty = "dotted",xlab = "Iteration number", ylab = "Training & Testing error", main = "Iteration against error")
lines(e$iter, e$test_error_mean, col='red', type = 'l')
legend(800, 0.256, legend=c("test", "train"), col=c("red", "blue"), lty=1:2, cex=0.8)

### auc
#plot(e$iter, e$train_auc_mean, col='blue',type = 'l', lty = 'dotted',xlab = "Iteration number", ylab = "AUC", main = "Iteration against AUC")
#lines(e$iter, e$test_auc_mean, col='red', type = 'l')
#legend(800, 0.256, legend=c("test", "train"), col=c("red", "blue"), lty=1:2, cex=0.8)


### Xgboost model
set.seed(6621)
bstSparse <- xgb.train(data = dtrain, watchlist = watchlist, max_depth = 4, eta = 0.05, nthread = 2, nrounds = 130, objective = "binary:logistic")
pred <- predict(bstSparse, newdata = dtest)

# Create the confusion matrix
library(caret)
pred.resp <- ifelse(pred >= 0.5, 1, 0)
confusionMatrix(pred.resp, y_test_try, positive="1")

### Plot the ROC curve
library(ROCR)

# Use ROCR package to plot ROC Curve
xgb.pred <- prediction(pred, y_test_try)
xgb.perf <- performance(xgb.pred, "tpr", "fpr")

plot(xgb.perf,
     avg="threshold",
     colorize=TRUE,
     lwd=1,
     main="ROC Curve w/ Thresholds",
     print.cutoffs.at=seq(0, 1, by=0.05),
     text.adj=c(-0.5, 0.5),
     text.cex=0.5)
grid(col="lightgray")
axis(1, at=seq(0, 1, by=0.1))
axis(2, at=seq(0, 1, by=0.1))
abline(v=c(0.1, 0.3, 0.5, 0.7, 0.9), col="lightgray", lty="dotted")
abline(h=c(0.1, 0.3, 0.5, 0.7, 0.9), col="lightgray", lty="dotted")
lines(x=c(0, 1), y=c(0, 1), col="black", lty="dotted")




