function [comptype,extmode,fitmethod,corner,padval] = mraoption(option,name)
%[comptype,extmode,fitmethod,corner,padval]=mraoption(option,name) parses option of multi-resolution analysis.
%
% option: 'comptype|extmode|fitmethod|corner|padval'
%
% name: a char vector, 'comptype'|'extmode'|'fitmethod'|'corner'|'padval'

strs = strsplit(option,'|');
if length(strs) ~= 5, error(['There must be 5 values in ' option]); end

if nargin == 2
  name = lower(name);
  extmode = [];
  fitmethod = [];
  corner = [];
  padval = [];
  switch name
    case {'comptype', 'componenttype'}
      comptype = strs{1};
    case {'extensionmode','extmode'}
      comptype = strs{2};
    case {'fitnessmethod','fitmethod'}
      comptype = strs{3};
    case 'corner'
      comptype = strs{4};
    case 'padval'
      comptype = strs{5};
  end
else
  comptype = strs{1};
  extmode = strs{2};
  fitmethod = strs{3};
  corner = strs{4};
  padval = strs{5};
end