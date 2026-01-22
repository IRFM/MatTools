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
function [flag] = test_permissions_yp(foldername)
%
if nargin == 0
    foldername = '.';
end
%
flag = 1;
%
try
    filename = ['testmatlab_',int2str(round(rand*1000000000))];
    save([foldername,'/',filename,'.mat'])
    delete([foldername,'/',filename,'.mat'])
catch
    flag = 0;
    disp(['*********** WARNING: You have no write permission to the local folder **************'])
end