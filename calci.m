function ci = calci(m,s,n)

ci = zeros(1,2);
ci(1) = m-1.96*(s/sqrt(n));
ci(2) = m+1.96*(s/sqrt(n));

