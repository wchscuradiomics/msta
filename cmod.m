function [q,r] = cmod(a,b)

q = fix(a/b);
r = rem(a,b);