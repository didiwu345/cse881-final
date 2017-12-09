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


% train_total = [train_OH_1;train_OH_2;train_OH_3];
% y_train_total = [y_train_1;y_train_2;y_train_3];

%% %%%%%%%%%%%%%%%%%%%%%  Random Forest  %%%%%%%%%%%%%%%%%%%
x_train = train_OH_1;
x_test = test_OH_1;
y_train = y_train_1;

% for orgi  parameter_need to tune --> iterat
rng(1); % For reproducibility 
ranforest = TreeBagger(100,x_train,y_train,'OOBPrediction','On',...
    'Method','classification');     % sqrt(#total variables for classification) = # predictors to sample
figure; 
oobErrorBaggedEnsemble = oobError(ranforest);
plot(oobErrorBaggedEnsemble)
xlabel 'Number of grown trees';
ylabel 'Out-of-bag classification error';  %--->indicate only need 63 trees

y_pred = cellfun(@(x)str2double(x), predict(ranforest,x_test));
confu = confusionmat(y_test,y_pred)  
EVAL = Evaluate(y_test,y_pred)  %   0.8123    0.6171    0.0319    0.0607

% Retrain Lossest point, tree = 63
ranforest_63 = TreeBagger(63,x_train,y_train,'OOBPrediction','On',...
    'Method','classification');   
y_pred_RF_63 = cellfun(@(x)str2double(x), predict(ranforest_63,x_test));
confu_RF_63 = confusionmat(y_test,y_pred_RF_63)  
EVAL_RF_63 = Evaluate(y_test,y_pred_RF_63)    %  The same result 0.8123    0.6171    0.0319    0.0607



%% %%%%%%%%%%%%%%%%%%%%%  Random Forest Under Add CTR IMP  %%%%%%%%%%%%%%%%%%%
load ('train_OH_1_ADD.mat')
load ('test_OH_1_ADD.mat')
x_train = train_OH_1_ADD;
x_test = test_OH_1_ADD;

rng(1); % For reproducibility 
ranforest_ADD = TreeBagger(100,x_train,y_train,'OOBPrediction','On',...
    'Method','classification');    
oobErrorBaggedEnsemble_ADD = oobError(ranforest_ADD);
figure;
plot(oobErrorBaggedEnsemble_ADD,'--')
hold on 
plot(oobErrorBaggedEnsemble)
hold off

legend( 'Random Sample w/o CTR&IMP', 'Random Sample' )
xlabel 'Number of grown trees';
ylabel 'Out-of-bag classification error';  

y_pred_ADD = cellfun(@(x)str2double(x), predict(ranforest_ADD,x_test));
confu_ADD = confusionmat(y_test,y_pred_ADD)  
EVAL_ADD = Evaluate(y_test,y_pred_ADD)  


   
%%%%%%%%%%%%%%%%% For C14 = '4687' dataset ############   
% remove some infrequent variables  
Minisup = 9;  % --> change Minsup = 9,10,20,30,40,50,100
col = [];
for i = 1:size(x_train,2)
if length(unique(x_train(:,i))) == 1 || length(find((x_train(:,i) == 1)))< Minisup
    col = [col,i];
end
end
x_train(:,col) = [];
x_test(:,col) = [];
rng(1); % For reproducibility 
ranforest_op = TreeBagger(60,x_train,y_train,'OOBPrediction','On',...
    'Method','classification');     % sqrt(#total variables for classification) = # predictors to sample
figure; 
oobErrorBaggedEnsemble_op = oobError(ranforest);
plot(oobErrorBaggedEnsemble_op)
xlabel 'Number of grown trees';
ylabel 'Out-of-bag classification error';  %--->indicate only need 50 trees

y_pred_ranf_op = predict(ranforest_op,x_test);
EVAL_ranf_op = Evaluate(y_test,y_pred_ranf_op)  %  0.7417    0.3390    0.0005    0.0011


