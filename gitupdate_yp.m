function [res,txt,workpath] = gitupdate_yp(gitfnc,gitmode)
%
wd = pwd;
%
if length(gitfnc) > 2 && strcmp(gitfnc(end-1:end),'.m'),%case of function within folder
    gitfnc = gitfnc(1:end-2);
    %
    workpath = fileparts(which(gitfnc));
    msg = 'No path set to function ';
else
    workpath = getenv(gitfnc);
    msg = 'The following environment variable is not set : ';
end
%
if isempty(workpath),
    res = [1,NaN];
    txt = {[msg,gitfnc],''};
else
    cd(workpath);
    [res,txt{1}] = unix(['cd ',workpath,';git ',gitmode]);
    if res == 1 && any(strfind(txt{1},[char(10),'C '])),% res = 1 because of git conflict
        res = 0;
    end
    %
    %TODO: check if necessary
    %if res == 0 && nargin >= 2 && ~isempty(gitrights),
    %    [res(2),txt{2}] = unix(gitrights);
    %else
        res(2) = NaN;
        txt{2} = '';
    %end
    
    res(3)  = NaN
    txt{3} = workpath;
end
%
cd(wd);
%