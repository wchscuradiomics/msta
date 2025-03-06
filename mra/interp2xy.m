function [x,y,xq,yq] = interp2xy(nx,ny,minsi)
%[x,y,xq,yq] = interp2xy(nx,ny,minsi) calculate meshgrid of function interp2 to keep the minimum edge have minsi pixels. x is the
%horizontal axis and y is the vertical axis.
%
% minsi: an integer specifying the minimum size is [minsi minsi].

% keep ny/nx=nyq/nxq
if nx<ny
  nxq = minsi;
  nyq = round(ny*nxq/nx);
else
  nyq = minsi;
  nxq = round(nx*nyq/ny);
end

[x,y] = meshgrid(1:nx,1:ny);

dx = (nx-1)/(nxq-1);
dy = (ny-1)/(nyq-1);

[xq,yq]=meshgrid(1:dx:nx,1:dy:ny);
