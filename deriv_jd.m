% 
% /////////////////////////////////////////
%
% Software name : MatTools, part of LUKE
%
% Authors : Yves Savoye-Peysson and Joan Decker
%
% Copyright holders : Commissariat a l'Energie Atomique et aux Energies Alternatives (CEA), France
%
% CEA authorizes the use of the LUKE software under the CeCILL-C open source license https://cecill.info/licences/Licence_CeCILL-C_V1-en.html
%
% The terms and conditions of the CeCILL-C license are deemed to be accepted upon downloading the software and/or exercising any of the rights granted under the CeCILL-C license.
%
% /////////////////////////////////////////
%
function yp = deriv_jd(y,x,dim)
%
% This function calculates the derivative of y defined on the grid x. 
% x can be a non-uniform grid
% If x is not provided, it is assumed to be a uniform grid 1,2,...N.
%
% INPUTS 
%   - y : data of which the derivative must be taken.
%   - x : grid on which the data is defined
%   - dim : dimension along which the derivative must be taken.
%


%
if nargin == 0,
    error('deriv_jd must have at least one input argument');
elseif ~isnumeric(y)
    error('y must be a numerical array');
end
%
sy = size(y);
nsy = length(sy);
%
if nargin < 3,
    dim = find(sy > 1,1,'first');
elseif ~isnumeric(dim) || ~isscalar(dim) || abs(dim - round(dim)) > 0 || dim > nsy,
    error('invalid dimension prescription');
end
%
y = shiftdim(y,dim-1);
ny = size(y,1);
%
if ny < 2,
    error('y must contain at least two grid points in the dimension ''dim''');
end
%
dy = diff(y);
%
if nargin < 2,
    x = 1:ny;
elseif ~isnumeric(x) || ~isvector(x) || length(x) ~=  ny,
    error('x must be a numerical vector of the length size(y,dim)');
end
%
x = x(:);
dx = diff(x);
%
if ~all(isreal(x)) || any(dx <= 0),
    error('x must be a monotonically increasing real array')
end
%
dxs = repmat(dx,[1,sy([1:dim-1,dim+1:nsy])]);
yp = zeros(ny,sy([1:dim-1,dim+1:nsy]));
%
yp(2:ny-1,:) = (dxs(2:ny-1,:).*dy(1:ny-2,:)./dxs(1:ny-2,:) + dxs(1:ny-2,:).*dy(2:ny-1,:)./dxs(2:ny-1,:))./(dxs(1:ny-2,:) + dxs(2:ny-1,:));
% yp(1,:) = dy(1,:)./dxs(1,:);
% yp(ny,:) = dy(ny-1,:)./dxs(ny-1,:);
yp(1,:) = yp(2,:) + dxs(1,:).*(yp(2,:) - yp(3,:))./dxs(2,:);
yp(ny,:) = yp(ny-1,:) + dxs(ny-1,:).*(yp(ny-1,:) - yp(ny-2,:))./dxs(ny-2,:);
%
yp = shiftdim(yp,nsy-(dim-1));
%