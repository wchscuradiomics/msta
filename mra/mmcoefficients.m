function [mm,mm1,mm2] = mmcoefficients(COEFF1s,COEFF2s,absolution,mvmv,optio)
%[mm,mm1,mm2] mmcoefficients(COEFF1s,COEFF2s,absolution,mvmv,option) calculates mean mins and mean maxs or minimum mins and maximum
%maxs.
%
% COEFF1s is a n1*m cell, where n1 is the number of samples (class 1) and m is the number of components.
%
% COEFF2s is a n2*m cell, where n2 is the number of samples (class 2).
%
% absolution is a boolean specifying whether the coefficient matrices will be absoluted. mvmv is a boolean that the true value
% specifying "mean mins and mean maxs" are calculated, otherwise "minimum mins and maximum maxs" are calculated.
%
% option: 'RemoveCorners' or 'none', specifying whether the corners are removed.

if nargin < 3, absolution = true; end
if nargin < 4, mvmv = true; end
if nargin < 5, option = 'RemoveCorners'; end

if absolution  
  for i=1:size(COEFF1s,1), for j=1:size(COEFF1s,2), COEFF1s{i,j} = abs(COEFF1s{i,j}); end, end  
  for i=1:size(COEFF2s,1), for j=1:size(COEFF2s,2), COEFF2s{i,j} = abs(COEFF2s{i,j}); end, end  
end

if mvmv
  [mm,mm1,mm2] = boundaries2(COEFF1s,COEFF2s,absolution,option);  
else
  mm1 = zeros(2,size(COEFF1s,2));
  mm1(1,:) = Inf; % the minimum
  mm1(2,:) = -Inf; % the maximum
  for i=1:length(COEFF1s)
    for j=1:size(COEFF1s,2)
      C1 = COEFF1s;
      if strcmpi(option,'RemoveCorners'), indices = zerocorners(C1); C1(indices) = []; else, C1 = C1(:); end     
      mini = min(C1);
      maxi = max(C1);
      if mini < mm1(1,j), mm1(1,j) = mini; end
      if maxi > mm1(2,j), mm1(2,j) = maxi; end
    end
  end
  
  mm2 = zeros(2,size(COEFF2s,2));
  mm2(1,:) = Inf; % the minimum
  mm2(2,:) = -Inf; % the maximum
  for i=1:length(COEFF2s)
    for j=1:size(COEFF2s,2)
      C2 = COEFF2s;
      if strcmpi(option,'RemoveCorners'), indices = zerocorners(C2); C2(indices) = []; else, C2 = C2(:); end
      mini = min(C2);
      maxi = max(C2);
      if mini < mm2(1,j), mm2(1,j) = mini; end
      if maxi > mm2(2,j), mm2(2,j) = maxi; end
    end
  end
  
  mm = zeros(size(mm1));
  mm(1,:) = min([mm1(1,:); mm2(1,:)]);
  mm(2,:) = max([mm1(2,:); mm2(2,:)]);
end