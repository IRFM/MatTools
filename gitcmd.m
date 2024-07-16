function [git_res,branches,workpath] = gitcmd(git_command)
%
% LUKE - Execute a git command on the local folder.  
% 
% Input :
%
%   - git_command : git command [1,p]
%     (default : 'git status')
%
% Output : 
%
%    - git_res : output of the git command
%    - branches : list of the git branches
%    - workpath : working folder
%
% by Y.Savoye-Peysson (CEA/DSM/IRFM) <yves.savoye-peysson@cea.fr>
%
if nargin == 0
    %
    git_command = 'git status';
    %
end
%
workpath = pwd;
%
[status, username] = unix('whoami');%local username
username = deblank(username);
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