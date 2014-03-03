function select_LUKE_jd(lukeversions)
%
% In interactive mode, list LUKE versions listed in the cell array 'lukeversions' and prompt user selection 
%
%
% example of startup.m file :
%
%   %
%   % Setup paths to MatRemote and MatTools toolboxes
%   %
%   matremote_path = [getenv('HOME'),'/MatRemote/'];% change if needed
%   mattools_path = [getenv('HOME'),'/MatTools/'];% change if needed
%   %
%   addpath(matremote_path);% MatRemote toolbox
%   addpath([matremote_path,'Profiles/']);% remote profiles
%   addpath(mattools_path);% MatTools toolbox
%   %
%   clear matremote_path mattools_path
%   %
%   lukeversions = {...
%       '/home/JD211098/LUKE/',...
%       '/home/JD211098/LUKE_1_10/',...
%       '/home/JD211098/LUKE_CRONOS/',...
%       '/home/JD211098/LUKE_From_CRONOS/'};
%   %
%   select_LUKE_jd(lukeversions)
%   %                           
%   clear lukeversions
%   %

%
%
% set no path in batch mode, except if environment variable LUKE exists 
%
PBS_jobid = getenv('PBS_JOBID');
jobtimeid = getenv('jobtimeid');
%
if ~strcmp(getenv('MDCE_USE_ML_LICENSING'),'true') && ~isdeployed && isempty(PBS_jobid) && isempty(jobtimeid),
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
    lukestr = [lukestr,' [1] ? '];
    lukever = input(lukestr);
    %
    if isempty(lukever) 
        lukever = 1;
    end
    if ~isnumeric(lukever) || length(lukever) ~= 1 || ~any(lukever == 0:nvers),
        lukever = 0;
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
        clear luke_root
        %
    else
        %
        disp(' No path set to LUKE')
        %
    end  
    %
    clear nvers lukestr ivers lukever
    %
end
%
clear lukeversions PBS_jobid jobtimeid
