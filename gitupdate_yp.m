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
    if (strfind(gitmode,'pull') || strfind(gitmode,'fetch')),%for git pull or git fetch commands
        [res,txt{1}] = unix(['cd ',workpath,';',gitmode]);
    else,%for git archive command
        slashes = strfind(workpath,'/');
        folder = workpath(slashes(end)+1:end);
        new_gitmode = strrep(gitmode, '*', folder);
        %
        cd('..');%root folder for the updated project
        new_workpath = pwd;
        %
        [res,txt{1}] = unix(['cd ',new_workpath,';',new_gitmode]);
    end
    %
    if res == 1,
        res = 0;
    end
    %
end
%
cd(wd);
%