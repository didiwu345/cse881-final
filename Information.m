%%% Mutual Information
function f = Information(xcol,ycol)

contingencytab = crosstab(xcol,ycol);
xlen = size(contingencytab,1);
ylen = size(contingencytab,2);

freqtab = zeros(xlen+1, ylen+1);
freqtab(1:end-1, 1:end-1) = contingencytab;
for i=1:size(contingencytab,1)
    freqtab(i,end) = sum(contingencytab(i,:));
end    
for j=1:size(contingencytab,2)
    freqtab(end,j) = sum(contingencytab(:,j));
end
sumall = sum(sum(contingencytab));
freqtab(end,end) = sumall;

px = freqtab(1:end-1,end)./sumall;
py = freqtab(end,1:end-1)./sumall;
pxy = freqtab(1:end-1,1:end-1)./sumall;


infomat = zeros(xlen,ylen);
for i=1:xlen
    for j=1:ylen
        if pxy(i,j) == 0
            infomat(i,j) = 0;
        else
            infomat(i,j) = pxy(i,j)*log10(pxy(i,j)/(px(i)*py(j)));
        end
    end   
end
f = sum(sum(infomat));
end
