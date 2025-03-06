function subset = mySubset(FeP,FeN)
%feature selection based on u test and coefficient of variation
% a row vector is a sample

if size(FeP,2) ~= size(FeN,2)
  error 'column sizes of FeP and FeN must be same.';
end

[p,~] = mwu(FeP,FeN); % u test
meanp = mean(FeP);
meann = mean(FeN);
stdp = std(FeP);
stdn = std(FeN);
cvp = stdp./ meanp;
cvn = stdn./meann;
subset = find(p<=0.05 & cvp <= 0.15 & cvn <= 0.15);