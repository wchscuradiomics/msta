function f = extractGlcm21Features(I, dl,nLevel,grayLimits,averaged)
%extract texture features with GLCM.
%   max dl is 5, direction=0 45 90 135.
%   21 features are extracted
%   return a row vector

offset1 = [0 1; -1 1; -1 0; -1 -1];
offset2 = [0 2; -2 2; -2 0; -2 -2];
offset3 = [0 3; -3 3; -3 0; -3 -3];
offset4 = [0 4; -4 4; -4 0; -4 -4];
offset5 = [0 5; -5 5; -5 0; -5 -5];
offset(:,:,1)=offset1;
offset(:,:,2)=offset2;
offset(:,:,3)=offset3;
offset(:,:,4)=offset4;
offset(:,:,5)=offset5;

if nargin == 4
  averaged = 0;
end

n =  21 * 4;
if averaged == 1
  n = 21;
end
f = zeros(dl,n); % Initialize the feature vector

for d=1:dl % Distance from 1 to dl
  GS=graycomatrix(I,'NumLevels',nLevel,'Offset',offset(:,:,d),'GrayLimits',grayLimits);
  A=cell2mat(struct2cell(GLCMFeatures(GS)))';
  if averaged == 1    
    f(d,:) = mean(A);
  else
    f(d,:) = A(:);
  end  
end

f = f';
f = f(:)';
end