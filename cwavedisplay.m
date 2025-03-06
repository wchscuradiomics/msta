function    
%CWAVEDISPLAY(f1,f2,name,level) Customize the display of subband images and original images for wavelet transform.
%   f1 and f2 are original images.
%   The wavelet transform for f1 and f2 are listed in one plot.

% f1=rgb2gray(imread('DataSet\Liver\HCC\Non-enhanced\1\HCC_NON_1_1.bmp'));
[C,S]=wavedec2(F,level,waveletName);
A1 = appcoef2(C,S,waveletName,1); % Approximation coefficients matrix at level 1
[H1,V1,D1]=detcoef2('all',C,S,1); % Details coefficients matrices at level 1
% G=wavedisplay(C,S);
V1img = uint8( wcodemat(V1,255,'mat',1) );
H1img = uint8( wcodemat(H1,255,'mat',1) );
D1img = uint8( wcodemat(D1,255,'mat',1) );
A1img = uint8( wcodemat(A1,255,'mat',1) );
% reso = 96;

% [ha, pos] = tight_subplot(2,3,[.01 .001],[.01 .01],[.15 .01]);
% axes(ha(2)),imshow(A1img);
% axes(ha(3)),imshow(H1img);
% axes(ha(5)),imshow(D1img);
% axes(ha(6)),imshow(V1img);


subplot(2,3,[1 4]),imshow(uint8(F));
subplot(2,3,2),imshow(A1img);
subplot(2,3,3),imshow(H1img);
subplot(2,3,5),imshow(D1img);
subplot(2,3,6),imshow(V1img);

