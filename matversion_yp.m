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
v = ver('matlab');
matlabversion = num2str(round(100*str2num(v.Version)));
matlabrelease = v.Release(2:end-1);


