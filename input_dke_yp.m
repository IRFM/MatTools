function [val_out,mod] = input_dke_yp(string,default,values,message)
%
%	Customized input function with default and allowed values
%
%	Input:
%
%		- string  : description of the parameter (string)
%		- default : default value of the parameter (string, scalar, or array)
%       - values  : set of possibles values (array or cells)
%               USE :   - cell array  : list of possible string or array values
%                   - row array   : list of possible scalar values
%                   - [vmin;vmax] : bounds for scalar or array value(s)        
%                   
%       - message : universal warning message (string)
%
%	Output:
%
%		- val_out : value of the parameter transfered to the program [1,1]
%		  (same type as values)
%       - mod     : 1 if value different from default value, 0 otherwise
%
% by Y.PEYSSON CEA/DSM/IRFM <yves.peysson@cea.fr> 
% and J.DECKER CEA/DSM/IRFM <joan.decker@cea.fr>
%
if nargin < 4
    message = '';
end
if nargin < 2
    default = [];
end
if nargin < 1,
    string = '';
end
%
if ischar(default),
    %
    type = 1;
    defstr = default;
    %
elseif isnumeric(default),
    %
    type = 0;
    sd = size(default);
    default = default(:).';
    defstr = num2str(default);
    %
else
    %
    error('The default value must be a string or a numeric array')
    %
end
% 
val_out = [];
warnstr = '';
%
flag = -1;
mod = 0;
%
while flag <= 0,
    %
    if flag == 0,
        if ~isempty(message),
            warnstr = message;
        end
        %
        disp(['====> Warning: ',warnstr]);
        disp(' ');
    else
        flag = 0;
    end
    %
 	if type == 0,
  		val_out = input([string ' ? [',defstr,'] : ']);
 	else
  		val_out = input([string ' ? [',defstr,'] : '],'s');
    end
    %
    if isempty(val_out),
        val_out = default;
        mod = 0;
    else
        mod = 1;
    end
    %
    if type == 0 
        if ~isnumeric(val_out),
            warnstr = 'The returned value must be numeric';
            continue
        elseif ~isempty(default),
            if numel(val_out) ~= length(default),
                warnstr = ['The returned array must contains ',num2str(length(default)),' elements.'];
                continue
            else
                val_out = reshape(val_out,sd);
            end
        end
    end
    %
    if nargin > 2 && ~isempty(values),% test if input value is allowed
        %
        if ~iscell(values),
            if type == 1,
                error('The allowed values must be stored in cells for string input.')
            end
            %
            if size(values,1) == 1,% list of valued allowed
                if length(val_out) > 1,
                    warnstr = 'The returned value must be a scalar.';
                    continue
                end
                if ~any(val_out == values),
                    warnstr = 'The returned value is not allowed.';
                    continue
                end
            elseif size(values) == [2,1],% bounds for returned values
                if ~isinf(values(1)) && any(val_out < values(1)),
                    warnstr = ['The returned value must be larger than ',num2str(values(1)),'.'];
                    continue
                end
                if ~isinf(values(2)) && any(val_out > values(2)),
                    warnstr = ['The returned value must be smaller than ',num2str(values(2)),'.'];
                    continue
                end
            else
                error('The values array must be a single row or a 2-values column.')
            end
            %
            flag = 1;
            %
        else
            %
            for ii = 1:length(values),
                if type == 0,
                    if size(val_out) == size(values{ii}) && all(val_out == values{ii}),
                        flag = 1;
                    end
                elseif strcmp(val_out,values{ii}),
                    flag = 1;
                end
            end
        end
        %
    else
        flag = 1;
    end
end
