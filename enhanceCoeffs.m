function ECoeffs = enhanceCoeffs(Coeffs,M)

[m,n] = size(Coeffs);
ECoeffs = cell(m,n);

for i=1:m
  for j=1:n
    ECoeffs{i,j}=enhance(Coeffs{i,j},M);
  end
end