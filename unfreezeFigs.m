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
function unfreezeFigs(varargin)
%To use with freezeFigs. Allows to close all figures created between the 
%run of freezeFigs and unfreezeFigs.
%
%by R.Saura CEA/DRF/IRFM/GEDS
%v.1.2  10/03/2025

if nargin == 1
    hFigOld = varargin{1}; 
else
    if  ~isappdata(0,'hKeepFigs4Frozen_RSGG')
        disp('Use freezeFigs without output variables before using unfreezeFigs without input variables');
        return
    else
        hFigOld = getappdata(0,'hKeepFigs4Frozen_RSGG');
    end
    rmappdata(0,'hKeepFigs4Frozen_RSGG')
end

hFigCurr = findall(0,'Type','figure');

iOld = ismember(hFigCurr,hFigOld);  
close( hFigCurr(~iOld) );
end

