%% integrate validation results and test results
% % validationResults = cell(40,1); testResults = cell(40,1); save proc;
% load proc;
% i=1; load MSTA-c-h;
% validationResults{i,1} = validationResult; testResults{i,1} = testResult;
% disp(['validation:' num2str(validationResult.accuracy*100,4) 9 num2str(validationResult.sensitivity*100,4) 9 num2str(validationResult.specificity*100,4) 9 num2str(validationResult.auc,3)]);
% disp(['test:' num2str(testResult.accuracy*100,4) 9 num2str(testResult.sensitivity*100,4) 9 num2str(testResult.specificity*100,4) 9 num2str(testResult.auc,3)]);
% save proc.mat validationResults testResults
% clear;

%%
a='bgrcmk';
b='.ox+*sdv^<>ph';
c={'-',':','-.','--'};
tanames = {'GLS','GLH','GLCM','GLRLM','GL-M',...
  'ACM','LOG','WT','WPT','CT',...
  'CMS-W-CS','CMS-W-H','CMS-W-COM','CMS-W-RLM','CMS-W-M',...
  'MSTA-W-CS','MSTA-W-H','MSTA-W-COM','MSTA-W-RLM','MSTA-W-M',...
  'CMS-WP-CS','CMS-WP-H','CMS-WP-COM','CMS-WP-RLM','CMS-WP-M',...
  'MSTA-WP-CS','MSTA-WP-H','MSTA-WP-COM','MSTA-WP-RLM','MSTA-WP-M',...
  'CMS-C-CS','CMS-C-H','CMS-C-COM','CMS-C-RLM','CMS-C-M',...
  'MSTA-C-CS','MSTA-C-H','MSTA-C-COM','MSTA-C-RLM','MSTA-C-M'};

%% MSTA methods vs traditional methods
index = [1:10 29];
vrs = validationResults(index);
trs = testResults(index);
% a = 'bbbbbkkkkk';
b='.ox+*sdv^<>ph';
lnames = tanames(index); 
% set(gca,'position',[0.01,0.01,1,0.5] )
positionVector1 = [0.075,0.1, 0.44, 0.85];
subplot('Position',positionVector1);
for i=1:length(index)
  lnames{i} = [lnames{i} ' ' num2str(round(vrs{i}.auc,2),'%3.2f')];
  if i<=10, c='--';lw = 0.5;r='b'; else, c='-';lw=1;r='r'; end
  plot(vrs{i}.fprate,vrs{i}.tprate,[b(i) c r],'linewidth',lw,'MarkerSize',5);hold on;
end
title('ROC curves (validation)');
xlabel('False Positive Rate (1-Specificity)');
ylabel('True Positive Rate (Sensitivity)');
hleg=legend(lnames);

lnames = tanames(index); 
positionVector2 = [0.53,0.1, 0.44, 0.85];
subplot('Position',positionVector2);
for i=1:length(index)
  lnames{i} = [lnames{i} ' ' num2str(round(trs{i}.auc,2),'%3.2f')];
  if i<=10, c='--';lw = 0.5;r='b'; else, c='-';lw=1;r='r'; end
  plot(trs{i}.fprate,trs{i}.tprate,[b(i) c r],'linewidth',lw,'MarkerSize',5);hold on;
end
set(gca,'ytick',[]);
title('ROC curves (test)');
xlabel('False Positive Rate (1-Specificity)');
ylabel('True Positive Rate (Sensitivity)');
hleg=legend(lnames);
clear i index vrs trs lnames hleg b a c r lw positionVector1 positionVector2

%% MSTA vs CMS
% index = 31:40;
% vrs = validationResults(index);
% trs = testResults(index);
% lnames = tanames(index);
% s = vrs;
% for i=1:5
%   positionVector1 = [i*0.195-0.19,0.1, 0.19, 0.8];
%   subplot('Position',positionVector1);
%   lnames{i} = [lnames{i} ' ' num2str(round(s{i}.auc,2),'%3.2f')];
%   lnames{i+5} = [lnames{i+5} ' ' num2str(round(s{i+5}.auc,2),'%3.2f')];
%   plot(s{i}.fprate,s{i}.tprate,'b--','LineWidth',0.5); hold on;
%   plot(s{i+5}.fprate,s{i+5}.tprate,'r-','LineWidth',1);  
%   hleg=legend({lnames{i},lnames{i+5}});  
%   set(hleg,'location','southeast');
%   title('ROC curves (validation)','position',[0.6,0.4]);
%   % xlabel('False Positive Rate (1-Specificity)');
%   % ylabel('True Positive Rate (Sensitivity)');
%   set(gca,'ytick',[]);
%   set(gca,'xtick',[]);
% end
% clear positionVector1 i  hleg index vrs trs lnames  s                                                                                  