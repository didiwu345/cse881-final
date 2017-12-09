%%  CTR plot Per hour  
data1 = tabularTextDatastore('time141021.csv');
[ctr_hour_d1,ctr_all_d1] = hour_ctr(data1);
data2 = tabularTextDatastore('time141022.csv');
[ctr_hour_d2,ctr_all_d2] = hour_ctr(data2);
data3 = tabularTextDatastore('time141023.csv');
[ctr_hour_d3,ctr_all_d3] = hour_ctr(data3);
data4 = tabularTextDatastore('time141024.csv');
[ctr_hour_d4,ctr_all_d4] = hour_ctr(data4);
data5 = tabularTextDatastore('time141025.csv');
[ctr_hour_d5,ctr_all_d5] = hour_ctr(data5);
data6 = tabularTextDatastore('time141026.csv');
[ctr_hour_d6,ctr_all_d6] = hour_ctr(data6);
data7 = tabularTextDatastore('time141027.csv');
[ctr_hour_d7,ctr_all_d7] = hour_ctr(data7);
data8 = tabularTextDatastore('time141028.csv');
[ctr_hour_d8,ctr_all_d8] = hour_ctr(data8);
data9 = tabularTextDatastore('time141029.csv');
[ctr_hour_d9,ctr_all_d9] = hour_ctr(data9);

plot([1:24,25:48,49:72,73:96,97:120,121:144,145:168,169:192,193:217],[ctr_hour_d1,ctr_hour_d2,ctr_hour_d3,ctr_hour_d4,ctr_hour_d5,ctr_hour_d6,ctr_hour_d7,ctr_hour_d8,ctr_hour_d9]);
ctr_day= [ctr_all_d1,ctr_all_d2,ctr_all_d3,ctr_all_d4,ctr_all_d5,ctr_all_d6,ctr_all_d7,ctr_all_d8,ctr_all_d9];       






%% Train day 3,4,5 test day 6
data3 = tabularTextDatastore('time141023.csv');
data3.SelectedVariableNames = {'click','C14'};
data4 = tabularTextDatastore('time141024.csv');
data4.SelectedVariableNames = {'click','C14'};
data5 = tabularTextDatastore('time141025.csv');
data5.SelectedVariableNames = {'click','C14'};

T = [readall(data3);readall(data4);readall(data5)];
type = unique(T.C14);       %1180 types in C14
imp = zeros(length(type),1);
ctr = zeros(length(type),1);
for i = 1:length(type)
   idx = find(T.C14 == type(i));
   imp(i) = length(idx);
   ctr(i) = ( sum(T.click(idx)) + 0.05*75  ) / imp(i);
end

hist(ctr)  % obtain ctr
hist(imp)  % obtain imp

% length(imp) = 1180; but 
% remove type which imp < 100 000 --> since min(ctr) = 0.0034; 100 000imp-340click;
idx_imp = type (find(imp>100000)); 
% remove type which ctr > 1
idx_ctr = type (find( ctr< 1 )); 
% different types of C14
idx_inter = intersect (idx_imp, idx_ctr); 



% frequent 22 types out of 1180 types in C14, and 44% of data
N = 1:length(T.C14);
idt=[];
size_idt = [];
for i = 1:length(idx_inter)
  id = find( T.C14 == idx_inter(i));
  size_i = length(id);
  size_idt = [size_idt;size_i];
end
Adv_group = [idx_inter size_idt];
sum(size_idt)/length(T.C14)  %  keep 0.44 data


%% choose the first 
%% Example 1: C14 = '4687'    ---> imp 319134
%% C14 = 'idx_inter(1)= 4687'

idx = find(T.C14 == 4687);

data3 = tabularTextDatastore('time141023.csv');
data3.SelectedVariableNames = {'click','C14','C1','banner_pos','site_id','site_domain','site_category','app_id','app_domain','app_category','device_id','device_model','device_type','device_conn_type','C15','C16','C17','C18','C19','C20','C21'};
data3 = change2char(data3);
t = readall(data3);

data4 = tabularTextDatastore('time141024.csv');
data4.SelectedVariableNames =  {'click','C14','C1','banner_pos','site_id','site_domain','site_category','app_id','app_domain','app_category','device_id','device_model','device_type','device_conn_type','C15','C16','C17','C18','C19','C20','C21'};
data4 = change2char(data4);
t4 = readall(data4);

data5 = tabularTextDatastore('time141025.csv');
data5.SelectedVariableNames =  {'click','C14','C1','banner_pos','site_id','site_domain','site_category','app_id','app_domain','app_category','device_id','device_model','device_type','device_conn_type','C15','C16','C17','C18','C19','C20','C21'};
data5 = change2char(data5);
t5 = readall(data5);


% train data --'train4687'
comb = [t;t4;t5];
save 'train_comb.mat' comb

train4687 = comb(idx,:);
    % remove only one unique value variable
    uni = zeros(20,1);
    for i = 1:20
     uni(i) = size(unique(train4687(:,i)),1);
    end
var_select = (uni>1);
train4687 = train4687(:,var_select);
save 'train1.mat' train4687


% test data  --'test4687'
data6 = tabularTextDatastore('time141026.csv');
data6.SelectedVariableNames = {'click','C14','C1','banner_pos','site_id','site_domain','site_category','app_id','app_domain','app_category','device_id','device_model','device_type','device_conn_type','C15','C16','C17','C18','C19','C20','C21'};
data6 = change2char(data6);
t6 = readall(data6);
save 'test_comb.mat' t6

test4687 = t6(find(t6.C14 == '4687'), :);
test4687(:,1) = [];
test4687 = test4687(:,var_select);
save 'test1.mat' test4687 



%% Example 2: '21189'   ---> imp 297056
idx2 = find(T.C14 == 21189);
train21189 = comb(idx2,:);
    % remove only one unique value variable
    uni = zeros(20,1);
    for i = 1:20
     uni(i) = size(unique(train21189(:,i)),1);
    end
var_select = (uni>1);
train21189 = train21189 (:,var_select);
save 'train2.mat' train21189

test21189 = t6(find(t6.C14 == '21189'), :);
test21189(:,1) = [];
test21189 = test21189(:,var_select);
save 'test2.mat' test21189



