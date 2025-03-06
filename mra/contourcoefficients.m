function COEFFs = contourcoefficients(ROIs,levels,divisor,minsi,pfilter,dfilter,interpolation,datatype,limits,pmode)
%COEFFs=contourcoefficients(ROIs,levels,divisor,minsi,pfilter,dfilter,interpolation,datatype,limits,pmode) computes contourlet
%coefficient matrices.
%
% Note: contourlet transform only supports periodic extension, so pmode is used for levels(i) = 0. levels(i)=0 means a wavelet
% decomposition.
%
% ROIs: a n*1 cell specifying n samples.
%
% levels: a row vector specifying the decomposition levels, for example levels = [2 3] means 2^2 components in the second-level
% decomposition and 2^3 components in the first-level decomposition.
%
% divisor: an integer specifying the multiple of the height and width of an ROI, the default value is 4.
%
% minsi: an integer specifying the minimum width or height of an ROI. If the width or height of an ROI < minWidth, interpolation
% will be used.
%
% pfilter: Pyramidal filter, the default value is '9-7'.
%
% dfilter: Directional filter, the default value is 'pkva6'.
%
% interpolation: 'nearest','bilinear', or 'bicubic', where 'bicubic' is the dafault value.
%
% datatype: a string (integer from [limits(1) limits(2)] or norm to [0 1]) specifying whether to round after interpolation.
%
% COEFFs: a n*m cell of coefficient matrices, where n is the sample sizeand a row vector contains m coefficient matrices for a
% sample.
%
% Note: In TMI-2020-0838, the i-th ROI (no decomposition performed) was used as COEFFs{i,1}; However, the revised function does not
% do this anymore.

%% check parameters
% default arguments
if nargin < 3, divisor = 4; end
if nargin < 4, minsi = 16; end
if nargin < 5, pfilter = '9-7'; end % Pyramidal filter
if nargin < 6, dfilter = 'pkva6'; end % Directional filter
if nargin < 7, interpolation ='linear'; end
if nargin < 8, datatype = 'integer'; end
if nargin < 9, limits = [1 256]; end
if nargin < 10, pmode = 'symh'; end

% argument datatype
if ~strcmpi(datatype,'integer') && ~strcmpi(datatype,'norm')
  error('Argument datatype must be integer or norm.');
elseif strcmpi(datatype,'norm')
  if ~isequal(limits,[0 1]), error('If argument datatype is ''norm'', then argument limits must be [0 1].'); end
else
  % argument datatype is 'integer'
end

[imgcount,x] = size(ROIs); if x~=1, error('ROIs must be n-by-1 cell.'); end % argument ROIs

if size(levels,1) > 1, error('levels must be a row vector!'); end
if length(levels) > 5, error('Does argument level need to be greater than 5?'); end

if ~strcmpi(datatype,'integer') && ~strcmpi(datatype,'norm')
  error('Parameter datatype must be integer or norm.');
elseif strcmpi(datatype,'norm')
  if ~(limits(1)==0 && limits(2)==1), error('When datatype is norm, the limits must be [0 1].'); end
end

%% check that the minimum with and heigh > minsi, perform wavelet transform
origmode = dwtmode('status','nodisplay');
dwtmode(pmode,'nodisplay');

compcount = num5components(levels);
COEFFs = cell(imgcount,compcount);
for i = 1:imgcount 
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

  % width and height are n multiples of divisor
  si = size(I);
  I = I(1:(divisor*(fix(si(1)/divisor))),1:(divisor*(fix(si(2)/divisor))));

  coeffs = cpdfbdec(I, pfilter, dfilter, levels); % contourlet decomposition
  COEFFs(i,:) = cell2cell(coeffs,levels);
end

dwtmode(origmode,'nodisplay');
end

%% len=num5components(levels) counts components for a contourlet transform based on levels.
function len= num5components(levels)
len = length(levels);
for j=1:length(levels)
  if levels(j) == 0, len = len + 3; else, len = len + 2^levels(j); end
end
end % end function num5components

%% COEFFs=cell2cell(coeffs,levels) converts an output cell of 
% 'cpdfbdec' to a matrix cell (a row cell with m components).
%
% coeffs: a cell specifying an output cell of 'cpdfbdec' function
%
% levels: a row vector inputting into 'cpdfbdec' function, levels(1) to
% levels(end) is from coarse to fine.
%
% COEFFs: a cell with m components, is from fine to coarse and including
% low-frequency components.
function COEFFs = cell2cell(coeffs,levels)
coeffs(:,1) = [];
if length(coeffs) ~= 2*length(levels), error('''coeffs'' is not a valid cell of contourlet transform.'); end
k=0;
COEFFs = cell(1,num5components(levels));
levels = flip(levels);
coeffs = flip(coeffs);
for i=1:length(levels)
  if ~iscell(coeffs{i*2-1}), error('The (i*2-1)-th element of coeffs must be a cell.'); end
  if ~ismatrix(coeffs{i*2}), error('The (i*2)-th element of coeffs must be a matrix.'); end

  k=k+1;
  COEFFs{k} = coeffs{i*2};
  COEFFs(k+1:k+length(coeffs{i*2-1})) = coeffs{i*2-1};
  k = k+length(coeffs{i*2-1});
end

% discarded
% CS(:,1) = [];
% C = cell(1,nComponents);
% k = 0;
% for i=1:length(CS)
%   if iscell(CS{i})
%     C(k+1:k+length(CS{i})) = CS{i};
%     k = k+length(CS{i});
%   else
%     C{k+1} = CS{i};
%     k = k + 1;
%   end
% end
end % end function cell2cell(coeffs,levels)