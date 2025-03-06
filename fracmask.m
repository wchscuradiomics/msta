function M = fracmask(v,direction)
% fractial differential mask

% if nargin == 1
%   sz =5;
% end

m8 = (-v)*(-v+1)*(-v+2)*(-v+3)*(-v+4)*(-v+5)*(-v+6)*(-v+7)/factorial(8);
m7 = (-v)*(-v+1)*(-v+2)*(-v+3)*(-v+4)*(-v+5)*(-v+6)/factorial(7);
m6 = (-v)*(-v+1)*(-v+2)*(-v+3)*(-v+4)*(-v+5)/factorial(6);
m5 = (-v)*(-v+1)*(-v+2)*(-v+3)*(-v+4)/factorial(5);
m4 = (-v)*(-v+1)*(-v+2)*(-v+3)/factorial(4);
m3 = (-v)*(-v+1)*(-v+2)/factorial(3);
m2 = (-v)*(-v+1)/factorial(2);
m1 = -v;
m0 = 1;

M  = [m8 m7 m6; m1 m0 m5;m2 m3 m4];
% M = [m1 m2 m3;m8 m0 m4;m7 m6 m5];
M = imrotate(M,direction,'crop');

%% traditonal fd in 8 directions respectively
% M = zeros(5,5);
% M(3,3:5) = [m0 m1 m2];
% M = imrotate(M,direction,'crop');

%% traditional fd considering 8 directions
% if sz == 3
%   M = [m1 m1 m1; m1 m0 m1; m1 m1 m1];
% elseif sz == 5
%   M = zeros(5,5);
%   M(3,3:5) = [m0 m1 m2]; % 0
%   M(sub2ind(size(M), 2:-1:1,4:5)) = [m1 m2]; % 45
%   M(sub2ind(size(M), 4:5,4:5)) = [m1 m2]; % 315
%   M(2:-1:1,3) = [m1 m2]; % 90
%   M(sub2ind(size(M), 2:-1:1,2:-1:1))=[m1 m2]; % 135
%   M(3,2:-1:1) = [m1 m2]; % 180
%   M(sub2ind(size(M), 4:5,2:-1:1))=[m1 m2]; % 225
%   M(4:5,3) = [m1 m2]; % 270
% elseif sz == 7
%   M = zeros(7,7);  
%   M(4,4:7) = [m0 m1 m2 m3]; % 0 
%   M(sub2ind(size(M), 3:-1:1,5:7))=[m1 m2 m3]; % 45
%   M(3:-1:1,4) = [m1 m2 m3]; % 90
%   M(sub2ind(size(M), 3:-1:1,3:-1:1))=[m1 m2 m3]; % 135
%   M(4,3:-1:1) = [m1 m2 m3]; % 180
%   M(sub2ind(size(M), 5:7,3:-1:1))=[m1 m2 m3]; % 225
%   M(5:7,4) = [m1 m2 m3]; % 270
%   M(sub2ind(size(M), 5:7,5:7))=[m1 m2 m3]; % 315
% else
%   error('Not supported size.');
% end
% M = M/sum(M(:));
end