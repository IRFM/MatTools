function configuration = selectconfiguration_jd(scheduler,type)
%
% this function tests the existence of the input configuration, imports one if needed and available, 
% or otherwise returns the local configuration
%
if nargin < 2,
	type = 'local';
end
%
if ~isempty(scheduler.configfile),
    configuration = importParallelConfig(scheduler.configfile);
    disp(['Importing configuration from ',scheduler.configfile,' into : ',configuration])
else
    %    
    [~,configs] = defaultParallelConfig;
    %
    nconfs = length(configs);
    isoftype = zeros(1,nconfs);
    %
    for iconf = 1:nconfs,
        scheduler = findResource('scheduler','configuration',configs{iconf});
        isoftype(iconf) = strcmpi(type,scheduler.Type);
    end
    %
    isoftype = find(isoftype);
    %
    if length(isoftype) > 1,
        configuration = configs{isoftype(1)};
        disp(['WARNING : Several configuration of type ',type,' found, first configuration selected : ',configuration])
    elseif length(isoftype) == 1,
        configuration = configs{isoftype};
        disp(['Configuration selected : ',configuration])
    else
        disp(['No configuration of type ',type,' found in user database'])
        configuration = 'local';
        disp(['WARNING : No configuration of type ',type,' could be imported, local configuration enforced' ])
    end
end



	
