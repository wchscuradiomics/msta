function F = extractMraSiFeatures(COEFFs,grayscales,isAbs,gl)
%Extract features of subimages from n samples. Subimages are obtained by the function wcodemat. Si
%menas subimages.
%
% COEFFs: a n*m cell, where m is the number of components for an ROI.
%
% grayscales: a 1*m vector representing the scaled nLevels, of which an element corresponds to a
% component.
%
% gl: a 1*2 vector representing the gray limits used for scaling the original image, the default
% value is [0 255].

[nSamples,nComponents] = size(COEFFs);
if nargin==1
  isAbs=1;
  grayscales=256*ones(1,nComponents);
  gl = [0 255];
elseif nargin == 2
  isAbs=1;
  gl = [0 255];
elseif nargin == 3
  gl = [0 255];
end

warning('off');
for i=1:nSamples
  for j=1:nComponents
    if j==1 % the first component is the image itself
      C = convertGrayscale(COEFFs{i,j},gl,grayscales(1));
    else % other components are scaled based on the min and max values of the coefficient matrix itself
      C = wcodemat(COEFFs{i,j},grayscales(j),'mat',isAbs);
    end
    f0 = extractSubbandRawsFeatures(C);
    f1 = extractSubbandHistogramFeatures(C,[],[],grayscales(j)); 
    f2 = extractSubbandGlcmFeatures(C,[],[],grayscales(j),2); 
    f3 = extractSubbandGlrlmFeatures(C,[],[],grayscales(j));
    if i==1 && j == 1
      nf = length(f0)+length(f1)+length(f2)+length(f3); % the number of the features for a component
      F = zeros(nSamples,nf*nComponents);
    end
    F(i,(nf*j-nf+1):(nf*j)) = [f0 f1 f2 f3];
  end
end
