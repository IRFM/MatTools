function [vallu] = input_dke_yp(string,default,values,message)
%
%	Customized input function with default value
%
%	Input:
%
%		- string: description of the parameter (string) [1,m]
%		- default: default value of the parameter [1,1]
%       - values: set of possibles values (cells)
%       - message: warning message (string) [1,m]
%
%	Output:
%
%		- vallu: value of the parameter transfered to the program [1,1]
%		  (same type as vd)
%
%by Y.PEYSSON CEA/DSM/IRFM <yves.peysson@cea.fr>
%
if nargin == 0,
	infoyp(2,'Wrong number of input arguments for input_dke_yp');
	return;
elseif nargin == 1,
    default = NaN;
    values = {};
    message = '';
elseif nargin == 2,
    values = {};
    message = '';
elseif nargin == 3,
    message = '';
end
%
if isempty(default),
	default = NaN;
end
%
chartype = isstr(default);
vallu = '';
%
while isempty(vallu),
 	if chartype == 0,
  		rep = input(sprintf([string ' ? <%g> '],default));
 	else
  		rep = input(sprintf([string ' ? <',default,'> '],default),'s');
 	end
 	if ~isempty(rep),
        flag = 0;
        if nargin > 2,%test the input value
            for ii = 1:length(values),
                if chartype == 0,
                    if values{ii} == rep,flag = 1;break;end
                else
                    if strcmp(rep,values{ii});flag = 1;break;end
                end
            end
            if flag == 1,
                vallu = rep;
            else
                disp(['Warning: ',message]);
            end
        else
            vallu = rep;
        end
 	else
  		vallu = default;
 	end
end
