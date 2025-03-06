function M = cwcodemat(C,lvlcount,absolution,option)
%M=cwcodemat(C,lvlcount,absolution,option) discretizes C based on matlab
%function wcodemat.
%
% Note: when option contains 'RemoveCorners', the steps are 1) replace
% corners with nan values; 2) discretize; 3) pad corners with X (X is in
% option). The steps are different from the function centropy.
%
% C: a coeffcient matrix withour nan values in corners buy may have zeros
% (or values nearly to zero) values in corners.
%
% lvlcount: an integer specifying the discretized number of levels.
%
% absolution: 1 or 0 to specify absoluteization of C or not.
%
% option: 'RemoveCorners' | 'None' | 'RemoveCorners|X', if 'RemoveCorners'
% is specified, then the zero values in corners are replaced by nan values.
% 'X' can be 'nan' or a scalar value.
%
% M: the discretized coefficient matrix of C.

if contains(option, 'None')
  M = wcodemat(C,lvlcount,'mat',absolution);
elseif contains(option,'RemoveCorners')
  indices = zerocorners(C);
  C(indices) = nan; 
  if absolution, C= abs(C); end
  M = mat2lvl(C,[min(C(:)) max(C(:))], lvlcount);
  strs = strsplit(option,'|');
  val = str2double(strs{end});
  if ~isnan(val), M(indices) = val; end
else
  error(['Invlid option! The option must be ''RemoveCorners'' | ' ...
    ' ''None'' | ''RemoveCorners|X''']);
end