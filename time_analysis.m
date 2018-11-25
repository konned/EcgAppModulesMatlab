function [RR_mean, SDNN, RMSSD, NN50, pNN50] = time_analysis(RRintervals)

%Average
RR_mean=mean(RRintervals);

%Standard deviation
SDNN=std(RRintervals);

%Root mean square of successive differences
N = length(RRintervals);
temp=0;
for i=2:1:N
    temp=temp + (RRintervals(i) - RRintervals(i-1))^2;
end

temp2 = temp/(N - 1);
RMSSD= sqrt(temp2);


%NN50
temp1 = zeros(1,N-1);
for k=1:1:N-1
    temp1(k) = (RRintervals(k+1)-RRintervals(k));
end

NN50 = 0;
for k=1:1:N-1
   if (abs(temp1(k))>50)
       NN50 = NN50 +1;
   end
end


%pNN50
pNN50 = (NN50/(N-1)) * 100;

end