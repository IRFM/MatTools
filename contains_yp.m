function indices = contains_yp(a,b)
%
% Compatibility with older matlab version
%
matlab_version = str2num(matversion_yp);
%
if matlab_version <= 901
    %
    if iscell(a)
        %
        indices = 1-cellfun('isempty',strfind(a,b));
        %
    else
        %
        indices = strfind(a,b);
        %
    end
    %
else
    %
    indices = contains(a,b);
    %
end
%