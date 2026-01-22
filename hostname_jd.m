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
function lochostname = hostname_jd
%
% This function reads the local hostname and returns the value
%
% End of file is removed 
%
[s,lochostname] = system('hostname -f');% local hostname
%
if s ~= 0 | (s == 0 & strfind(lochostname,'localhost'))
	[s,lochostname] = system('hostname');% local hostname     
end
%
if s ~= 0
    if isempty(lochostname)
        error('local hostname could not be retrieved either from ''hostname -f'' or ''getenv(''hostname'')''');
    end
end
%
lochostname(lochostname == 10) = [];%remove EoF
