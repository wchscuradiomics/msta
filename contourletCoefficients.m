function Coeffs = contourletCoefficients(ROIs,nLevels,pfilter,dfilter,interpolation,minWidth)
%Compute contourlet coefficient matrices
% interpolation is 'nearest','bilinear', or 'bicubic'. 'bicubic' is the dafault value.
% Coeffs{i,1} is the original image of ROIs{i}. nlevels = [2,3].

if nargin==4  
  minWidth = 16;
  interpolation = 'bicubic'; % 'nearest','bilinear', or 'bicubic' (default)
elseif nargin==5
  minWidth=16;
end

nLevels = uint8(nLevels);
if size(nLevels,1) > 1
  error('nLevels must be a row vector');
end

if length(nLevels)>4
  error('Decomposition greater than 3 layers is currently not supported.');
end

n=2.^nLevels;
n(n==1)=3;
nComponents = sum(n)+2;
nImgs = length(ROIs);

% pfilter = '9-7'; % Pyramidal filter
% dfilter = 'pkva6'; % Directional filter
Coeffs = cell(nImgs,nComponents);

for i = 1:nImgs
  d = 4;
  im = double(ROIs{i});
  si=size(im); 
  if si(1) < minWidth && si(2) < minWidth % pad im to ensure the number of rows is least to minWidth
    im=imresize(im,[minWidth minWidth],interpolation); 
  elseif si(1) < minWidth && si(2) >= minWidth
    im=imresize(im,[minWidth si(2)],interpolation);
  elseif si(1) >= minWidth && si(2) < minWidth
    im=imresize(im,[si(1) minWidth],interpolation);
  end 
  si=size(im); im = im(1:(d*(fix(si(1)/d))),1:(d*(fix(si(2)/d))));
  
  Cs = pdfbdec(im, pfilter, dfilter, nLevels );% Contourlet decomposition
  Coeffs{i,1} = im;
  temp = [];
  for j=1:length(Cs)
    temp = [temp Cs{j}];
  end
  Coeffs(i,2:end) = temp; 
end
