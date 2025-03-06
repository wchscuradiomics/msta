function parameter = setCamamParameter(Coeffs,labels)
%Set parameter for function extractMraFeatures based on wavelet package + amam

if size(Coeffs,1) ~= size(labels,1)
  error('Numbers of rows for Coeffs and labels must be same.');
end
nComponents = size(Coeffs,2);
CoeffsP = Coeffs(labels==1,:);
CoeffsN = Coeffs(labels==2,:);

parameter.a=1;parameter.na=256; % basic information

[Boundaries,PBoundaries,NBoundaries] = boundaries2(CoeffsP,CoeffsN,parameter.a); % calculate boundaries

parameter.starts=  Boundaries(1,:);

%%%%%%%%%%%%%%%%% different methods for setting %%%%%%%%%%%%%%%%%%%%%%%%%%
%% method 1, first fix the grayscales of subimages
% parameter.nd = 16;
% parameter.ns = parameter.nd * ones(1, nComponents); 
% parameter.ns([1,2,6]) = parameter.na;
% parameter.ns = round((Boundaries(2,:)-Boundaries(1,:))*0.5);
% parameter.ns([1 2 6])=255;
parameter.ns = 8*ones(1,nComponents); % 12
% parameter.ns(1)=256;
parameter.sequences = cell(1,nComponents);
% parameter.sequences(:)={1:parameter.nd};
% parameter.sequences([1,2,6])={1:parameter.na};
for j=1:nComponents
  parameter.sequences{j} = 1:parameter.ns(j);
end
parameter.steps = (Boundaries(2,:)-Boundaries(1,:))./parameter.ns;

%% method 2, first set the du
% parameter.du=0.5;
% % parameter.ns = round((Boundaries(2,:)-Boundaries(1,:))./parameter.du);
% % parameter.ns([1,2,6])=parameter.na; 
% parameter.ns = 256*ones(1,nComponents);
% parameter.sequences = cell(1,nComponents); 
% for j=1:nComponents
%   parameter.sequences{j} = 1:(parameter.ns(j));
% end
% parameter.steps=parameter.du * ones(1,nComponents);