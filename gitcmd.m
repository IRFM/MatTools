function [git_res,active_branch,branches,workpath] = gitcmd(git_command,workpath)
%
% LUKE - Execute a git command on the local folder.  
% 
% Input :
%
%   - git_command : git command [1,p]
%     (default : 'git status')
%   - workpath : considered folder [1,p]
%     (default : pwd)
%
% Output : 
%
%    - git_res : output of the git command
%    - active_branch : active git branch
%    - branches : list of the git branches
%    - workpath : working folder
%
% by Y.Savoye-Peysson (CEA/DSM/IRFM) <yves.savoye-peysson@cea.fr>
%
if nargin <= 1
    %
    git_command = 'git status';
    %
    folderlist = strsplit(pwd,'/');
    %
    workpath = ['/',folderlist{2},'/',folderlist{3}];
    %
    for jj = 4:length(folderlist)
        %
        workpath = [workpath,'/',folderlist{jj}];
        %
        if exist([workpath,'/.git'])
            %
            break
            %
        end
        %
    end
    %
    git_command = 'git status';
    %
end
%
if isempty(git_command)
    %
    git_command = 'git status';
    %
end
%

[status, username] = unix('whoami');%local username
username = deblank(username);
%
[status, hostname] = unix('hostname');%local hostname
hostname = deblank(hostname);
hostname1 = strsplit(hostname,'.');
hostname = hostname1{1};%first term for local connection 
%
warning_ssh = ['ERROR : The ssh connection to the local machine whose hostname is ''',hostname,''' is not fully set or is broken. ' ...
 'Before running this simulation, please type in a bash shell the following command: ' ...
 '''ssh YOURUSERNAME@',hostname,''' and allow it to be trusted in the ssh server list by typing ''Yes''. '...
 'This operation should be done only once on all remote computers where LUKE is supposed to be running and the local machine itself (self ssh connection). '...
 'The ''YOURUSERNAME'' may be obtained by typing the command ''whoami''.'];
%
if exist([workpath,'/.git'])
    %
    [status, git_res] = system(['timeout 10 ssh ',username,'@',hostname,' "cd ',workpath,';',git_command,'" || echo "',warning_ssh,'"']);
    %
    if strcmp(warning_ssh,deblank(git_res))
        %
        error(warning_ssh);
        %
    end
    %
    [status, cmdout] = system(['timeout 10 ssh ',username,'@',hostname,' "cd ',workpath,';git branch" || echo "',warning_ssh,'"']);
    %
    if strcmp(warning_ssh,deblank(cmdout))
        %
        error(warning_ssh);
        %
    end
    %
    branches = strsplit(deblank(cmdout),newline);
    %
    active_branch = [];
    %
    for ib = 1:length(branches)
        %
        branches{ib} = strtrim(branches{ib});
        %
        if strfind(branches{ib},'*')
            %
            active_branch = branches{ib}(3:end);
            branches{ib} = active_branch;
            %
        end
        %
    end
    %
else
    %
    disp(['The folder ''',workpath,''' is not under Git control. The branch cannot be determined.'])
    %
    git_res = [];
    active_branch = [];
    branches = [];
    %
end