function indices = lowfreqidxes5ct(levels)
%indices=lowfreqidxes5ct(levels) finds low-frequency components indices of a contourlet transform.

levels = flip(levels);
indices = nan(1,length(levels));
cursor = 0;
for i=1:length(levels)
  indices(i) = cursor + 1;
  if levels(i) > 0 
    cursor = cursor + 1+2^levels(i);
  elseif levels(i) == 0
    cursor = cursor + 1 + 3;
  else
    error('Argument levels can not contain negative values.');
  end
end