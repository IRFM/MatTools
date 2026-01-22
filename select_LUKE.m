% 
% /////////////////////////////////////////
%
% Software name : MatTools, part of LUKE
%
% Authors : Yves Savoye-Peysson and Joan Decker
%
% Copyright holders : Commissariat a l'Energie Atomique et aux Energies Alternatives (CEA), France
%
% CEA authorizes the use of the LUKE software under the CeCILL-C open source license https://cecill.info/licences/Licence_CeCILL-C_V1-en.html
%
% The terms and conditions of the CeCILL-C license are deemed to be accepted upon downloading the software and/or exercising any of the rights granted under the CeCILL-C license.
%
% /////////////////////////////////////////
%
function select_LUKE(luke_root,link_mode,display_mode,lukemenu_mode)
%
% luke_root can be :  
%
% - empty or 'select' : prompt LUKE version from list in getappdata(0,'lukeversions');
% - a path to LUKE    : set path to the corresponding LUKE version
%
%   - link_mode : connection mode prescription
%       o -2  : disable remote profiles
%       o -1  : local profiles only
%       o NaN : (default) use value from remote.link_mode
%       o []  : give priority to (0) ssh key pair, (1) ssh bridge, (2) url/ftp bridge
%       o 0   : ssh key pair enforced
%       o 1   : ssh bridge enforced
%       o 2   : url/ftp bridge enforced
%

%
% example of startup.m file :
%

% function startup_LUKE
% %
% % Setup paths to MatRemote, MatTools and MatHelp toolboxes
% %
% matremote_path = 'pathtoMatRemote/MatRemote';
% mattools_path = 'pathtoMatTools/MatTools';
% mattools_path = 'pathtoMatHelp/MatHelp';
% %
% addpath(matremote_path);% MatRemote toolbox
% addpath([matremote_path,filesep,'Profiles']);% remote profiles
% addpath([matremote_path,filesep,'Bridge']);% remote profiles
% addpath(mattools_path);% MatTools toolbox
% addpath(mathelp_path);% MatHelp toolbox
% addpath([mathelp_path,filesep,'m2html']);% m2html toolbox
% %
% lukeversions = {...
%    'pathtoLUKE/LUKE/',...
%    };
% %
% setappdata(0,'lukeversions',lukeversions)
% %
% luke_root = getenv('luke_root');%prescribed by remote computing
% %
% LUKE = getenv('LUKE');%prescribed by environement
%
% link_mode = getenv('luke_link_mode');%prescribed by remote computing
% if ~isempty(link_mode),
%     if strcmp(link_mode,'[]'),
%         link_mode = [];
%     else
%         link_mode = str2double(link_mode);
%     end
% elseif ~isempty(luke_root),
%     link_mode = -1;% local profiles only; no second level remote computing unless prescribed by luke_link_mode
% else
%     link_mode = NaN;% default value, select link_mode prescribed by remote profiles
% end
% %
% if ~isempty(luke_root),
%     %
%     select_LUKE(luke_root,link_mode)
%     %
% elseif ~isempty(LUKE),
%     %
%     select_LUKE(LUKE,link_mode)
%     %
% else
%     %
%     disp(' ');
%     disp('To set LUKE paths type "select_LUKE_jd;"')
%     disp(' ');
%     %
% end
%
%
if nargin < 4,
    lukemenu_mode = 1;
end
if nargin < 3,
    display_mode = 0;
end
if nargin < 2,
    link_mode = NaN;
end
if nargin < 1,
    luke_root = 'select';
