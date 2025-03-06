%%%%%%%%%%%%%%%%%%%%%%%%%%% PC (pancreatic cancer) vs NP (normal/healthy Pancreas) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%% ROIs: 1->153 of PC; 154->312 of NP                  £©  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Indices of ROIs are not the orders of the file names, they depends on dir(strcat(path,'*.bmp')) function.

%% read ROIs and divide dataset (execute only once)
% path1='P\';path2='N\';
% imgpathArray1 = dir(strcat(path1,'*.bmp'));
% imgpathArray2 = dir(strcat(path2,'*.bmp'));
% len1=length(imgpathArray1);
% len2=length(imgpathArray2);
% ROIsPC=cell(len1,1); % PC, positive class
% ROIsNP=cell(len2,1); % NP/HP, negative class
% for j = 1:(len1+len2)
%   if j<=len1
%     imgName = imgpathArray1(j).name;
%     ROIsPC{j} = rgb2gray(imread(strcat(path1,imgName))); 
%   else
%     imgName = imgpathArray2(j-len1).name;
%     ROIsNP{j-len1} = rgb2gray(imread(strcat(path2,imgName))); 
%   end       
% end
% ROIs = [ROIsPC;ROIsNP];
% 
% li.labels = target(1,len1,len2)'; li.rate = 0.7; % labels and indices
% [li.trainingIndices, li.testIndices,li.labelsTraining,li.labelsTest]=divideDataset(li.labels,li.rate);
% 
% clear path1 path2 len1 len2 j imgName
% save read_rois
% save base.mat ROIs li

%% wavelet transform
% dwtmode('zpd');
% parameter.waveletName='db3';
% parameter.interpolation='bicubic'; % default is bicubic (this study used default), we tried others
% parameter.minWidth=16;
% parameter.decompositionLevel=2;
% Coeffs = waveletCoefficients(ROIs,parameter.waveletName,parameter.decompositionLevel,parameter.interpolation,parameter.minWidth);

%% wavelet package transform
% parameter.waveletName='bior5.5'; % db2 is also good 
% parameter.interpolation='bicubic'; % nearest bilinear default is bicubic (this study used default)
% parameter.minWidth=16;
% parameter.decompositionLevel=2;
% Coeffs = waveletPacketCoefficients(ROIs,parameter.waveletName,parameter.decompositionLevel,parameter.interpolation,parameter.minWidth);

%% contourlet transform
% parameter.pfilter = '9-7'; parameter.dfilter = 'pkva6'; parameter.nLevels = [2 3];
% parameter.interpolation='bicubic'; % default is bicubic (this study used default)
% parameter.minWidth=16;
% Coeffs = contourletCoefficients(ROIs,parameter.nLevels ,parameter.pfilter,parameter.dfilter,parameter.interpolation,parameter.minWidth);

%% feature selection
% method 1:
% % parameter.subset = mySubset(Training(li.labelsTraining==1,:),Training(li.labelsTraining==2,:));

% method 2:
% % alpha = 0.5;    % default, it should be cross-validated.
% % sup = 1;        % Supervised or Not
% % [parameter.ranking, ~] = infFS( Training , li.labelsTraining, alpha , sup , 0 ); 
% % clear alpha sup;

% method 3:
% % parameter.ranking = mRMR(Training, li.labelsTraining, size(Training,2)); 

% method 4:
% % [parameter.ranking, ~] = reliefF( Training, li.labelsTraining, 15);

% method 5:
% % [parameter.ranking,~] = mutInfFS( Training, li.labelsTraining, size(Training,2) );

% method 6:
% % [parameter.ranking , ~] = fsvFS( Training, li.labelsTraining, size(Training,2) );

% method 7:
% % parameter.ranking = spider_wrapper(Training,li.labelsTraining,size(Training,2),lower('fisher'));

% method 8:
% parameter.tt=3; % as small as possible; the smaller, the more accurate
% [parameter.ranking,~] = ILFS(Training, li.labelsTraining, parameter.tt, 0 );

% parameter.nf=20; % limited to 20, 1/15 of the sample size (312); the smaller, the less overfitting
% parameter.subset = parameter.ranking(1:parameter.nf); % feature selection
% Trainingl=[Training(:,parameter.ranking(1:20)) li.labelsTraining];

%% parameter optimization and classification
% 1. load the features of a texture analysis method

% 2. be sure no nan values included
% [~,parameter.nanCols]=find(isnan(Features));
% if ~isempty(parameter.nanCols)
%   Features(:,unique(parameter.nanCols))=[];
% end

