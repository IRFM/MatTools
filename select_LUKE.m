function select_LUKE_jd(luke_root)
%
% In interactive mode, list LUKE versions listed in the cell array 'lukeversions' and prompt user selection 
%
%
% example of startup.m file :
%

% function startup_LUKE
% %
% % Setup paths to MatRemote and MatTools toolboxes
% %
% matremote_path = '/home/joan/Work/MatRemote';
% mattools_path = '/home/joan/Work/MatTools';
% %
% addpath(matremote_path);% MatRemote toolbox
% addpath([matremote_path,filesep,'Profiles']);% remote profiles
% addpath([matremote_path,filesep,'Bridge']);% remote profiles
% addpath(mattools_path);% MatTools toolbox
% %
% lukeversions = {...
%    '/home/joan/Work/LUKE/',...
%    '/home/joan/Work/LUKE_1_10/',...
%    };
% %
% setappdata(0,'lukeversions',lukeversions)
% %
% luke_root = getenv('luke_root');
% %
% if ~isempty(luke_root),
%     %
%     select_LUKE_jd(luke_root)
%     %
% else
%     %
%     disp(' ');
%     disp('To set LUKE paths type "select_LUKE_jd;"')
%     disp(' ');
%     %
% end
% %

%
if nargin < 1,
    luke_root = 'select';
end
%
% set no path in batch mode, except if environment variable LUKE exists 
%
PBS_jobid = getenv('PBS_JOBID');
jobtimeid = getenv('jobtimeid');
%
if strcmp(luke_root,'select') && ~strcmp(getenv('MDCE_USE_ML_LICENSING'),'true') && ~isdeployed && isempty(PBS_jobid) && isempty(jobtimeid),
    %
    % select LUKE version
    %
    lukeversions = getappdata(0,'lukeversions');
    nvers = length(lukeversions);
    %
    if nvers > 0,
        lukestr = 'Which version of LUKE do you want to use : \n(0) none\n';                                                                                                                                       
        for ivers = 1:nvers,
            lukestr = [lukestr,'(',num2str(ivers),') ',lukeversions{ivers},'\n'];
        end
        lukestr = [lukestr,' [1] ? '];
        lukever = input(lukestr);
    else
        lukever = 0;
    end        
    %
    if isempty(lukever) 
        lukever = 1;
    end
    if ~isnumeric(lukever) || length(lukever) ~= 1 || ~any(lukever == 0:nvers),
        lukever = 0;
    end
    %
    if lukever > 0,
        luke_root = lukeversions{lukever};
    else
        luke_root = '';
    end
    %
end
%
if ~isempty(luke_root) && exist([luke_root,'Project_DKE/DKE'],'dir'),
    %
    addpath([luke_root,'Project_DKE/DKE']);
    setpath_luke_jd(luke_root);
    %
    disp([' Path set to ',luke_root])
    %
else
    %
    disp(' No path set to LUKE')
    %
end  
%
