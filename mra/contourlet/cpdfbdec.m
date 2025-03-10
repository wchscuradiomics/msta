function y = cpdfbdec(x, pfilt, dfilt, nlevs)
% PDFBDEC   Pyramidal Directional Filter Bank (or Contourlet) Decomposition
%
%	y = pdfbdec(x, pfilt, dfilt, nlevs)
%
% Input:
%   x:      input image
%   pfilt:  filter name for the pyramidal decomposition step
%   dfilt:  filter name for the directional decomposition step
%   nlevs:  vector of numbers of directional filter bank decomposition levels 
%           at each pyramidal level (from coarse to fine scale).
%           If the number of level is 0, a critically sampled 2-D wavelet 
%           decomposition step is performed.
%
% Output:
%   y:      a cell vector of length length(nlevs) + 1, where except y{1} is 
%           the lowpass subband, each cell corresponds to one pyramidal
%           level and is a cell vector that contains bandpass directional
%           subbands from the DFB at that level.
%
% Index convention:
%   Suppose that nlevs = [l_J,...,l_2, l_1], and l_j >= 2.
%   Then for j = 1,...,J and k = 1,...,2^l_j 
%       y{J+2-j}{k}(n_1, n_2)
%   is a contourlet coefficient at scale 2^j, direction k, and position
%       (n_1 * 2^(j+l_j-2), n_2 * 2^j) for k <= 2^(l_j-1), 
%       (n_1 * 2^j, n_2 * 2^(j+l_j-2)) for k > 2^(l_j-1).
%   As k increases from 1 to 2^l_j, direction k rotates clockwise from
%   the angle 135 degree with uniform increment in cotan, from -1 to 1 for
%   k <= 2^(l_j-1), and then uniform decrement in tan, from 1 to -1 for 
%   k > 2^(l_j-1).
%
% See also:	PFILTERS, DFILTERS, PDFBREC

if isempty(nlevs)
    y = {x};
    
else
    % Get the pyramidal filters from the filter name
    [h, g] = pfilters(pfilt);
    
    if nlevs(end) ~= 0
        % Laplacian decomposition
        [xlo, xhi] = lpdec(x, h, g);
    
        % DFB on the bandpass image
        switch dfilt        % Decide the method based on the filter name
            case {'pkva6', 'pkva8', 'pkva12', 'pkva'}   
                % Use the ladder structure (whihc is much more efficient)
                xhi_dir = dfbdec_l(xhi, dfilt, nlevs(end));
                %xhi_dir = dfbdec(xhi, dfilt, nlevs(end)); 
            
            otherwise       
                % General case
                xhi_dir = dfbdec(xhi, dfilt, nlevs(end));                
        end
        
    else        
        % Special case: nlevs(end) == 0
        % Perform one-level 2-D critically sampled wavelet filter bank
        [xlo, xLH, xHL, xHH] = wfb2dec(x, h, g);
        xhi_dir = {xLH, xHL, xHH};
    end
    
    % Recursive call on the low band
    ylo =cpdfbdec(xlo, pfilt, dfilt, nlevs(1:end-1));

    % Add bandpass directional subbands to the final output
    % y = {ylo{:}, xhi_dir};
    y = {ylo{:}, xlo, xhi_dir};
end