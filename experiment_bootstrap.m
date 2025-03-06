%% test: bootstrap
clc;
Tstc = Test(:,parameter.subset);
Trnc = Training(:,parameter.subset);
tb.nt = 100;
tb.Idx =  zeros(94,tb.nt);
for j=1:tb.nt
  tb.Idx(:,j) = bootstrap(1:94,94);
end
clear j;

[trainedClassifier, validationResult, ~] = trainClassifier(Trnc,li.labelsTraining,parameter.ks,parameter.bc);


tb.R = zeros(4,tb.nt);
for j=1:tb.nt
  D = Tstc(tb.Idx(:,j),:);
  responses = li.labelsTest(tb.Idx(:,j));
  [testClasses,testScores]=trainedClassifier.predictFcn(D);
  r = performance(responses,testClasses,testScores,[1 2]);
  tb.R(1,j) = r.auc;
  tb.R(2,j)= r.accuracy;
  tb.R(3,j)= r.sensitivity;
  tb.R(4,j)= r.specificity;
end
clear j D rsponses ans r Tstc Trnc testScores testClasses;

tb.R = tb.R';

tb.Mr = mean(tb.R);
tb.Sr = std(tb.R);
disp('AUC accuracy sensitivity specificity');
tb.Mr
tb.Sr
calci(tb.Mr(1),tb.Sr(1),tb.nt)
clear ans;

%% validation bootstrap
clc;
vb.nt = 100;
vb.R = zeros(4,vb.nt);
Trnc = Training(:,parameter.subset);
for j=1:vb.nt
  [~, r, ~] = trainClassifierb(Trnc,li.labelsTraining,parameter.ks,parameter.bc);
  vb.R(1,j) = r.auc;
  vb.R(2,j)= r.accuracy;
  vb.R(3,j)= r.sensitivity;
  vb.R(4,j)= r.specificity;
end
clear j D rsponses ans r Tstc Trnc testScores testClasses;

vb.R = vb.R';

vb.Mr = mean(vb.R);
vb.Sr = std(vb.R);
disp('AUC accuracy sensitivity specificity');
vb.Mr
vb.Sr
calci(vb.Mr(1),vb.Sr(1),vb.nt)
clear ans;