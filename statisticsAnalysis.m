%% sumarize: count the number of features with statistical differences
% names = {'msta-w-m','cms-w-m','msta-wp-m','cms-wp-m','msta-c-m','cms-c-m'};
% n=0.05:-0.0001:0.0001;
% num = zeros(length(names),length(n));
% 
% for i=1:length(names)  
%   load(names{i});
%   [p,h,stats] = mwu(Test(li.labelsTest == 1,:),...
%     Test(li.labelsTest == 2,:),'both');
%   % [p,h,stats] = mwu(Features(li.labels == 1,parameter.ranking(1:20)),...
%   %   Features(li.labels == 2,parameter.ranking(1:20)),'both');
%   for j=1:length(n)
%     num(i,j) = sum(p<=n(j));
%   end 
% end
% save statistics_analysis.mat num names n;
% clear;clc;

%% plot sumarization
% load statistics_analysis;
% i=5;j=6;
% x = fliplr(n);
% plot(x,fliplr(num(i,:)),'linewidth',1.5);
% hold on;
% plot(x,fliplr(num(j,:)),'linewidth',0.25);
% hleg=legend({upper(names{i}),upper(names{j})});
% xlabel('p-value');
% ylabel('number of features');
% clear i j x ans;

%% left/right-tailed test for eight features
% msta-w-m 1:279; msta-wp-m 280:928; msta-c-m 929:1352 % indices of the eight features
% clc;
% i=8;
% STATS=mwwtest(Data(1:46,i)',Data(47:end,i)');
% auc = STATS.U(2)/ (sum(STATS.U));
% aucs = [0.770 0.769 0.809 0.786 0.792 0.786 0.783 0.761];

%% find the component number
% clear;clc;
% load msta-w-cs;
% nTotal = size(Test,2);
% nf=3; % the coefficient statistics method extract 3 features from a coefficient matrix
% [p,h,stats] = mwu(Test(li.labelsTest == 1,:),...
%   Test(li.labelsTest == 2,:),'left');
% [pSort,pSortIndex] = sort(p);
% 
% Index = zeros(nTotal,2);
% for i=1:nTotal
%   idx = pSortIndex(i);
%   [q,r] = cmod(idx,nf);
%   if r==0
%     Index(i,:) = [q r];
%   else
%     Index(i,:) = [q+1 r]; 
%   end  
% end
% clear i ans q r idx
% Index = [pSortIndex(1:nTotal)' Index pSort(1:nTotal)'];

clc;
for i=1:40
  ci = calci(A(i,1),A(i,2));
  disp([num2str(i) ':' tanames{i} 9 'CI: ' num2str(ci(1),'%3.2f') '-' num2str(ci(2),'%3.2f') ]);
end
clear i ans ci;