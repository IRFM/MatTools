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
