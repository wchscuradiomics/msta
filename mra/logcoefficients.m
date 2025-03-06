function COEFFs = logcoefficients(ROIs,limits,hsize,datatype,interpolation,minsi,way,option)
%COEFFs=logcoefficients(ROIs,limits,hsize,datatype,interpolation,minsi,way,option) calculates coefficients of Laplacian of Gaussian
%filtering.
%
% ROIs: a n-by-1 cell, an ROI is a matrix.
%
% limits: [limits(1) limits(2)] specifying the intensity range of argument ROIs.
%
% hsize: a 1-by-2 vector specifying filter sizes.
%
% minsi: a double scalar specifying the minimum size of all ROIs.
%
% option: 'component type|extension mode|fitting method|processing corner|padding value', e.g.,
% 'details|symmetric|cross-validation|RemoveCorners|nan'. padval can be a scalar or 'symmetric' | 'replicate' | 'circular'.
%
% COEFFs: a n-by-5 cell representing filtered subband images.
%
% If elements of an ROI are integers, the grayscale of the ROI must be [IntensityRange(1) IntensityRange(2)]. If an ROI is double
% or single, the grayscale of the ROI must be [0 1]. The default filter size is [5 5]. Five filters are used
% (sigma=0.5,1,1.5,2,2.5). Log filters usually combine histogram to extract features because filtered images contain fine or coase
% textures.
%
% Note:
% 1) The grayscale/intensity range of an ROI is [intensityRange(1) intensityRange(2)], thus, this function is different from
% functions of waveletCoefficients/... (their ROIS are not assigned grayscales);
%
% 2) However, the third-party toolboxes assigned the grayscales of ROIS, so this function achieved the function of the third-party
% toolboxes, thus, the grayscale of all the subband images is also [1 nLevels];
%
% 3) Actually, we also achived another function clogCoefficients that their ROIs are not assigned grayscales;
%
% 4) This function has not used the original image as a subband image, considering that: if histogram features are extracted from
% the original image, these features are the same as the features extracted by function extractSubbandHistogramFeatures(...). Note:
% the grayscale of the original image is [intensityRange(1) intensityRange(2)].
%
% 5) Some studies used LoG + Histogram to extract features, we need to read if a study used the original image to extract histogram
% features. This decides whether to combine the filtered subband images and the original image to extract features.
%
% 6) In general, logcoefficients is more commonly used compared to clogCoefficients. In the MSTA architecture, when LoG is used as
% a similar multi-resolution analysis method, its ability is far inferior to wavelet transform, Gabor transform, or Fourier
% transform and other time-frequency transform methods; moreover, in the CMS architecture, the features of
% clogCoefficients+wcodemat+histogram are close to the features of directly using logCoefficients+histogram. In other words, if the
% MSTA architecture is used, the multi-resolution analysis capability of clogCoefficients is insufficient, so it can be ignored; if
% the CMS architecture is used, the features obtained based on clogCoefficients are close to the features obtained based on the
% direct use of logCoefficients.

%% check parameters
% default arguments
if nargin < 3, hsize = [5 5]; end
if nargin < 4, datatype = 'integer'; end
if nargin < 5, interpolation = 'linear'; end
if nargin < 6, minsi = 16; end
if nargin < 7, way = 'ConsistentIntensities'; end
if nargin < 8, option = ['details|' num2str(limits(1)) '|cross-validation|RemoveCorners|nan']; end

% argument padval (extension mode) is a scalar or 'symmetric' | 'replicate' | 'circular'
[~,extmode,~,~,~] = mraoption(option); 
if ~isnan(str2double(extmode)) % padval is a scalar
 padval = str2double(extmode); 
elseif contains(extmode,'per')
  padval = 'circular';
end

% argument way
if isa(way,'double') && way == 1
  way = 'ConsistentIntensities';
elseif isa(way,'double') && way == 2  
  way = 'TakeNature';
elseif any(strcmpi(way,{'ConsistentIntensities','TakeNature'}))
  % Argument way is 'ConsistentIntensities' or 'TakeNature'.
else
  error('Not supported value for argument way.');
end

% argument datatype
if ~strcmpi(datatype,'integer') && ~strcmpi(datatype,'norm')
  error('Argument dataType must be integer or norm.');
elseif strcmpi(datatype,'norm')
  if ~isequal(limits,[0 1]), error('If argument datatype is ''norm'', then argument limits must be [0 1].'); end
else
  % argument datatype is 'integer'
end

[imgcount,x] = size(ROIs); if x~=1, error('ROIs must be n-by-1 cell.'); end % argument ROIs

%% check that the minimum with and heigh > minsi
for i=1:imgcount
  I = double(ROIs{i}); 
  si = size(I);
  if si(1) < minsi || si(2) < minsi % interp
    [x,y,xq,yq] = interp2xy(si(2),si(1),minsi); % x is the horizontal axis and y is the vertical axis
    I = interp2(x,y,I,xq,yq,interpolation); 
    if strcmpi(datatype,'integer')
      I = round(I);
      I(I<limits(1)) = limits(1);      
      I(I>limits(2)) = limits(2);      
    else
      I(I<limits(1)) = limits(1);
      I(I>limits(2)) = limits(2);
    end
  end    
  ROIs{i} = I;
end

MASKs = cell(1,5);
for i=1:5, MASKs{i} = fspecial('log',hsize,i*0.5); end

%% perform imfilter using conv
COEFFs = cell(imgcount,5);
if strcmpi(way,'ConsistentIntensities') % image class is integer, matlab use this way to convert filtered image to the same class
  for i=1:imgcount
    I = double(ROIs{i});
    for j=1:5
      I = imfilter(I,MASKs{j},padval,'conv'); % limits(1): boundary option
      if strcmpi('integer',datatype)        
        I = round(I);
        I(I<limits(1)) = limits(1);
        I(I>limits(2)) = limits(2);
      end
      COEFFs{i,j} = I;
    end
  end
else % do not need to keep consistence with limits (the grayscale of original ROIs)
  for i=1:imgcount
    I = double(ROIs{i});  
    for j=1:5 
      COEFFs{i,j} = imfilter(I,MASKs{j},padval,'conv');
    end
  end 
end