%%% Maximal Relevency
function D = MaxRelevency(x,y)
xColNum = size(x,2);

mr = zeros(xColNum,2);
for i=1:xColNum
    mr(i,1) = Information(x{:,i},y);
    mr(i,2) = i;
end
[~,maximum] = max(mr(:,1));
num = 1:xColNum;
idx = num(maximum);
D = mr(idx,2);

end