% 3. use the same division to obtain a training set and a test set
% Training = Features(li.trainingIndices,:);
% Test = Features(li.testIndices,:);
 
% 4. feature selection
% parameter.tt=3; % as small as possible; the smaller, the more accurate
% [parameter.ranking,~] = ILFS(Training, li.labelsTraining, parameter.tt, 0 );

% 5. parameter optimization
% clc;
% Tr = cell(20,1);
% for i=3:20  
%   Tr{i} = Training(:,parameter.ranking(1:i));
% end
% parfor (i=3:20,18) % or just use for  
%   rng('default'); % if for is used, rng('default') is not needed
%   optimizeParameters(Tr{i},li.labelsTraining, 1:1:20,1:1:20,0.7,0.7,0.7,0.7);
% end
% clear i Tr

% 6. train, validate, and test
% parameter.nf=20; % limited to 20, 1/15 of the sample size (312); the smaller, the less overfitting
% parameter.subset = parameter.ranking(1:parameter.nf); 
% Trainingl=[Training(:,parameter.subset) li.labelsTraining];
% parameter.method='SVM-linear'; 
% parameter.ks=1;
% parameter.bc=1;

% if feature number is <= 20, just use Traning and Test instead of Training(:,parameter.subset) and Test(:,parameter.subset)
%parameter.subset = 1:size(Features,2);
% [trainedClassifier, validationResult, pfs] = trainClassifier(Training,li.labelsTraining,parameter.ks,parameter.bc);
[trainedClassifier, validationResult, pfs] = trainClassifier(Training(:,parameter.subset),li.labelsTraining,parameter.ks,parameter.bc);
% disp([num2str(validationResult.accuracy) '...' num2str(validationResult.auc) '...' num2str(validationResult.sensitivity) '...' num2str(validationResult.specificity)]);
% [testClasses,testScores]=trainedClassifier.predictFcn(Test(:,parameter.subset));testResult = performance(li.labelsTest,testClasses,testScores);
% disp([num2str(testResult.accuracy) '...' num2str(testResult.auc) '...' num2str(testResult.sensitivity) '...' num2str(testResult.specificity)]);
% clear testClasses testScores

%% traditional methods: gls -> gray-level statistics (no scaling)
% load base;
% Features = zeros(length(ROIs),3);
% for i=1:length(ROIs)   
%    Features(i,:)=extractFosFeatures(double(ROIs{i}));
% end
% clear i j

%% traditional methods: glh -> histogram (scale to [1 16])
% load base;
% parameter.n=16;
% Features = zeros(length(ROIs),7);
% for i=1:length(ROIs)
%   Features(i,:)=extractHistogramFeatures(ROIs{i},parameter.n,[0 255]);  
% end
% clear i

%% traditional methods: glcm -> gray-level co-occurrence matrix (scale to [1 16], average 4 directions,£¬extract 5 features from a COM)
% load base;
% parameter.n=16;
% Features = zeros(length(ROIs),10);
% for i=1:length(ROIs)
%   Features(i,:)=extractGlcmFeatures(ROIs{i},parameter.n,2,1,[0 255]); % extractGlcmFeatures(I,n,d,directionTag,gl) 
% end
% clear i

%% traditional methods: glrlm -> gray-level run-length matrix (scale to [1 16], average 4 directions)
% load base;
% warning('off');
% parameter.n=16;
% Features = zeros(length(ROIs),11);
% for i=1:length(ROIs)
%   Features(i,:)=extractGlrlmFeatures(ROIs{i},parameter.n,1,[0 255]);  
% end
% clear i

%% traditional methods: gl-m -> merge gls, glh, glcm, glrlm
% load t-gls;
% FeaturesM = Features;
% save t-gl-m FeaturesM
% clear; clc;
% 
% load t-glh; load t-gl-m;
% FeaturesM = [FeaturesM Features];
% save t-gl-m FeaturesM;
% clear; clc;
% 
% load t-glcm; load t-gl-m;
% FeaturesM = [FeaturesM Features];
% save t-gl-m FeaturesM;
% clear; clc;
% 
% load t-glrlm; load t-gl-m;
% FeaturesM = [FeaturesM Features];
% save t-gl-m FeaturesM;
% clear; clc;
% 
% load t-gl-m;
% load base;
% Features = FeaturesM;
% clear FeaturesM;