end
%
testremote_mode = 0;
%
% set no path in batch mode, except if environment variable LUKE exists 
%
PBS_jobid = getenv('PBS_JOBID');
jobtimeid = getenv('jobtimeid');
%
inter_mode = ~strcmp(getenv('MDCE_USE_ML_LICENSING'),'true') && ~isdeployed && isempty(PBS_jobid) && isempty(jobtimeid);% interactive mode
%
if strcmp(luke_root,'select') && inter_mode,
    %
    % select LUKE version
    %
    lukeversions = getappdata(0,'lukeversions');
    nvers = length(lukeversions);
    %
    if nvers > 0,
        lukestr = 'Which version of LUKE do you want to use : \n[0] none\n';                                                                                                                                       
        for ivers = 1:nvers,
            lukestr = [lukestr,'[',num2str(ivers),'] ',lukeversions{ivers},'\n'];
        end
        lukever = input_dke_yp(lukestr,1,0:nvers);
    else
        lukever = 0;
    end        
    %
    if lukever > 0,
        luke_root = lukeversions{lukever};
        %
        % select link mode
        %
        if exist([luke_root,'Project_DKE/DKE'],'dir') && lukemenu_mode,
            disp(' ')
            link_modes = {NaN,-2,-1,[],0,1,2};
            link_mode_options = input_dke_yp(['Select remote calculations capabilities (link mode) :\n',...
                '[1] all profiles according to remote.link_mode (link mode=NaN)\n',...
                '[2] no remote computing (link mode=-2)\n',...
                '[3] only local profiles (link mode=-1)\n',...
                '[4] all profiles trying ssh, ssh+ssh and ssh+php in order (link mode=[])\n',...
                '[5] only profiles available via direct ssh (link mode=0)\n',...
                '[6] only profiles available via ssh+ssh (link mode=1)\n',...
                '[7] only profiles available via ssh+php (link mode=2)\n'],1,1:7);
            link_mode = link_modes{link_mode_options};
            %
            disp(' ');
            testremote_mode = input_dke_yp('Test all remote connections (0) no, (1) yes',0,0:1);
            if testremote_mode,
                testremote_mode1 = input_dke_yp('Test connection speed (upload and download) (0) no, (1) yes',0,0:1);
                if testremote_mode1,
                    testremote_mode = 2;
                end
            end 
            %
        end
    else
        luke_root = '';
    end
    %    
end
%
if ~isempty(luke_root) && ~strcmp(luke_root(end),filesep),
    luke_root = [luke_root,filesep];
end
%
if ~isempty(luke_root) && exist([luke_root,'Project_DKE/DKE'],'dir') && lukemenu_mode,
    %
    addpath([luke_root,'Project_DKE/DKE']);
    %
    disp(' ');
    %
    setpath_luke_jd(luke_root,link_mode,testremote_mode,display_mode,inter_mode);
    %
    disp([' --> Path set to ',luke_root])
    %
    if ~isempty(getenv('LUKE_MENU')) && inter_mode && lukemenu_mode,%put the line setenv('LUKE_MENU','yes'); before the line startup_LUKE;
        startup_LUKE_yp(luke_root);
    end
    %
    sep = strfind(luke_root,'/');
    luke_branch = luke_root(sep(end-1)+1:sep(end)-1);
    %
    disp(' ');
    disp('-------------------------------------------------------------------------------------------')
    disp('IMPORTANT: For tutorial, wiki, news, user forum, repository status, bug tracking related to ')
    disp('any Git branch of LUKE, MatRemote, MatTools and MatHelp toolboxes, please go to the Forgejo')
    disp('git project manager at the web address: https://forgejo.yvespeysson.fr')
    disp('-------------------------------------------------------------------------------------------')
    %
    disp(' --> To start single time simulation, run ''irunluke_jd'' in the command window')
    disp(' --> To start the simulation with script, run ''sluke'' in the command window')
    disp(' --> To start multitime simulation, run ''iluke'' in the command window')
    %
    if length(luke_project) > 0
        disp([' --> Move to ~/',luke_project,'/Simulations/Benchmarks/ to run simple test scripts'])
        disp([' --> Move to ~/',luke_project,'/Simulations/Examples/ to run complex test scripts'])
    else
        disp(' --> Move to ~/LUKE_XXX/Simulations/Benchmarks/ to run simple test scripts')
        disp(' --> Move to ~/LUKE_XXX/Simulations/Examples/ to run complex test scripts')
    end
    %
    % Set local git branch if defined in dkepath
    %
    dkepath = load_structures_yp('dkepath','','');
    %
    disp('-------------------------------------------------------------------------------------------')
    %
    if exist('.git')
        %
        if isfield(dkepath,'luke_gitbranch')
            %
            if ~isempty(dkepath.luke_gitbranch)
                %
                disp('---> The active git branch is enforced as defined in dkepath.luke_gitbranch.');
                %
            else
                %
                 disp('---> The active git branch is not defined in dkepath or dkepath.luke_gitbranch is empty.');
                %
            end
            %
            [git_res,active_branch,branches,workpath] = gitcmd(['git checkout ',dkepath.luke_gitbranch]);
            %
        end
        %
        [git_res,active_branch,branches,workpath] = gitcmd;
        disp(['---> Active git branch : ',active_branch]);
        %
        disp('-------------------------------------------------------------------------------------------')
        %
    else
        %
        disp(['WARNING : There is no .git file in the folder ''',luke_root,'''. The folder is not under Git version control.'])
    end
    %
else
    %
    disp(' --> No path set to LUKE')
    %
end  
%
