function datetime = get_datetime_yp(txt)
% MATHELP - Extract the date/time in a string obtained from matremotecheck or command "date +%Y%m%d%H%M%S"
%
% Extract the date/time in a string of digits with format YYYYMMDDHHMMSS.
% Some extra text before the string is removed in needed.
%
%   Inputs :
%   
%       - txt : string
%
%   Outputs : 
%   
%       - datetime: date and time as done by MatLab (as given by datestr(clock) [1:m] 
% 
%by Y. Peysson (CEA/IRFM, yves.peysson@cea.fr and J. Decker (CEA/IRFM, joan.decker@cea.fr)
%
months = ['Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'];
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
if ~isempty(strfind(txt,'*******************************************************************************')) && ~isempty(strfind(txt,'*******************************************************************************'))
    refstr = '*******************************************************************************';
    txt = txt(max(strfind(txt,refstr))+length(refstr):end);          
end
%
txt = strtrim(txt);
%
if ~isempty(str2double(txt)) && length(txt) == 14,%numeric date format YYYYMMDDHHMMSS from matremotecheck or command "date +%Y%m%d%H%M%S"
    year = txt(1:4);
    month = months(str2double(txt(5:6)),:);
    day = txt(7:8);
    hour = txt(9:10);
    minute = txt(11:12);
    second = txt(13:14);
    %
    datetime = datestr(datevec([day,'-',month,'-',year,' ',hour,':',minute,':',second]));
else
    datetime = 'Error processing date/time string. Format must be a string representing a 14-digit number in format YYYYMMDDHHMMSS';
end
%


    