%% traditional methods: acm -> angle co-occurrence matrix (include direction and magnitude, scale to [1 16], average 4 directions, extract 21 features from a COM)
% load base;
% parameter.n = 16; parameter.d = 2;
% ROIsM = cell(size(ROIs,1),parameter.d);
% ROIsD = cell(size(ROIs,1),parameter.d);
% FeaturesM = zeros(size(ROIs,1),42);
% FeaturesD = zeros(size(ROIs,1),42);
% 
% for i=1:size(FROIs,1)  
%   [Gmag,Gdir] = imgradient(double(FROIs{i}),'Sobel');  
%   Gdir = convertGrayscale(Gdir,[-180,180],parameter.n);
%   for j=1:parameter.d
%     [ROIsD{i,j}, ROIsM{i,j}]=acm(Gdir,Gmag,parameter.n,j);
%   end
% end
%  
% for i=1:size(FROIs,1) % wcodemat(X,NBCODES,'mat',1).
%   for j=1:parameter.d
%     [f1, f2] = extractGlcm21AcmFeatures(FROIsD{i,j},FROIsM{i,j},1);
%     FeaturesD(i,(21*j-20):(21*j)) = f1;
%     FeaturesM(i,(21*j-20):(21*j)) = f2;
%   end 
% end
% clear i
% Features = [FeaturesM FeaturesD]; % Features = FeaturesM;  Features= FeaturesD;

%% traditional methods: log -> Laplacian of Gaussian + histogram (include original ROIs to make it the same as related references, scale to [1 16])
% masks =cell(1,5);
% for i=1:5
%   masks{i} = fspecial('log',[5 5],i*0.5);
% end
% Coeffs = cell(size(Coeffs,1),6);
% for i=1:size(ROIs,1)
%   Coeffs{i,1}=ROIs{i};
%   for j=1:5
%     Coeffs{i,j+1} = imfilter(ROIs{i},masks{j});
%   end
% end
% clear i j masks
% 
% Features = zeros(size(Coeffs,1),size(Coeffs,2)*7);
% parameter.ns=[16 16 16 16 16 16];
% for i=1:size(Coeffs,1)
%   for j=1:size(Coeffs,2)
%     Features(i,(7*j-6):(7*j)) = extractHistogramFeatures(Coeffs{i,j},parameter.ns(j),[0 255]);
%   end
% end
% clear i j 

%% traditional methods: wt (wavelet transform, no scale)
% Coeffs(:,1)=[]; % original image must be ignored
% Features = zeros(size(Coeffs,1),3*size(Coeffs,2));
% for i=1:size(Coeffs,1)
%   for j=1:size(Coeffs,2)
%     Features(i,(3*j-2):(3*j)) = extractFosFeatures(Coeffs{i,j});
%   end
% end
% clear i j f

%% traditional methods: wpt (wavelet package transform, no scale)
% Coeffs(:,1)=[]; % original image must be ignored
% Features = zeros(size(Coeffs,1),3*size(Coeffs,2));
% for i=1:size(Coeffs,1)
%   for j=1:size(Coeffs,2)
%     Features(i,(3*j-2):(3*j)) = extractFosFeatures(Coeffs{i,j});
%   end
% end
% clear i j f

%% traditional methods: ct (contourlet transform, no scale)
% Coeffs(:,1)=[]; % original image must be ignored
% Features = zeros(size(Coeffs,1),3*size(Coeffs,2));
% for i=1:size(Coeffs,1)
%   for j=1:size(Coeffs,2)
%     Features(i,(3*j-2):(3*j)) = extractFosFeatures(Coeffs{i,j});
%   end
% end
% clear i j f

%% CMS-W (coefficient matrix scaling (wavelet transform) + coefficient statistics/histogram/co-occurrence matrix/run-length matrix, scale to [1 16])
% parameter.ns = 16*ones(1,size(Coeffs,2)); 
% Features = extractMraSiFeatures(Coeffs,parameter.ns,1); % scaling based on the minimum and maximum of the component itself
% FeaturesOriginal = Features;

% obtain coefficient statistics/histogram/co-occurrence matrix/run-length matrix features, respectively
% f=[]; 
% for j=1:size(Coeffs,2)
%   f=[f (j*31-30):(j*31-28)]; 
% end
% clear j 
% Features=FeaturesOriginal(:,f);

%% MSTA-W (multiresolution-statistical analysis (wavelet transform) + coefficient statistics/histogram/co-occurrence matrix/run-length matrix, scale to [1 16])
% parameter = setWamamParameter(Coeffs(li.trainingIndices,:),li.labelsTraining); 
% Features = extractMraFeatures(Coeffs,parameter);
% FeaturesOriginal = Features;

