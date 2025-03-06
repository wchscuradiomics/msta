function COEFFs = wavecoefficients(ROIs,wavename,level,interpolation,minsi,datatype,limits,extmode)
%COEFFs=wavecoefficients(ROIs,wavename,level,interpolation,minsi,datatype,limits,extmode) calculates wavelet coeffient matrices.
%
% ROIs: a n*1 cell, where ROIS{i} is a matrix representing the i-th ROI.
%
% level: an integer specifying the decomposition level of wavelet transform.
%
% interpolation: a char vector, its value can be 'nearest','bilinear', or 'bicubic', 'bicubic' is the dafault value.
%
% minsi: an integer specifying the minimum width/height of an ROI.
%
% datatype: a string (integer from [limits(1) limits(2)] or norm to [0 1]) specifying whether to round after interpolation.
%
% COEFFs: a n*m cell, m is the number of compoments for an ROI. COEFFs{i,1} is approximations of ROIS{i}.
%
% Note: In TMI-2020-0838, the i-th ROI (no decomposition performed) was used as COEFFs{i,1}; However, the revised function does not
% do this anymore.

%% check parameters
% default arguments
if nargin < 3, interpolation='linear'; end
if nargin < 4, minsi = 16; end
if nargin < 5, datatype = 'integer'; end
if nargin < 6, limits = [1 256]; end
if nargin < 7, extmode = 'symh'; end

% argument datatype
if ~strcmpi(datatype,'integer') && ~strcmpi(datatype,'norm')
  error('Argument datatype must be integer or norm.');
elseif strcmpi(datatype,'norm')
  if ~isequal(limits,[0 1]), error('If argument datatype is ''norm'', then argument limits must be [0 1].'); end
else
  % argument datatype is 'integer'
end

[imgcount,x] = size(ROIs); if x~=1, error('ROIs must be n-by-1 cell.'); end % argument ROIs

if level > 5, error('Does argument level need to be greater than 5?'); end

%% check that the minimum with and heigh > minsi, perform wavelet transform
origmode = dwtmode('status','nodisplay');
dwtmode(extmode,'nodisplay');

COEFFs = cell(imgcount,level*4);
for i = 1:imgcount % for each ROI
  I = ROIs{i};

  % check that the minimum with and heigh > minsi
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
  
  if strcmpi(datatype,'integer'), I = double(I-limits(1)); end % unify lower limit to 0
    
  if contains(wavename,'coif','IgnoreCase',true) 
    [LoD,HiD,~,~] = wfilters(wavename);
    [C,S] = wavedec2(I,level,LoD,HiD);
  else
    [C,S] = wavedec2(I,level, wavename);
  end 
  for k=1:level
    A = appcoef2(C,S,wavename,k);
    [H,V,D] = detcoef2('all',C,S,k);
    COEFFs(i,(4*k-3):(4*k)) = {A,H,V,D};
  end  
end % end for all ROIs

dwtmode(origmode,'nodisplay');