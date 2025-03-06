function interval=caltestci(auc,z,n)

r = z * sqrt( (auc * (1 - auc)) / n);
interval = [auc-r auc+r];

% q0=auc*(1-auc);
% q1=auc/(2-auc)-auc^2;
% q2 = 2*auc^2/(1+auc)-auc^2;
% se = sqrt((q0+(n1-1)*q1+(n2-1)*q2)/(n1*n2));
% interval=[auc-se*1.96 auc+se*1.96];