% obtain coefficient statistics/histogram/co-occurrence matrix/run-length matrix features, respectively
% f=[];
% for j=1:size(Coeffs,2)
%   f=[f (j*31-10):(j*31)];
% end
% clear j
% Features=FeaturesOriginal(:,f);

%% CMS-WP (coefficient matrix scaling (wavelet package transform) + coefficient statistics/histogram/co-occurrence matrix/run-length matrix, scale to [1 24])
% parameter.ns = 24*ones(1,size(Coeffs,2)); % parameter.ns([1 2 6])=256;
% Features = extractMraSiFeatures(Coeffs,parameter.ns,1); % use wcodemat
% FeaturesOriginal = Features;
% 
% f=[];
% for j=1:size(Coeffs,2)
%   f=[f (j*31-10):(j*31)];
% end
% clear j
% Features=FeaturesOriginal(:,f);
 
%% MSTA-WP (multiresolution-statistical analysis (wavelet package transform) + coefficient statistics/histogram/co-occurrence matrix/run-length matrix, scale to [1 16])
% parameter = setWpamamParameter(Coeffs(li.trainingIndices,:),li.labelsTraining); 
% Features = extractMraFeatures(Coeffs,parameter);
% FeaturesOriginal = Features;
% 
% f=[]; % 3+7+10+11
% for j=1:size(Coeffs,2)
%   f=[f (j*31-10):(j*31)];
% end
% clear j
% Features=FeaturesOriginal(:,f);
 
% [~,parameter.nanCols]=find(isnan(Features));
% if ~isempty(parameter.nanCols)
%   Features(:,unique(parameter.nanCols))=[];
% end
% Training = Features(li.trainingIndices,:);
% Test = Features(li.testIndices,:);
% %  
% parameter.tt=3;
% [parameter.ranking,~] = ILFS(Training, li.labelsTraining, parameter.tt, 0 );
% parameter.nf=14; 
% parameter.waveletName='bior5.5';
% parameter.subset = parameter.ranking(1:parameter.nf);
% Trainingl=[Training(:,parameter.subset) li.labelsTraining];
% parameter.ks=1;parameter.bc=0.1;  parameter.method='SVM-linear';
% [trainedClassifier, validationResult] = trainClassifier(Training(:,parameter.subset),li.labelsTraining,parameter.ks,parameter.bc);
% disp([num2str(validationResult.accuracy) '...' num2str(validationResult.auc) '...' num2str(validationResult.sensitivity) '...' num2str(validationResult.specificity)]);
% [testClasses,testScores]=trainedClassifier.predictFcn(Test(:,parameter.subset));testResult = performance(li.labelsTest,testClasses,testScores);
% disp([num2str(testResult.accuracy) '...' num2str(testResult.auc) '...' num2str(testResult.sensitivity) '...' num2str(testResult.specificity)]);
% clear testClasses testScores

%% CMS-C (coefficient matrix scaling (contourlet transform) + coefficient statistics/histogram/co-occurrence matrix/run-length matrix, scale to [1 32])
% parameter.ns = 32*ones(1,size(Coeffs,2)); 
% Features = extractMraSiFeatures(Coeffs,parameter.ns,1); % use wcodemat
% FeaturesOriginal = Features;

% f=[];
% for j=1:size(Coeffs,2)
%   f=[f (j*31-10):(j*31-)];
% end
% clear j
% Features=FeaturesOriginal(:,f);

%% MSTA-C (multiresolution-statistical analysis (contourlet transform) + coefficient statistics/histogram/co-occurrence matrix/run-length matrix, scale to [1 8])
% parameter = setCamamParameter(Coeffs(li.trainingIndices,:),li.labelsTraining); 
% Features = extractMraFeatures(Coeffs,parameter);
% FeaturesOriginal = Features;

% f=[]; % 3+7+10+11
% for j=1:size(Coeffs,2)
%   f=[f (j*31-10):(j*31)];
% end
% clear j
% Features=FeaturesOriginal(:,f);

%% show multiresolutin analysis
% dwtmode('zpd'); 
% [C,S]=wavedec2(A,2,'db3'); % matrix A is an ROI
% wavedisplay(C,S,1,'absorb');
 
% Wds = exampleWd(Coeffs,parameter)
% for j=1:9
%   % subtitle(['Number ' numtstr(j-1)]);
%   subplot(2,6,j+3),imshow(Wds{j}*16,'display',[1 256]),title(['Number ' num2str(j-1)]);  
% end
% clear j
