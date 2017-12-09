load ('train_comb.mat');
train =comb;
train.click = double(train.click)-1;
load ('test_comb.mat');
test =t6;
test.click = double(test.click)-1;
nrow_train = size(train,1);


%% Step 1 :  Remove infrequent category (imp < 10000) --> click < 1000 in three days
level = zeros(size(train,2),1);
for i = 1:size(train,2)
    level(i) = length( unique(table2array(train(:,i))) );
end    
level;

  %remove device_ip-col 11
train(:,11) = [];
test(:,11)=[];

% level2 = [2,5,6,8,11];
% level 2
   S = summary(train(:,2));
   so = find(S.C14.Counts < 10000);  
   id_2 = [];
    for i = 1:length(so)
     id_0 = find (table2array(train(:,2)) ==  S.C14.Categories(so(i)));
     id_2 = [id_2;id_0];
    end
% level 5
  S = summary(train(:,5));
   so = find(S.site_id.Counts < 10000);  
   id_5 = [];
    for i = 1:length(so)
     id_0 = find (table2array(train(:,5)) ==  S.site_id.Categories(so(i)));
     id_5 = [id_5;id_0];
    end
% level 6
    S = summary(train(:,6));
   so = find(S.site_domain.Counts < 10000);  
   id_6 = [];
    for i = 1:length(so)
     id_0 = find (table2array(train(:,6)) ==  S.site_domain.Categories(so(i)));
     id_6 = [id_6;id_0];
    end
% level 8   
    S = summary(train(:,8));
   so = find(S.app_id.Counts < 10000);  
   id_8 = [];
    for i = 1:length(so)
     id_0 = find (table2array(train(:,8)) ==  S.app_id.Categories(so(i)));
     id_8 = [id_8;id_0];
    end
% level 11   
    S = summary(train(:,11));
   so = find(S.device_model.Counts < 10000);  
   id_11 = [];
    for i = 1:length(so)
     id_0 = find (table2array(train(:,11)) ==  S.device_model.Categories(so(i)));
     id_11 = [id_11;id_0];
    end     
     
 rm = union(id_2, id_5);
 rm = union(rm, id_6);
 rm = union(rm, id_8);
 rm = union(rm, id_11);    %% delete infrequent 1,970,000 instances
 train(rm,:) = [];  

 
 %% step 2 : Delete the categories without in test set
 idxx=[];
 for i = 2:size(train,2)
     var_train = unique(table2array(train(:,i)));
     var_test = unique(table2array(test(:,i)));
     idx = find ( double(ismember( var_test, var_train) == 0) );
     for j = 1:length(idx)    
          idxx0 = find( table2array(test(:,i))== var_test(idx(j)));
          idxx = [idxx;idxx0];
     end
 end
 test(idxx,:) = [];    % remove 1,732,836 test data.    
 

 save 'train_RE.mat' train
 save 'test_RE.mat' test
 

 %% Step3 :  mRMR (Feature Selection) and  find 10 features ... 
 
 
 

 
 
 %% Step4 : Random Sample
 load 'train_RE.mat'   % 5,744,993
 load 'test_RE.mat'    % 2,130,027
 rng(3)
 % randomsample into 3 training sets with 400,000 each;
 % randomsample into 3 test sets with 100,000 each;
 sample_idx = randperm(size(train,1), 1200000)';
 sample_test = randperm(size(test,1), 300000)';
 



 %% step 5 : Add imp and CTR for each features
 CTR = zeros(size(train,1),(size(train,2)-1));
 IMP= zeros(size(train,1),(size(train,2)-1));
 
   for i = 1 : (size(train,2)-1)
      feat = unique(table2array(train(:,i)));
        for j = 1:length(feat)
        id  = find(table2array(train(:,i)) == feat(j));
        IMP(id,i) = length(id);
        CTR(id,i) = (sum(train.click(id)) +0.05*75)/ length(id);
        end
   end
   
  % normalization ctr and imp for Train
  CTR_norm = zeros(size(train,1),(size(train,2)-1));  
  IMP_norm = zeros(size(train,1),(size(train,2)-1));  
  for i = 1:19
    CTR_norm(:,i) = (CTR(:,i) - mean(CTR(:,i))) ./ std(CTR(:,i));
    IMP_norm(:,i) = (IMP(:,i) - mean(IMP(:,i))) ./ std(IMP(:,i));
  end
  
  % Add ctr and imp in test set
[ add_imp,add_ctr ] = Add2test( test,train, CTR_norm, IMP_norm );

save 'add_ctr.mat' add_ctr  % normalize ctr for Test
save 'add_imp.mat' add_imp  % normalize imp for Test



%% Step 6: one-hot for all data
 % for set 3
 y_train_3 = train.click(sample_idx(800001:1200000));
 x_train_3 = train(sample_idx(800001:1200000),2:end);
 
 y_test_3 = test.click(sample_test(200001:300000));
 x_test_3 = test(sample_test(200001:300000),2:end);
 
data=[x_train_3;x_test_3];

C1_hot = dummyvar(findgroups(data.C1));
banner_pos_hot = dummyvar(findgroups(data.banner_pos));
app_domain_hot = dummyvar(findgroups(data.app_domain));
app_category_hot = dummyvar(findgroups(data.app_category));
device_type_hot = dummyvar(findgroups(data.device_type));
device_conn_type_hot = dummyvar(findgroups(data.device_conn_type));
C14_hot = dummyvar(findgroups(data.C14));
C15_hot = dummyvar(findgroups(data.C15));
C16_hot = dummyvar(findgroups(data.C16));
C18_hot = dummyvar(findgroups(data.C18));

