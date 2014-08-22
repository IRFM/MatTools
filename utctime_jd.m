function procstr = utctime_jd
%
[timeres,timestr] = unix('date -u +%Y%m%d%H%M%S');
%
if ~timeres,
    procstr = get_datetime_yp(timestr);% human readable format
else
    procstr = '';
end
