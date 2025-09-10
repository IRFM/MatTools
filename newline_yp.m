function a = newline_yp
%
% newline function for old matlab before R2016b
%
[matlab_version,matlab_release,flag_toolbox] = matversion_yp;
%
if ~strcmp(matlab_release,'R2016b')
    %
    year_release = str2num(matlab_release(2:end-1));
    %
    if year_release < 2016
        %
        a = char(10);
        %
    elseif year_release == 2016 %R2016a
        %
        a = char(10);
        %
    elseif year_release > 2016
        %
        a = newline;
        %
    end
    %
else
    %
    a = newline;
    %
end

  











end