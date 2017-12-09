function mrmrImplement(data,Y)
X=data(:,2:end);
% Column names of original Table
ColName = X.Properties.VariableNames;

% Choose 1st feature according to maximal relevency
f1 = MaxRelevency(X,Y);

fprintf('\nFeature %d is: ', 1)
fprintf('%c', ColName{f1})
fprintf('\n')

ColName(f1)=[];
xold = X(:,f1);
X(:,f1)=[];

% Number of Features needed
m=10;
i=2;

% Select m features
while i<=m
    f2 = MRMR(X,xold,Y);
    
    fprintf('\nFeature %d is: ', i)
    fprintf('%c', ColName{f2})
    fprintf('\n')
    
    ColName(f2)=[];
    
    xold = [xold X(:,f2)];
    X(:,f2)=[];    
    
    i=i+1;
end    
end