%% train 1,2,3 ; test 1
load ('train_OH_1.mat')
load ('y_train_1.mat')
load ('train_OH_2.mat')
load ('y_train_2.mat')
load ('train_OH_3.mat')
load ('y_train_3.mat')

load ('test_OH_1.mat')
load ('y_test_1.mat')
x_test = test_OH_1;
y_test = y_test_1;



%% %%%%%%%%%%%%%%%%      Naive Bayes  %%%%%%%%%%%%%%%
train_total = [train_OH_1;train_OH_2;train_OH_3];
y_train_total = [y_train_1;y_train_2;y_train_3];

train_ErrRate = zeros(1,3);
test_ErrRate =  zeros(1,3);
y_pred_NB = zeros(size(x_test,1),3);
for t = 1:3
    x_train = train_total( (((t-1)*400000+1): t*400000) ,:);
    y_train = y_train_total( (((t-1)*400000+1): t*400000) ,:);
    % hist(log10(sum(x_train,1)));   %drop out infrequent columns because if p(x|y) is too small, est_p(y|x) is close to 0;
    col = [];
    for i = 1:size(x_train,2)
     if length(unique(x_train(:,i))) == 1 || length(find((x_train(:,i) == 1)))<120
      col = [col,i];
     end
    end
% delete those columns not appears in x_train or infrequent columns(fre < 250)
   x_test = test_OH_1;
   x_train(:,col) = [];
   x_test(:,col) = [];

   prior_y1 = sum((y_train==1))/length(y_train);  %0.1823
   prior_y0 = sum((y_train==0))/length(y_train);  %0.8177
   prior = [prior_y1 prior_y0];
% w/o cross validation  +  prob_est = 
   Mdl = fitcnb(x_train,y_train,'Prior',prior);   % w/o cross validation 
   train_ErrRate(t) = resubLoss(Mdl,'LossFun','ClassifErr');    % 0.2174
   test_ErrRate(t) = loss(Mdl,x_test,y_test);                   % 0.2048
   y_pred(:,t) = predict(Mdl,x_test);
   
end

y_pred(:,end+1) = double(sum(y_pred,2)>=2);
%% ensemble result %%%
EVAL_NB = zeros(4,4);
for i = 1:4
   EVAL_NB(i,:) = Evaluate(y_test,y_pred(:,i) );
end
y_pred_NB = y_pred;
confu_NB = confusionmat(y_test,y_pred_NB(:,end))  




%% %%%%%%%%%%%%%%%%      Naive Bayes  Under Add CTR & IMP %%%%%%%%%%%%%%%
load ('train_OH_1_ADD.mat')
load ('train_OH_3_ADD.mat')
load ('y_train_1.mat')
load ('y_train_3.mat')

load ('test_OH_1_ADD.mat')
load ('y_test_1.mat')


x_train = train_OH_1_ADD;
y_train = y_train_1;
y_test = y_test_1;
 col = [];
    for i = 1:size(x_train,2)
     if length(unique(x_train(:,i))) == 1 || length(find((x_train(:,i) == 1)))<120
      col = [col,i];
     end
    end
% delete those columns not appears in x_train or infrequent columns(fre < 120)
   x_test = test_OH_1_ADD;
   x_train(:,col) = [];
   x_test(:,col) = [];

   prior_y1 = sum((y_train==1))/length(y_train);  %0.1823
   prior_y0 = sum((y_train==0))/length(y_train);  %0.8177
   prior = [prior_y1 prior_y0];
% w/o cross validation  +  prob_est = 
   Mdl = fitcnb(x_train,y_train,'Prior',prior);   % w/o cross validation 
   train_ErrRate = resubLoss(Mdl,'LossFun','ClassifErr');    % 0.2174
   test_ErrRate = loss(Mdl,x_test,y_test);                   % 0.2048
   y_pred= predict(Mdl,x_test);

 Evaluate(y_test,y_pred(:,1) )    %     0.4322    0.2376    0.9006    0.3760









