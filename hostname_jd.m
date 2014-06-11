function lochostname = hostname_jd
%
% This function reads the local hostname and returns the value
%
% End of file is removed 
%
[s,lochostname] = system('hostname -f');% local hostname
%
if s ~= 0,
	[s,lochostname] = system('hostname');% local hostname    
end
%
if s ~= 0,
    lochostname = getenv('hostname');%For remote computing (xgrid)
    if isempty(lochostname),
        error('local hostname could not be retrieved either from ''hostname -f'' or ''getenv(''hostname'')''');
    end
end
%
lochostname(lochostname == 10) = [];%remove EoF
