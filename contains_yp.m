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
function indices = contains_yp(a,b)
%
% Compatibility with older matlab version
%
matlab_version = str2num(matversion_yp);
%
if matlab_version <= 901
    %
    if iscell(a)
        %
        indices = 1-cellfun('isempty',strfind(a,b));
        %
    else
        %
        indices = strfind(a,b);
        %
    end
    %
else
    %
    indices = contains(a,b);
    %
end
%