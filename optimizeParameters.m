function optimizeParameters(Tr,labels,ksi,bci,a,b,c,d)

acc=0;auc=0;
nf = size(Tr,2);
for ks=ksi
  for bc=bci
    [~, vr] = trainClassifier(Tr,labels,ks,bc);    
    if (vr.accuracy-acc>=0.005 || vr.auc-auc>=0.01) && vr.accuracy>a && vr.auc>b && vr.specificity>=c && vr.sensitivity>=d
      acc=vr.accuracy;
      auc=vr.auc;
      disp([num2str(vr.accuracy) '...' num2str(vr.auc) '...' num2str(vr.sensitivity) '...' num2str(vr.specificity) '...' num2str(nf) '...' num2str(ks) '...' num2str(bc)]);
    end
  end
end

