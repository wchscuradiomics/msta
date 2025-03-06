function B = boundaries(COEFFs,absolution,option)
%B=boundaries(COEFFs,absolution,option) computes the boundaries of COEFFs.
%
% COEFFs: a n*m cell of coefficient matrices, where n is the sample size and a row vector contains m coefficient matrices for a
% sample. A COEFF is a coefficient matrix.
%
% absolution: a logical value specifying whether absolute coefficients are used.
%
% B: a 2*m matrix representing the boundaries of m components, where the j-th column represents the boundary of the j-th component.

if nargin == 2, option = 'RemoveCorners'; end

[smpcount,compcount] = size(COEFFs);
B=zeros(2,compcount);
if absolution
  for i = 1:smpcount
    for j=1:compcount
      C = COEFFs{i,j};
      if strcmpi(option,'RemoveCorners'), indices = zerocorners(C); C(indices) = []; end
      C = abs(C(:));
      B(1,j)= B(1,j) + min(C);
      B(2,j)= B(2,j) + max(C);
    end
  end
else
  for i = 1:smpcount
    for j=1:compcount
      C = COEFFs{i,j};
      if strcmpi(option,'RemoveCorners'), indices = zerocorners(C); C(indices) = []; end
      B(1,j)= B(1,j) + min(C(:));
      B(2,j)= B(2,j) + max(C(:));
    end
  end
end

B = B/smpcount;  % for each component, compute the average minimums and the average maximums