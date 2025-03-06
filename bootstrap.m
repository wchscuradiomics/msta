function b = bootstrap(a,n)

m=length(a); %dimension
idx= ceil(m*rand(1,n)) ; %generate n random index between 1 and m
b = a(idx) ; % sampling