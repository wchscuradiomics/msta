function [f1, f2] = extractGlcm21AcmFeatures(ACM1,ACM2,averaged)
%extract texture features with GLCM.
%   max dl is 5, direction=0 45 90 135.
%   21 features are extracted
%   return a row vector

f1 = cell2mat(struct2cell(GLCMFeatures(ACM1)))';
f2 = cell2mat(struct2cell(GLCMFeatures(ACM2)))';
 

if averaged
  f1 = mean(f1);
  f2 = mean(f2);
else
  f1 = f1(:)';
  f2 = f2(:)';
end