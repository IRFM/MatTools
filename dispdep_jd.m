function flist = dispdep_jd(matfun)
%
% displays and returns the list of matlab file dependencies;  
% ignores built-in functions
% 
% ex : >> flist = dispdep_jd('startup');
%      >> flist = dispdep_jd('startup.m');
%      >> flist = dispdep_jd('/home/joan/Documents/MATLAB/startup.m');
%
if nargin ~= 1
    error('dispdep_jd requires exactly one input argument.')
end
if ~ischar(matfun) || ~isvector(matfun) || size(matfun,1) ~= 1 || isempty(matfun),
    error('dispdep_jd input must be a char vector')
end
if exist(matfun,'file') ~= 2,
    error([' The input ''',matfun,''' does not exist or is not in the matlab path'])
end
flist = matlab.codetools.requiredFilesAndProducts(matfun);
for ilist=1:length(flist),
    disp(flist{ilist}),
end