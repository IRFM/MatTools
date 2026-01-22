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
function configuration = selectconfiguration_jd(type,configurations)
%
% this function tests the existence of the input configuration, imports one if needed and available, 
% or otherwise returns the local configuration
%
if nargin < 2,
	configurations = struct;
end
if nargin < 1,
	type = 'local';
end
%
[matlab_version,matlab_release,flag_toolbox] = matversion_yp;
%
if str2double(matlab_version) <= 801 && str2double(matlab_release(2:end-1)) < 2023,%used until matlab R2013a
    try
        [~,configs] = defaultParallelConfig;% configurations present in user preferences file (old syntax)
    catch
        
    end
else
    try
        configs = {parallel.defaultClusterProfile};% configurations present in user preferences file
    catch
        
    end
end
%
nconfs = length(configs);
%
% test if type is an existing configuration among imported configurations
%
if strcmp(type,'local')
    %
    iconfig = find(strcmp(configs,type));%old syntax
    %
    if ~isempty(iconfig)
        return
    else
        iconfig = find(strcmp(configs,'Processes'));%new syntax
    end
    %
end
%
if ~isempty(iconfig),
    configuration = configs{iconfig};
    disp(['Configuration selected : ',configuration])
    return
end
%
% test if type is an existing type among imported configurations
%
isoftype = zeros(1,nconfs);
%
for iconf = 1:nconfs,
    try
        scheduler = findResource('scheduler','configuration',configs{iconf});
        isoftype(iconf) = strcmpi(scheduler.Type,type);
    catch err
        disp(['Impossible to find ressources for Imported configuration ',dkecluster.scheduler.configuration,...
        ' because of the following error : ',err.message,'.']);
    end
end
%
isoftype = find(isoftype);%indices for imported configurations with scheduler.Type = type 
%
if length(isoftype) > 1,
    configuration = configs{isoftype(1)};
    disp(['WARNING : Several configuration of type ',type,' found, first configuration selected : ',configuration])
    return
elseif length(isoftype) == 1,
    configuration = configs{isoftype};
    disp(['Configuration of type ',type,' selected : ',configuration])
    return
end
%
disp(['No configuration with name or type ',type,' found among imported configurations'])
%
% Test if type is an existing configuration among input configurations
% 
configs = fieldnames(configurations);
%
nconfs = length(configs);
%
iconfig = find(strcmp(configs,type));
%
if ~isempty(iconfig),
    configuration = importParallelConfig(configurations.(configs{iconfig}));
    disp(['Importing configuration from ',configurations.(configs{iconfig}),' into : ',configuration])
    return
end
%
% Test if type is an existing type among those input configurations 
%
isoftype = zeros(1,nconfs);
%
for iconf = 1:nconfs,
    if exist(configurations.(configs{iconf}),'file'),
        data = load(configurations.(configs{iconf}));
        isoftype(iconf) = strcmpi(data.Values.findResource,type);
    end
end
%
isoftype = find(isoftype);%indices for imported configurations with scheduler.Type = type 
%
if length(isoftype) > 1,
    configuration = importParallelConfig(configurations.(configs{isoftype(1)}));
    disp(['WARNING : Several configuration of type ',type,' found, Importing configuration from ',configurations.(configs{iconfig}),' into : ',configuration])
    return
elseif length(isoftype) == 1,
    configuration = importParallelConfig(configurations.(configs{isoftype}));
    disp(['Importing configuration from ',configurations.(configs{iconfig}),' into : ',configuration])
    return
end
%
disp(['WARNING : No configuration of type ',type,' could be found or imported, ''local'' configuration enforced.' ])
% 
configuration = 'local';
%


	
