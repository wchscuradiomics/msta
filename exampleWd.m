function Wds = exampleWd(Coeffs,parameter)
%Compute MRA features. 
% Note: starts of approximations cannot be zeros and must be calculated on mins of the approximation self or average minis of approximations.
% Parameter.ns is the array of grayscales, ns{j} = 16 means the grayscale of the j-th component is [1,16]
% Parameter.sequences is the array of subintervals of discretized components, 
% sequences{j} = [5,10] means the discretized interval of the j-th component (a subinterval of [1 ns{j}])
% As for a coefficient matrix belongs to the j-th component, this algorithm first discretes the coefficient matrix, 
% parameter sequences{j} specifies the discreted interval (it is a subinterval of [1 ns{j}]), 
% then calculates texture features of this  discreted coefficient matrix (equally, grayscale of the subimage is [1 ns{j}]).

[nSamples,nComponents] = size(Coeffs);
if nargin == 1
  a=1;
	steps=ones(1,nComponents); % default value of step is set to 1 
  starts=zeros(1,nComponents); % usually mini is fixed at 0	
	ns = repmat(16,[1 nComponents]); 
  sequences = cell(1,nComponents); sequences(:)={1:16};  
else
  a=parameter.a;
	steps = parameter.steps;
	starts = parameter.starts;
	ns = parameter.ns;
  sequences = parameter.sequences;
end

edgesArray = cell(1,nComponents);
for j=1:nComponents
	edgesArray{j} = divideBins(starts(j),starts(j)+steps(j)*length(sequences{j}),length(sequences{j}));
end

warning('off');
Wds = cell(1,nComponents);
for i=255:255
  for j=1:nComponents    
    if a
      C = abs(Coeffs{i,j});
    else
      C = Coeffs{i,j};
    end  
    C = discretize(C,edgesArray{j},sequences{j});
    Wds{j} = C;    
  end
end