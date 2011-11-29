function configuration = selectconfiguration_jd(type,dkepath)
%
% this function tests the existence of the input configuration, imports one if needed and available, 
% or otherwise returns the local configuration
%
if nargin < 2,
	dkepath = '';
end
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
	if isfield(dkepath,'scheduler') && isfield(dkepath.scheduler,type)
		configuration = importParallelConfig(dkepath.scheduler.(type));
		disp(['Importing configuration from ',dkepath.scheduler.(type),' into : ',configuration])
	else
		configuration = 'local';
		disp(['WARNING : No configuration of type ',type,' could be imported, local configuration enforced' ])
	end
end



	
