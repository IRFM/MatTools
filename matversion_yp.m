function [matlab_version,matlab_release,flag_toolbox] = matversion_yp(toolbox_name)
%LUKE - This function specifies the current version of matlab and if a toolbox exists
%
% This function specifies the current version of matlab and tests if a toolbox exists and is in the path
%
% Input:
%
%	- toolbox_name: name of toolbox [1,p]
%		(default = none)
%
% Output:
%
%   - matlab_version: Matlab version [1,p]
%   - matlab_release: Matlab release (Ryyyya or Ryyyyb, where yyyy is the year) [1,p]
%   - flag_toolbox: flag that tells if the toolbox_name exists and is in the path (1: yes, 0: no)  [1,p]
%
% Warning: none
%
%by Y.Peysson CEA/DSM/IRFM <yves.peysson@cea.fr> and Joan Decker CEA/DSM/IRFM (joan.decker@cea.fr)
%
if nargin == 0,
	toolbox_name = '';
end
%
v = version;
%
[iv] = strfind(v,'.');
if iv(2)-iv(1) == 2
    if str2double(v(1)) > 5 % since R2023b 
	    matlab_version = [v(1:iv(1)-1),'0',v(iv(1)+1:iv(2)-1)];
    else
        matlab_version = [v(1:iv(1)-1),v(iv(1)+1:iv(2)-1)];
    end
else
	matlab_version = [v(1:iv(1)-1),v(iv(1)+1:iv(2)-1)];
end
%
v = ver('matlab');
matlab_release = v.Release(2:end-1);
%
if ~isempty(toolbox_name),
	%
	flag_toolbox = [];
	%
	v = ver;
	%
    for iv = 1:length(v),
        flag_toolbox = strcmp(char(v(iv).Name),toolbox_name);
        if flag_toolbox,break;end
    end
else
    flag_toolbox = [];
end
%