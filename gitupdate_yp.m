function [res,txt,folder] = gitupdate_yp(gitfnc,gitmode,remote,debugmode)
%
if nargin < 4,
    debugmode = 0;
end
%   
wd = pwd;
workpath = '';
%
if length(gitfnc) > 2 && strcmp(gitfnc(end-1:end),'.m'),%case of function within folder
    if strcmp(gitfnc,'lukegitupdate.m'),%LUKE folder 
        workpath = fileparts(which(gitfnc));
        workpath = workpath(1:end-6);%lukegitupdate.m is always in Tools subdirectory
        msg = 'No path set to function ';
    else,%any other folder
        gitfnc = gitfnc(1:end-2);
        workpath = fileparts(which(gitfnc));
        msg = 'No path set to function ';
    end
end
%
if isempty(workpath),
    res = [1,NaN];
    txt = {[msg,gitfnc],''};
else
	slashes = strfind(workpath,'/');
	folder = workpath(slashes(end)+1:end);
    %
    if isstruct(gitmode)
        gitmode_fieldnames = fieldnames(gitmode);
    else
        gitmode_fieldnames = NaN;
    end
    %
    for igit = 1:length(gitmode_fieldnames),
        %
        if isstruct(gitmode)
            gitcmd = strrep(gitmode.(gitmode_fieldnames{igit}), '*', folder);
        else
            gitcmd = strrep(gitmode, '*', folder);
        end
        %
        igitcmd = strfind(gitcmd,';');
        if ~isempty(igitcmd),
            job.remotedatapath = gitcmd(4:igitcmd(1)-1);
            job.directsearch =  1;
            %
            [res,txt{igit}] = matremotecmd(remote,job,gitcmd);
        else
            res=-1;
            txt{igit}='Error: no git cmd in remote profile';
        end
        %
        if debugmode,
             txt{igit} = [txt{igit},'----debugmode:cmd--->',gitcmd,'----debugmode:folder--->',folder,'----debugmode:workpath--->',workpath];   
        end
    end
    %
end
%
cd(wd);
%