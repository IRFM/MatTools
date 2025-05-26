function [status, python_res] = pythoncmd(python_command,python_activation_cmd,python_version)
%
% LUKE - Execute Python command on the local folder within Matlab
% 
% Input :
%
%   - python_command : python command that launch python3 or python2 script [1,p]
%   - python_activation_cmd : in order to activate python script execution [1,p]
%     (default : '')
%   - python_version : 2 or 3 for python2 or python3
%     (default : 3)
%
% Output : 
%
%    - status: status of the execution of python command within matlab
%    - python_res : log of the python simulation
%
% by Y.Savoye-Peysson (CEA/DSM/IRFM) <yves.savoye-peysson@cea.fr>
%
if nargin == 0
    %
    error('Error : not enough input arguments in pythoncmd.m')
    %
end
%
if nargin == 1
    %
    python_activation_cmd = '';
    python_version = 3;
    %
end
%
if nargin == 2
    %
    python_version = 3;
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
 'Before running this PYTHON simulation, please type in a bash shell the following command: ' ...
 '''ssh YOURUSERNAME@',hostname,''' and allow it to be trusted in the ssh server list by typing ''Yes''. '...
 'This operation should be done only once on all remote computers where LUKE is supposed to be running and the local machine itself (self ssh connection). '...
 'The ''YOURUSERNAME'' may be obtained by typing the command ''whoami''.'];
%
warning_ssh1 = ['ERROR : The ssh connection to the local machine with ''localhost'' is not fully set or is broken. ' ...
 'Before running this PYTHON simulation, please type in a bash shell the following command: ' ...
 '''ssh YOURUSERNAME@localhost'' and allow it to be trusted in the ssh server list by typing ''Yes''. '...
 'This operation should be done only once on all remote computers where LUKE is supposed to be running and the local machine itself (self ssh connection). '...
 'The ''YOURUSERNAME'' may be obtained by typing the command ''whoami''.'];
%
[status, python_res] = system(['ssh ',username,'@',hostname,' "source ',python_activation_cmd,';python',int2str(python_version),' ',python_command,'" || echo "',warning_ssh,'"']);
%
if strcmp(warning_ssh,deblank(python_res))
    %
    disp(['WARNING : The ssh connection to the local machine ''ssh YOURUSERNAME@',hostname,''' is not fully set or is broken. The alternative command ''ssh YOURUSERNAME@localhost'' will be used instead to execute the python script anyway.'])
    %
    [status1, python_res1] = system(['ssh ',username,'@',hostname,' "source ',python_activation_cmd,';python',int2str(python_version),' ',python_command,'" || echo "',warning_ssh1,'"']);
    %
    if strcmp(warning_ssh1,deblank(python_res1))
        %
        error(warning_ssh);
        %
    end
    %
end
%