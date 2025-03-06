function f=extractFosFeatures(I)

[m,n]=size(I);
I = I(:);
f1 = mean(I);
f2 = var(I);
f3 = sum(I.^2)/(m*n);
f=[f1 f2 f3];