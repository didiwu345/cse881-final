%%% mRMR
function M = MRMR(xcand,xold,y)
CandidateColNum = size(xcand,2);
OldColNum = size(xold,2);

mrmr = zeros(CandidateColNum,2);

for i = 1:CandidateColNum
    Ioldnew = zeros(1,OldColNum);
    for j = 1:OldColNum
        Ioldnew(j)=Information(xold{:,j}, xcand{:,i});
    end
    mrmr(i,1) = Information(xcand{:,i},y) - (sum(Ioldnew)/(OldColNum));
    mrmr(i,2) = i;
end
maxval = max(mrmr(:,1));
num = 1:size(mrmr,1);
idx = num(mrmr(:,1)==maxval);
M=mrmr(idx,2);
end
