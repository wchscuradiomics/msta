function F = extractMraFeatures(COEFFs,parameter)
%Compute MRA features of n samples. The j-th coefficient matrix of an ROI is discretized into
%parameter.sequences{j} (a row vector) basing parameter.starts(j) and parameter.steps(j).
%
% COEFFs: a n*m cell, where m is the number of components for an ROI.
%
% parameter.grayscales is a 1*m vector representing grayscales, where parameter.grayscales(j) = x
% means the grayscale of the j-th component is [1,x].
%
% parameter.starts is a 1*m vector representing start points, where parameter.starts(j) corresponds
% to the j-th component.
%
% parameter.steps is a 1*m vector representing steps of the start points, where parameter.steps(j)
% corresponds to the j-th component.
%
% parameter.sequences is a 1*m cell representing the discretized values of discretized components,
%
% parameter.sequences{j} = [1,8,16] means the discretized values of the j-th component (a
% subinterval of [1 n{j}]) can only be 1, 8, or 16.
%
% As for a coefficient matrix belongs to the j-th component, this algorithm first discretes the
% coefficient matrix, sequences{j} specifies the discreted values (it is a subinterval of [1
% parameters.grayscales(j)]), then calculates texture features of this  discreted coefficient matrix
% (equally, the grayscale of the subimage is [1 parameters.grayscales(j)]).
%
% F: a n*f matrix representing the features of COEFFS, there are f features extracted from
% COEFFs(i,:). 
%
% Note: starts of approximations cannot be zeros and must be calculated on mins of the
% approximation self or average minis of approximations.

[nSamples,nComponents] = size(COEFFs);
if nargin == 1
  isAbs = 1;
	steps = ones(1,nComponents); % the default value of step is set to 1 
  starts = zeros(1,nComponents); % usually mini is fixed at 0, starts is a vector representing start points	
	grayscales = repmat(16,[1 nComponents]); % grayscales is a vector representing the grayscales (the j-th element represents the nLevels of the j-th component).
  sequences = cell(1,nComponents); sequences(:)={1:16};  
else
  isAbs=parameter.isAbs;
	steps = parameter.steps;
	starts = parameter.starts;
	grayscales = parameter.grayscales;
  sequences = parameter.sequences;
end

edges = cell(1,nComponents); % edges is a 1*m cell, where edges{j} is a vector representing the edges of the j-th component
for j=1:nComponents
	edges{j} = divideBins(starts(j),starts(j)+steps(j)*length(sequences{j}),length(sequences{j}));
end

warning('off');
for i=1:nSamples
  for j=1:nComponents    
    if isAbs
      C = abs(COEFFs{i,j});
    else
      C = COEFFs{i,j};
    end  
    f0 = extractSubbandRawsFeatures(C);
    f1 = extractSubbandHistogramFeatures(C,edges{j},sequences{j},grayscales(j)); 
    f2 = extractSubbandGlcmFeatures(C,edges{j},sequences{j},grayscales(j),2); % d=2,10 features, average for 4 directions
    f3 = extractSubbandGlrlmFeatures(C,edges{j},sequences{j},grayscales(j)); % 11 features, average for 4 directions
    if i==1 && j == 1
      nf = length(f0)+length(f1)+length(f2)+length(f3); % the number of the features for a component
      F = zeros(nSamples,nf*nComponents);
    end
    F(i,(nf*j-nf+1):(nf*j)) = [f0 f1 f2 f3];      
  end
end