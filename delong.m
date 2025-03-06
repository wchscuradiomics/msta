% tanames = {'GLS','GLH','GLCM','GLRLM','GL-M',...
%   'ACM','LOG','WT','WPT','CT',...
%   'CMS-W-CS','CMS-W-H','CMS-W-COM','CMS-W-RLM','CMS-W-M',...
%   'MSTA-W-CS','MSTA-W-H','MSTA-W-COM','MSTA-W-RLM','MSTA-W-M',...
%   'CMS-WP-CS','CMS-WP-H','CMS-WP-COM','CMS-WP-RLM','CMS-WP-M',...
%   'MSTA-WP-CS','MSTA-WP-H','MSTA-WP-COM','MSTA-WP-RLM','MSTA-WP-M',...
%   'CMS-C-CS','CMS-C-H','CMS-C-COM','CMS-C-RLM','CMS-C-M',...
%   'MSTA-C-CS','MSTA-C-H','MSTA-C-COM','MSTA-C-RLM','MSTA-C-M'};

clc;
load methods;
ratings = zeros(length(tanames),218); % 218 samples for validation, 94 samples for test
spsizes = [107 111]; % for validation [107 111], for test [46 48]
save delong.mat ratings spsizes
for i=1:length(tanames)
  load methods;
  load(tanames{i});
  load delong;
  scores = validationResult.scores;
  for j=1:size(scores,1)
    scores(j,:)= softmax(scores(j,:)')';
  end
  ratings(i,:) = scores(:,1)';
  save delong.mat ratings spsizes
  clear;
end
clear i j scores

%% standard deviation of 10-fold validations
% clear;clc;
% for i=36:40  
%   load methods;
%   load(tanames{i});
%   [trainedClassifier, validationResult, pfs] = trainClassifier(Training(:,parameter.subset),li.labelsTraining,parameter.ks,parameter.bc);
%   % m = mean(pfs);
%   s = std(pfs);
%   disp([num2str(validationResult.accuracy*100,'%4.2f') '¡À' num2str(s(1)*100,'%4.2f') 9 ...
%     num2str(validationResult.sensitivity*100,'%4.2f') '¡À' num2str(s(2)*100,'%4.2f') 9 ...
%     num2str(validationResult.specificity*100,'%4.2f') '¡À' num2str(s(3)*100,'%4.2f') 9 ...
%     num2str(validationResult.auc,'%4.3f') '¡À' num2str(s(4),'%4.3f')]);
%   clear;
% end
% clear i j m s