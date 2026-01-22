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
function [res,txt,workpath] = cvsupdate_jd(cvsfnc,cvsrights)
%
wd = pwd;
%
if length(cvsfnc) > 2 && strcmp(cvsfnc(end-1:end),'.m'),%case of function within folder
    cvsfnc = cvsfnc(1:end-2);
    %
    workpath = fileparts(which(cvsfnc));
    msg = 'No path set to function ';
else
    workpath = getenv(cvsfnc);
    msg = 'The following environment variable is not set : ';
end
%
if isempty(workpath),
    res = [1,NaN];
    txt = {[msg,cvsfnc],''};
else
    cd(workpath);
    [res,txt{1}] = unix('cvs update -d -P');
    if res == 1 && any(strfind(txt{1},[char(10),'C '])),% res = 1 because of cvs conflict
        res = 0;
    end
    if res == 0 && nargin >= 2 && ~isempty(cvsrights),
        [res(2),txt{2}] = unix(cvsrights);
    else
        res(2) = NaN;
        txt{2} = '';%%
    end
end
%
cd(wd);
%
