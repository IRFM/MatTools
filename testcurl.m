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
function [flag,curl] = testcurl(cmd)
%
flag = 0;
%
[res,txt] = unix('which curl');%test if curl lib is available
%
if ~res && ~isempty(strfind(txt,'curl')),%test if the command is available in curl 
    %
    [res,txt] = unix('curl -V');
    %
    txt = regexp(txt, '[\f\n\r]', 'split');
    %
    curl.version = txt{1};
    curl.protocols = txt{2};
    curl.features = txt{3};
    %
    if ~isempty(strfind(txt{2},cmd)),
        flag = 1;
    end
else
    curl = '';
end