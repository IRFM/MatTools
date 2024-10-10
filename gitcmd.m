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
%
if exist([workpath,'/.git'])
    %
    [status, git_res] = system(['ssh ',username,'@localhost "cd ',workpath,';',git_command,'"']);
    %
    [status, cmdout] = system(['ssh ',username,'@localhost "cd ',workpath,';git branch"']);
    branches = strsplit(deblank(cmdout),'\n');
    %
    branches = strsplit(deblank(cmdout),'\n');
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