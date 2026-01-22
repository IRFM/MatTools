% 
% /////////////////////////////////////////
%
% Software name : MatTools, part of LUKE
%
% Authors : Yves Savoye-Peysson and Joan Decker
%
% Copyright holders : Commissariat a l'Energie Atomique et aux Energies Alternatives (CEA), France
%
% CEA authorizes the use of the LUKE software under the CeCILL-C open source license https://cecill.info/licences/Licence_CeCILL-C_V1-en.html
%
% The terms and conditions of the CeCILL-C license are deemed to be accepted upon downloading the software and/or exercising any of the rights granted under the CeCILL-C license.
%
% /////////////////////////////////////////
%
function save_id = timeid_jd(time_id,digits)
%
% creates a string containing the date and time information in order to
% identify a process. Can also do the inverted process
%
%
if nargin < 2,
    digits = 3;
end
%
if nargin < 1,
    time_id = clock;
end
%
if isnumeric(time_id),
    year = num2str(time_id(1) - 2000);
    month = num2str(time_id(2));
    day = num2str(time_id(3));
    hour = num2str(time_id(4));
    minute = num2str(time_id(5));
    second = num2str(fix(time_id(6)*10^digits));
    %
    if length(year) == 1,
        year = ['0',year];
    end
    if length(month) == 1,
        month = ['0',month];
    end
    if length(day) == 1,
        day = ['0',day];
    end
    if length(hour) == 1,
        hour = ['0',hour];
    end
    if length(minute) == 1,
        minute = ['0',minute];
    end
    if length(second) == 1,
        second = ['0',second];
    end
    %
    save_id = [year,month,day,hour,minute,second];
    %
elseif ischar(time_id) && any(length(time_id) >= 12),
    %
    save_id = [time_id(3:4),'/',time_id(5:6),'/20',time_id(1:2),'  ',time_id(7:8),':',time_id(9:10),':',time_id(11:12)];
    %
else
    error('Input not recognized.');
end