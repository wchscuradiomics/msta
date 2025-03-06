function f = extractGlrlmFeatures(I,n,directionTag,gl)
%Compute GLRLM fetures of an image I
% gl means the grayscale is [gl(1) gl(2)].
% n means I is scaled into [1 n].
% directions (0, 45, 90, 135) are averaged based on directionTag.

if nargin==2
  directionTag=1;
  gl = [0 255];
elseif nargin==3
  gl= [0 255];
end

GLRLMS= grayrlmatrix(I,'NumLevels',n,'GrayLimits',gl);

if directionTag
  f = mean(grayrlprops(GLRLMS,4));
else
  f = grayrlprops(GLRLMS,4);
  f = f(:)';
end
