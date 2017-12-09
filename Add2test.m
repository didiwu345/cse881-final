function [ add_imp,add_ctr ] = Add2test( test,train, CTR, IMP )

add_imp = zeros(size(test,1),2);
add_ctr = zeros(size(test,1),2);

for j = 1:19
 type = table2array(unique(train(:,j+1)));
 for i = 1:size(type,1)
    idx = find (table2array(test(:,j+1)) == type(i));
    if any(idx) == 0
        continue
    end    
    idx_train = find(table2array(train(:,j+1)) == type(i), 1, 'first');
    add_ctr(idx,j) = CTR(idx_train,j);
    add_imp(idx,j) = IMP(idx_train,j);  
 end    


end

