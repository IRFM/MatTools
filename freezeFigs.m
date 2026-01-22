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
function [varargout] = freezeFigs()
%To use with unfreezeFigs. Allows to close all figures created between the 
%run of freezeFigs and unfreezeFigs.
%
%by R.Saura CEA/DRF/IRFM/GEDS
%v.1.1  10/03/2025

hFigs = findall(0,'Type','figure');
if nargout == 1
    varargout{1} = hFigs;
else
    setappdata(0,'hKeepFigs4Frozen_RSGG',hFigs) %%Random letters to not overwrite other datas
end

end
