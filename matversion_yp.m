function [matlabversion,matlabrelease] = matversion_yp
% This function specifies the current Matlab version
%
% Input: none
%
% Output:
%
%   - matlabversion: Matlab version [1,p]
%   - matlabrelease: Matlab release (Ryyyya or Ryyyyb, where yyyy is the year) [1,p]
%
% Warning: none
%
%by Y.Peysson CEA/DSM/IRFM <yves.peysson@cea.fr> and Joan Decker CEA/DSM/IRFM (joan.decker@cea.fr)
%
ver = version;
%
[iver] = strfind(ver,'.');
if iver(2)-iver(1) == 2,
	mver = [ver(1:iver(1)-1),'0',ver(iver(1)+1:iver(2)-1)];
else
	mver = [ver(1:iver(1)-1),ver(iver(1)+1:iver(2)-1)];
end
%
matlabversion = mver;
%
[iver] = strfind(ver,'(');
matlabrelease = [ver(iver(1)+1:iver(1)+6)];


