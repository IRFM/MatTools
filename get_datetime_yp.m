function datetime = get_datetime_yp(txt)
%MATHELP - Extract the date/time in a string obtained from ls (POSIX or GNU format) or date Unix commands
%
% Extract the date/time in a string obtained from ls (POSIX or GNU format) 
% or date commands (Matlab format) : 06-Jun-2014 16:35:25. Usefull to
% follow remote jobs
%
%   Inputs :
%   
%       - txt : string [1:n]
%
%   Outputs : 
%   
%       - datetime: date and time as done by MatLab (as given by datestr(clock) [1:m] 
% 
%by Y. Peysson (CEA/IRFM, yves.peysson@cea.fr and J. Decker (CEA/IRFM, joan.decker@cea.fr)
%
months = ['Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'];
%
days = ['Mon';'Tue';'Wed';'Thu';'Fri';'Sat';'Sun'];
%
if ~isempty(strfind(txt,'bind:')) && ~isempty(strfind(txt,'forwarding.'))
    refstr = 'forwarding.';
    txt = txt(max(strfind(txt,refstr))+length(refstr):end);          
end
%
if ~isempty(strfind(txt,'bind:')) && ~isempty(strfind(txt,'address'))
    refstr = 'address';
    txt = txt(max(strfind(txt,refstr))+length(refstr):end);          
end
%
if ~isempty(strfind(txt,'export:')) && ~isempty(strfind(txt,'found.'))
    refstr = 'found.';
    txt = txt(max(strfind(txt,refstr))+length(refstr):end);          
end
%
if ~isempty(strfind(txt,'Successful ssh identification !'))
    txt = txt(length('Successful ssh identification !')+2:end);
end
%
txt = strtrim(txt);
%
if ~isempty(str2double(txt)) && length(txt) == 14,%numeric date format YYYYMMDDHHMMSS from command "date +%Y%m%d%H%M%S"
    year = txt(1:4);
    month = months(str2double(txt(5:6)),:);
    day = txt(7:8);
    hour = txt(9:10);
    minute = txt(11:12);
    second = txt(13:14);
else
    %
    timeref = clock;
    %
    year = int2str(timeref(1)-1);%previous year (in case of a simulation is launched in december and results obtained in january)
    iyear = strfind(txt,year);
    %
    if ~strcmp(txt(iyear-1),' ') ||  ~strcmp(txt(iyear+4),' ')
        iyear = '';
    end
    %
    if isempty(iyear),
        year = int2str(timeref(1));%actual year
        iyear = strfind(txt,year);
        %
        if isempty(iyear),
            error(['Unrecognized year or year too old in ',txt]);
        end
        %
    end
    %
    if length(iyear) > 1, iyear = iyear(1);end
    %
    flag = 0;
    %
    for iday = 1:7,
        if strcmp(txt(1:3),days(iday,:))
            flag = 1;
            break
        end
    end
    if flag,
            %
            month = txt(5:7);
            day = ['0',num2str(str2double(txt(8:11)))];
            hour = txt(12:13);
            minute = txt(15:16);
            second = txt(18:19);
            %
    else
        if strcmp(txt(iyear+4),'-'),%GNU format
            %
            month_gnu= txt(iyear+5:iyear+6);
            month = months(str2double(month_gnu),:);
            %
            day = txt(iyear+8:iyear+9);
            hour = txt(iyear+11:iyear+12);
            minute = txt(iyear+14:iyear+15);
            second = txt(iyear+17:iyear+18);
            %
        else%POSIX format
            %
            month_posix = txt(iyear-16:iyear-14);  
            month = month_posix;
            %
            day = txt(iyear-12:iyear-11);
            hour = txt(iyear-9:iyear-8);
            minute = txt(iyear-6:iyear-5);
            second = txt(iyear-3:iyear-2);
            %
        end
    end
end
%
datetime = datestr(datevec([day,'-',month,'-',year,' ',hour,':',minute,':',second]));
%


    