install.packages('LiblineaR')
library(LiblineaR)
x_train_1 <- read.csv("C:/Users/chenj107/Final/original dataset/x_train_1.csv", header=FALSE)
x_train_2 <- read.csv("C:/Users/chenj107/Final/original dataset/x_train_2.csv", header=FALSE)
x_train_3 <- read.csv("C:/Users/chenj107/Final/original dataset/x_train_3.csv", header=FALSE)


y_train_1 <- read.csv("C:/Users/chenj107/Final/original dataset/y_train_1.csv", quote="\"", comment.char="",header=FALSE)
y_train_2 <- read.csv("C:/Users/chenj107/Final/original dataset/y_train_2.csv", quote="\"", comment.char="",header=FALSE)
y_train_3 <- read.csv("C:/Users/chenj107/Final/original dataset/y_train_3.csv", quote="\"", comment.char="",header=FALSE)


x_test <- read.csv("C:/Users/chenj107/Final/original dataset/x_test_1.csv", header=FALSE)
y_test <- read.table("C:/Users/chenj107/Final/original dataset/y_test_1.csv", quote="\"", comment.char="")

##########################################
####### For Train Set 1 ###################
idx = sample(c(1:dim(x_train_1)[1]),dim(x_train_1)[1] , replace = FALSE)
x_train_val = x_train_1[idx[1:150000],]  ## validation set
x_train_tra = x_train_1[idx[150001:400000],]
x_train = x_train_tra;   ## train set

y_train_val = y_train_1[idx[1:150000],]
y_train_tra = y_train_1[idx[150001:400000],]
y_train = y_train_tra;


# Find the best model with the best cost parameter via 3-fold cross-validations  
tryTypes=c(0:7)
tryCosts=c(1000,1,0.001)
bestCost=NA
bestAcc=0
bestType=NA

# for type =  . 0 - L2-regularized logistic regression (primal)
# 1 - L2-regularized L2-loss support vector classification (dual)
# 2 - L2-regularized L2-loss support vector classification (primal)
# 3 - L2-regularized L1-loss support vector classification (dual)
# 4 - support vector classification by Crammer and Singer
# . 5 - L1-regularized L2-loss support vector classification
# . 6 - L1-regularized logistic regression
# . 7 - L2-regularized logistic regression (dual)

for(ty in tryTypes){
  for(co in tryCosts){
    acc = LiblineaR( as.matrix(x_train), as.factor(as.matrix(y_train)),  type=ty, cost=co, bias=1,verbose=FALSE)
    cat("Results for C=",co," : ",acc," accuracy.\n",sep="")
    if(acc>bestAcc){
      bestCost = co
      bestAcc = acc
      bestType = ty
    }
  }
}

cat("Best model type is:",bestType,"\n")
cat("Best cost is:",bestCost,"\n")
cat("Best accuracy is:",bestAcc,"\n")

# Make prediction
pr=FALSE
if(bestType == 0 || bestType == 7) pr = TRUE


####### Re-train best model with best cost value. with bestType = 7 ##### 
bestType = 7
# Re-Train best C 
tryCosts=seq(1,1.5,by=0.1)
acc = rep(0,length(tryCosts))
Precision= rep(0,length(tryCosts))
for(i in 1:(length(tryCosts))) {
   model_lib = LiblineaR(as.matrix(x_train), as.factor(as.matrix(y_train)), type=bestType, cost=tryCosts[i], bias=1, verbose=FALSE)
   pred = predict(model_lib, as.matrix(x_train_val), proba=pr, decisionValues=TRUE)
   ## confusion matrix
   confusionMatrix=table(as.factor(as.matrix(pred[[1]])),as.factor(as.matrix(y_train_val)))
   acc[i] = (confusionMatrix[1,1] + confusionMatrix[2,2]) / sum(confusionMatrix);
   Precision[i] = confusionMatrix[2,2] / (confusionMatrix[2,1]+confusionMatrix[2,2]) 
}


### acc and Precision under different C are the same
### acc =  0.8216133 ; Precision = 0.5524439
### --->   bestType = 7; Costs = 1; is fine;


####### Re-train best model with bestType = 7 , Costs = 1 in the whole train set##### 
x_train = x_train_1
y_train = y_train_1

M_lib = LiblineaR(as.matrix(x_train), as.factor(as.matrix(y_train)), type=7, cost=1, bias=1, verbose=FALSE)
pred_1 = predict(M_lib, as.matrix(x_test), proba=pr, decisionValues=TRUE)
confusionMatrix_1=table(as.factor(as.matrix(pred_1[[1]])),as.factor(as.matrix(y_test)))
acc_1 = (confusionMatrix[1,1] + confusionMatrix[2,2]) / sum(confusionMatrix);
   #  0.8216133
