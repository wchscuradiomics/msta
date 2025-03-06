function f=extractGlcmFeatures(I,n,d,directionTag,gl)
%Compute GLCM fetures of an image I
% gl means the grayscale of I is [gl(1) gl(2)].
% n means I is scaled into [1 n].
% directions (0, 45, 90, 135) are averaged.
% d=1,2, or 3 means the distance of GLCMs, direction=0 45 90 135, directions averaged based on directionTag.
% 5 features are extracted: contrast, correlation, energy, homogeneity, entropy.

if nargin==3
  directionTag=1;
  gl = [0 255];
elseif nargin==4
  gl= [0 255];
end

offset=zeros(4,2,5);
for i=1:5
  offset(:,:,i)=[0 1; -1 1; -1 0; -1 -1] * i;
end

if directionTag
  f = zeros(1,5*d);
else
  f = zeros(1,5*d*4);
end

for i=1:d
  GS=graycomatrix(I,'NumLevels',n,'Offset',offset(:,:,d),'GrayLimits',gl);
  properties = zeros(4,5);
  for k=1:4
    p = cgraycoprops(GS(:,:,k),'all');
    properties(k,:) = cell2mat(struct2cell(p))';
  end  
  if directionTag
    f((i*5-4):(i*5)) = mean(properties);
  else
    f((i*20-19):(i*20)) = properties(:);
  end
end