new = [C14_hot  C1_hot  device_type_hot  C15_hot device_conn_type_hot C16_hot banner_pos_hot app_category_hot C18_hot app_domain_hot]; 
FeatList = { 'C14_hot' , 'C1_hot' , 'device_type_hot' , 'C15_hot', 'device_conn_type_hot','C16_hot', 'banner_pos_hot', 'app_category_hot', 'C18_hot' ,'app_domain_hot'};


train_OH_3 = new(1:size(x_train_3,1), :);
test_OH_3 = new((size(x_train_3,1)+1):end,:);
save 'train_OH_3.mat' train_OH_3
save 'test_OH_3.mat' test_OH_3
save 'y_test_3.mat' y_test_3
save 'y_train_3.mat' y_train_3
save 'FeatList'
% Add_CTR and IMP
train_OH_3_ADD = [train_OH_3 CTR_norm(sample_idx(800001:1200000),:) IMP_norm(sample_idx(800001:1200000),:)];
test_OH_3_ADD = [test_OH_3 add_ctr(sample_test(200001:300000),:) add_imp(sample_test(200001:300000),:)]; 
save 'train_OH_3_ADD.mat' train_OH_3_ADD
save 'test_OH_3_ADD.mat' test_OH_3_ADD



%% repeat ubove ... to obtain set 1 and set 2
 y_train_2 = train.click(sample_idx(400001:800000));
 x_train_2 = train(sample_idx(400001:800000),2:end);
 
 y_test_2 = test.click(sample_test(100001:200000));
 x_test_2 = test(sample_test(100001:200000),2:end);
 
data=[x_train_2;x_test_2];

C1_hot = dummyvar(findgroups(data.C1));
banner_pos_hot = dummyvar(findgroups(data.banner_pos));
app_domain_hot = dummyvar(findgroups(data.app_domain));
app_category_hot = dummyvar(findgroups(data.app_category));
device_type_hot = dummyvar(findgroups(data.device_type));
device_conn_type_hot = dummyvar(findgroups(data.device_conn_type));
C14_hot = dummyvar(findgroups(data.C14));
C15_hot = dummyvar(findgroups(data.C15));
C16_hot = dummyvar(findgroups(data.C16));
C18_hot = dummyvar(findgroups(data.C18));

new = [C14_hot  C1_hot  device_type_hot  C15_hot device_conn_type_hot C16_hot banner_pos_hot app_category_hot C18_hot app_domain_hot]; 
FeatList = { 'C14_hot' , 'C1_hot' , 'device_type_hot' , 'C15_hot', 'device_conn_type_hot','C16_hot', 'banner_pos_hot', 'app_category_hot', 'C18_hot' ,'app_domain_hot'};

train_OH_2 = new(1:size(x_train_2,1), :);
test_OH_2 = new((size(x_train_2,1)+1):end,:);
save 'train_OH_2.mat' train_OH_2
save 'test_OH_2.mat' test_OH_2
save 'y_test_2.mat' y_test_2
save 'y_train_2.mat' y_train_2
save 'FeatList'
% Add_CTR and IMP
train_OH_2_ADD = [train_OH_2 CTR_norm(sample_idx(400001:800000),:) IMP_norm(sample_idx(400001:800000),:)];
test_OH_2_ADD = [test_OH_2 add_ctr(sample_test(100001:200000),:) add_imp(sample_test(100001:200000),:)]; 
save 'train_OH_2_ADD.mat' train_OH_2_ADD
save 'test_OH_2_ADD.mat' test_OH_2_ADD




%% set 1  %%%%%
y_train_1 = train.click(sample_idx(1:400000));
 x_train_1 = train(sample_idx(1:400000),2:end);
 
 y_test_1 = test.click(sample_test(1:100000));
 x_test_1 = test(sample_test(1:100000),2:end);
 
data=[x_train_1;x_test_1];

C1_hot = dummyvar(findgroups(data.C1));
banner_pos_hot = dummyvar(findgroups(data.banner_pos));
app_domain_hot = dummyvar(findgroups(data.app_domain));
app_category_hot = dummyvar(findgroups(data.app_category));
device_type_hot = dummyvar(findgroups(data.device_type));
device_conn_type_hot = dummyvar(findgroups(data.device_conn_type));
C14_hot = dummyvar(findgroups(data.C14));
C15_hot = dummyvar(findgroups(data.C15));
C16_hot = dummyvar(findgroups(data.C16));
C18_hot = dummyvar(findgroups(data.C18));

new = [C14_hot  C1_hot  device_type_hot  C15_hot device_conn_type_hot C16_hot banner_pos_hot app_category_hot C18_hot app_domain_hot]; 
FeatList = { 'C14_hot' , 'C1_hot' , 'device_type_hot' , 'C15_hot', 'device_conn_type_hot','C16_hot', 'banner_pos_hot', 'app_category_hot', 'C18_hot' ,'app_domain_hot'};

train_OH_1 = new(1:size(x_train_1,1), :);
test_OH_1 = new((size(x_train_2,1)+1):end,:);
save 'train_OH_1.mat' train_OH_1
save 'test_OH_1.mat' test_OH_1
save 'y_test_1.mat' y_test_1
save 'y_train_1.mat' y_train_1
save 'FeatList'
% Add_CTR and IMP
train_OH_1_ADD = [train_OH_1 CTR_norm(sample_idx(1:400000),:) IMP_norm(sample_idx(1:400000),:)];
test_OH_1_ADD = [test_OH_1 add_ctr(sample_test(1:100000),:) add_imp(sample_test(1:100000),:)]; 
save 'train_OH_1_ADD.mat' train_OH_1_ADD
save 'test_OH_1_ADD.mat' test_OH_1_ADD
