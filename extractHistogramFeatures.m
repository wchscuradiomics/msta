function f=extractHistogramFeatures(I,n,gl)
%Compute histogram fetures of an image I
% gl means the grayscale of I is [gl(1) gl(2)], n is the scaling parameter (scale to [1 n])

if nargin == 2
  gl=[0 255];
end

slope = n / (gl(2) - gl(1));
intercept =1 - (slope*(gl(1)));
I = floor(imlincomb(slope,double(I),intercept,'double'));
I(I > n) = n;
I(I < 1) = 1;
f = cstatxture(I, n); % cstatxture requires the grayscale of I is [1 n]
