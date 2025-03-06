function L = iscomplex(A)

L = ~(A == real(A));

% L = zeros(size(A));
% for i=1:size(A,1)
%   for j=1:size(A,2)
%     L(i,j) = ~isreal(A(i,j));
%   end
% end