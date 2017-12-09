function [ctr,ctr_all_day] = hour_ctr(data)

data.SelectedVariableNames = {'click'};
T = readall(data);
ctr_all_day = sum(T.click)/length(T.click);
  % divide by 24 hours
hour_size = (length(T.click) - mod(length(T.click),24))/24;
hour_group = reshape( 1:(length(T.click)-mod(length(T.click),24)), [hour_size,24] );
ctr = zeros(1,24);

for i =1 :24
    ctr(i) = (sum(T.click(hour_group(:,i)))+0.05*75) / length(T.click(hour_group(:,i)) );
end

end

