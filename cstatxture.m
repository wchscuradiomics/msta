function t = cstatxture(I, n)
%Compute statistical measures of texture in an image.
% I is a discretized matrix, the grayscale of I is [1 n].
% T(1) = Average gray level
% T(2) = Average contrast
% T(3) = Measure of smoothness
% T(4) = Third moment
% T(5) = Measure of uniformity
% T(6) = Entropy
% T(7) = Fourth moment

% Obtain histogram and normalize it.
p = chist(I,n);
p = p./numel(I);
L = length(p);
t = zeros(1,7);

% Compute the four moments. We need the unnormalized ones
% from function statmoments. These are in vector mu.
[v, mu] = cstatmoments(p, 4);

% Compute the seven texture measures:
% Average gray level.
t(1) = mu(1);
% Standard deviation.
t(2) = mu(2).^0.5;
% Smoothness.
% First normalize the variance to [0 1] by
% dividing it by (L-1)^2.
varn = mu(2)/(L - 1)^2;
t(3) = 1 - 1/(1 + varn);
% Third moment (normalized by (L - 1)^2 also).
t(4) = mu(3)/(L - 1)^2;
% Uniformity.
t(5) = sum(p.^2);
% Entropy.
t(6) = -sum(p.*(log2(p + eps)));
% Fourth moment
t(7) = mu(4)/(L - 1)^2;