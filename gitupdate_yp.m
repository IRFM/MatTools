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
	slashes = strfind(workpath,'/');
	folder = workpath(slashes(end)+1:end);
    %
    for igit = 1:length(gitmode),
        %
        if (strfind(gitmode{igit},'pull') | strfind(gitmode{igit},'fetch')),%for git pull or git fetch commands
            %
            new_gitmode = strrep(gitmode{igit}, '*', folder);
            %
            [res,txt{igit}] = unix(['cd ',workpath,';',new_gitmode]);
            %
        else strfind(gitmode{igit},'archive'),%for git archive command
            %
            new_gitmode = strrep(gitmode{igit}, '*', folder);
            %
            cd('..');%root folder for the updated project
            new_workpath = pwd;
            %
            [res,txt{igit}] = unix(['cd ',new_workpath,';',new_gitmode]);
            %
        end
        %
        if res == 1,
            res = 0;
        end
    end
    %
end
%
cd(wd);
%