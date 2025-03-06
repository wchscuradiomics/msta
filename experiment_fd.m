%% wavelet-amam (averaged minimums and averaged maximums)
% M = fracmask(0.35,0,5);
directions = [0 45 90 135 180 225 270 315];
M = fracmask(0.335,0);

% I1 = FROIsPC{2}; I2 = FROIsNP{2};
% EI1 = enhance(I1,M);
% EI2 = imfilter(double(I2),M,'conv','symmetric','same');
% subplot(2,2,1), imshow(I1,[0 255]);
% subplot(2,2,2), imshow(EI1,[]);
% subplot(2,2,3), imshow(I2,[0 255]);
% subplot(2,2,4), imshow(EI2,[]);
% clear I1 I2 EI1 EI2

parameter.waveletName='db3';
parameter.interpolation='bicubic'; % nearest nearest default is bicubic (this study used default), we tried other nearest and nearest
parameter.minWidth=16;
parameter.decompositionLevel=2;

EROIs = [FROIsPC;FROIsNP];
% EROIs = enhanceROIs([FROIsPC;FROIsNP],M);
% EROIs = enhanceROIs(EROIs,M);
% EROIs = enhanceROIs(EROIs,M);
% EROIs = enhanceROIs(EROIs,M);
Coeffs = waveletCoefficients(EROIs,parameter.waveletName,parameter.decompositionLevel,parameter.interpolation,parameter.minWidth);

ECoeffs = enhanceCoeffs(Coeffs,M); % 0.335 0.34
% ECoeffs = enhanceCoeffs(ECoeffs,M);
% ECoeffs = enhanceCoeffs(ECoeffs,M);

Features = extractMraFeatures(ECoeffs,setWamamParameter(ECoeffs(li.trainingIndices,:),li.labelsTraining));


FeaturesOriginal = Features;

% f=[];
% for j=1:size(Coeffs,2)
%   f=[f (j*31-10):(j*31)];
% end
% clear j
% Features=FeaturesOriginal(:,f); % Features = FeaturesOriginal;

[~,parameter.nanCols]=find(isnan(Features));
if ~isempty(parameter.nanCols)
  Features(:,unique(parameter.nanCols))=[];
end
Training = Features(li.trainingIndices,:);
Test = Features(li.testIndices,:);

% %%%%%%%%%%%%%%%%%%%%%%%%%%% feature selection and classification %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% parameter.subset = mySubset(Training(li.labelsTraining==1,:),Training(li.labelsTraining==2,:));
% Training = Training(:,parameter.subset);
% Test = Test(:,parameter.subset);

parameter.tt=3;
[parameter.ranking,~] = ILFS(Training, li.labelsTraining, parameter.tt, 0 );
parameter.nf=20;
parameter.subset = parameter.ranking(1:parameter.nf); % feature selection

% bm = labels2BinaryMatrix(li.labels);
% FeaturesANN = Features(:,parameter.subset);
Trainingl=[Training(:,parameter.subset) li.labelsTraining]; 
parameter.ks=1.1;parameter.bc=1;parameter.method = 'SVM-rbf';
[trainedModel, validationResult] = trainClassifier(Training(:,parameter.subset),li.labelsTraining,parameter.ks,parameter.bc);validationResult
[testClasses,testScores]=trainedModel.predictFcn(Test(:,parameter.subset));testResult = performance(li.labelsTest,testClasses,testScores)
clear testClasses testScores nComponents
% 
% clc;acc=0;auc=0;
% for i=3:20
%   for ks=1:1:20
%     for bc=1:1:20
%       ss = parameter.ranking(1:i); 
%       [~, vr] = trainClassifier(Training(:,ss),li.labelsTraining,ks,bc);
%       if ( vr.accuracy-acc>=0.005  || vr.auc-auc>0.01 ) && vr.accuracy>0.80 && vr.auc>0.85 && vr.specificity>=0.7 && vr.sensitivity>=0.7
%         acc=vr.accuracy;
%         auc=vr.auc;
%         disp(vr);
%         disp([num2str(i) '...' num2str(ks) '...' num2str(bc)])
%       end
%     end
%   end
% end
% clear acc auc i bc ks vr ss