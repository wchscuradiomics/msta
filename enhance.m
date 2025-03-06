function EI = enhance(I,M)

EI = imfilter(double(I),M,'conv','symmetric','same'); % symmetric replicate circular
