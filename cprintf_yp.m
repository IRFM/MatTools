function count = cprintf_yp(style,format)
%
% compatibility of cprintf.m with all matlab version. cprintf release 1.14 is
% the last open script. From R2025a, cprintf.p is used, and diary must be
% disabled temporarily to display colors
%
[matlab_version,matlab_release,flag_toolbox] = matversion_yp;
%
year_release = str2num(matlab_release(2:end-1));
%
if year_release < 2025
    %
    count = cprintf_114(style,format);
    %
elseif year_release >= 2025
    %
    warning off
    count = cprintf_latest(style,format);
    warning on
    %
end
