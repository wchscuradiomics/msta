function edges = divbins(mini,maxi,bincount)
%edges=divbins(mini,maxi,bincount) divides [mini maxi] equally into bincount+1 edges.
%
% mini: an integer specifying the minimum value of [mini maxi].
%
% maxi: an integer specifying the maximum value of [mini maxi].
%
% bincount: an integer specifying the number of bins.
%
% edges: a 1*(bincount+1) row vector specifying the edges of these n bins.

len = maxi - mini;
bin = len/bincount;
edges = zeros(1,bincount+1);

edges(1)= -Inf;
edges(bincount+1) = Inf;

for i=1:bincount-1
  edges(i+1) = mini + i*bin;
end
end