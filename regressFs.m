function indices = regressFs(y,X,alpha)

y(y==1) = 0;
y(y==2) = 1;

r2 = zeros(1,size(X,2));
for j = 1:size(X,2)
  [b,bint,r,rint,stats]=regress(y,X(:,j),alpha);
  r2(j) = stats(1)^2;
end

[~,indices]=sort(r2,'descend');