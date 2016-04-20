function [res,txt,workpath] = gitupdate_yp(gitfnc,gitmode,debugmode)
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
    gitmode_fieldnames = fieldnames(gitmode);
    %
    for igit = 1:length(gitmode_fieldnames),
        %
        [res,txt{igit}] = unix(gitmode.(gitmode_fieldnames{igit}));
        %
        if debugmode,
             txt{igit} = [txt{igit},'----debugmode:cmd--->',gitmode.(gitmode_fieldnames{igit}),'----debugmode:folder--->',folder,'----debugmode:workpath--->',workpath];   
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