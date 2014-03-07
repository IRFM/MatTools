function select_LUKE_jd(lukeversions)
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
% select_LUKE = getenv('select_LUKE');
% %
% if strcmp(getenv('select_LUKE'),'yes'),
%     %
%     select_LUKE_jd(lukeversions)
%     %
% elseif ~isempty(select_LUKE),
%     %
%     select_LUKE_jd(select_LUKE)
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
    lukeversions = getappdata(0,'lukeversions');
end
%
%
% set no path in batch mode, except if environment variable LUKE exists 
%
PBS_jobid = getenv('PBS_JOBID');
jobtimeid = getenv('jobtimeid');
%
if ~strcmp(getenv('MDCE_USE_ML_LICENSING'),'true') && ~isdeployed && isempty(PBS_jobid) && isempty(jobtimeid),
    %
    if ischar(lukeversions),% case of specific directory
        %
        if exist(lukeversions,'dir'),
            lukeversions = {lukeversions};
            lukever = 1;
        else
            lukever = 0;
        end
        %        
    else% case of a list of LUKE directories
        %
        % test if directory exists
        %
        nvers = length(lukeversions);
        flag = false(1,nvers);
        for ivers = 1:length(lukeversions),
            if exist(lukeversions{ivers},'dir'),
                flag(ivers) = true;
            end
        end
        %
        lukeversions = lukeversions(flag);
        %
        nvers = length(lukeversions);
        %
        lukestr = ['Which version of LUKE do you want to use : \n',...                                                                                          
            '(0) none\n'];                                                                                                                                       
        for ivers = 1:nvers,
            lukestr = [lukestr,'(',num2str(ivers),') ',lukeversions{ivers},'\n'];
        end
        %
        if nvers > 0,
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
    end
    %
    if lukever > 0,
        %
        %%%%%%%%%%%%%%%%%%%BEGIN-LUKE-PATH%%%%%%%%%%%%%%%%%%%
        luke_root = lukeversions{lukever};
        addpath([luke_root,'Project_DKE/DKE']);
        setpath_luke_jd(luke_root);
        %%%%%%%%%%%%%%%%%%%%END-LUKE-PATH%%%%%%%%%%%%%%%%%%%%
        %
        disp([' Path set to ',luke_root])
        %
    else
        %
        disp(' No path set to LUKE')
        %
    end  
end
%