Precision_1= confusionMatrix[2,2] / (confusionMatrix[2,1]+confusionMatrix[2,2]) 
   #  0.5524439



###################################################################################
####### For Train Set 2 ####################### the same result of bestType  and C
idx = sample(c(1:dim(x_train_2)[1]),dim(x_train_2)[1] , replace = FALSE)
x_train_val = x_train_2[idx[1:150000],]  ## validation set
x_train_tra = x_train_2[idx[150001:400000],]
x_train = x_train_tra;   ## train set

y_train_val = y_train_2[idx[1:150000],]
y_train_tra = y_train_2[idx[150001:400000],]
y_train = y_train_tra;

  
x_train = x_train_2
y_train = y_train_2

M_lib = LiblineaR(as.matrix(x_train), as.factor(as.matrix(y_train)), type=7, cost=1, bias=1, verbose=FALSE)
pred_2 = predict(M_lib, as.matrix(x_test), proba=pr, decisionValues=TRUE)
confusionMatrix_2=table(as.factor(as.matrix(pred_2[[1]])),as.factor(as.matrix(y_test)))
acc_2 = (confusionMatrix[1,1] + confusionMatrix[2,2]) / sum(confusionMatrix);
#  0.8216133
Precision_2= confusionMatrix[2,2] / (confusionMatrix[2,1]+confusionMatrix[2,2]) 
#  0.5524439

###############################################
####### For Train Set 3 ###################
x_train = x_train_3
y_train = y_train_3

M_lib = LiblineaR(as.matrix(x_train), as.factor(as.matrix(y_train)), type=7, cost=1, bias=1, verbose=FALSE)
pred_3 = predict(M_lib, as.matrix(x_test), proba=pr, decisionValues=TRUE)
confusionMatrix_3=table(as.factor(as.matrix(pred_3[[1]])),as.factor(as.matrix(y_test)))
acc_3 = (confusionMatrix[1,1] + confusionMatrix[2,2]) / sum(confusionMatrix);
# 0.8191267
Precision_3= confusionMatrix[2,2] / (confusionMatrix[2,1]+confusionMatrix[2,2]) 
#  0.571971



####################################################
###### Ensemble three training set result #########
pred_LIB_ensemble = cbind((as.matrix(pred_1[[1]])), (as.matrix(pred_2[[1]])),(as.matrix(pred_3[[1]])))
pred_LIB_ensemble = apply(pred_LIB_ensemble, 2, function(x) as.numeric(as.factor(x))) -1 ;
pred_LIB_en = ifelse(apply(pred_LIB_ensemble,1,sum)>2,1,0)
confusionMatrix_en=table(pred_LIB_en ,as.factor(as.matrix(y_test)))
#pred_LIB_en     0     1
#           0 80160 17821
#           1   842  1177

acc_en = (confusionMatrix_en[1,1] + confusionMatrix_en[2,2]) / sum(confusionMatrix_en);
#  0.81337
Precision_en= confusionMatrix_en[2,2] / (confusionMatrix_en[2,1]+confusionMatrix_en[2,2]) 
# 0.5829619





####################################################
###### RSWO  #########
x_train_Add <- read.csv("C:/Users/chenj107/Final/original dataset/train_oh_add.csv", header=FALSE)
x_test_Add <- read.csv("C:/Users/chenj107/Final/original dataset/test_oh_add.csv", quote="\"", comment.char="",header=FALSE)

idx = sample(c(1:dim(x_train_Add)[1]),dim(x_train_Add)[1] , replace = FALSE)
x_train_val = x_train_Add[idx[1:150000],]  ## validation set
x_train_tra = x_train_Add[idx[150001:400000],]
x_train = x_train_tra;   ## train set

y_train_val = y_train_1[idx[1:150000],]
y_train_tra = y_train_1[idx[150001:400000],]
y_train = y_train_tra;


x_train = x_train_Add
y_train = y_train_1

M_lib = LiblineaR(as.matrix(x_train), as.factor(as.matrix(y_train)), type=7, cost=1, bias=1, verbose=FALSE)
pred_Add = predict(M_lib, as.matrix(x_test_Add), proba=pr, decisionValues=TRUE)
confusionMatrix_Add=table(as.factor(as.matrix(pred_Add[[1]])),as.factor(as.matrix(y_test)))
#       0     1
# 0 59349 12986
# 1 21653  6012
acc_Add = (confusionMatrix_Add[1,1] + confusionMatrix_Add[2,2]) / sum(confusionMatrix_Add);
#  0.65361
Precision_Add= confusionMatrix_Add[2,2] / (confusionMatrix_Add[2,1]+confusionMatrix_Add[2,2]) 
#  0.2173143