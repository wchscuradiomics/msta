function [B,B1,B2] = mmmmboundaries(COEFF1s,COEFF2s,absolution,option)
%[B,B1,B2]=mmmmboundaries(COEFF1s,COEFF2s,absolution,option) computes boundaries of minimum minimums and maximum maximums for
%coefficients of two types.
%
% COEFF1s: a n1*m cell of coefficient matrices for type 1, where n1 is the sample size for type 1 and a row vector contains m
% coefficient matrices for a sample.
%
% COEFF2s: a n2*m cell of coefficient matrices for type 2, where n2 is the sample size for type 2 and a row vector contains m
% coefficient matrices for a sample.
%
% absolution: a logical value specifying whether absolute coefficients are used.
%
% B: a 2*m matrix representing the boundaries of m components basing COEFF1s and COEFF2s.
%
% B1: a 2*m matrix representing the boundaries of m components basing COEFF1s.
%
% B2: a 2*m matrix representing the boundaries of m components basing COEFF2s.
%
% In B/B1/B2, the first row stores the average values of minimums, the second row stores the average values of maximums.

if nargin < 3, absolution = true; end
if nargin < 4, option = false; end

compcount = size(COEFF1s,2);
if compcount ~= size(COEFF2s,2), error('There must be an equal number of components of both types.'); end

B = zeros(2,compcount);

B1 = boundaries(COEFF1s,absolution,option);
B2 = boundaries(COEFF2s,absolution,option);

B(1,:) = min([B1(1,:); B2(1,:)]);
B(2,:) = max([B1(2,:); B2(2,:)]);