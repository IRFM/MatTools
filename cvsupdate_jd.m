function [res,txt,workpath] = cvsupdate_jd(cvsfnc)
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
    res= 1;
    txt = [msg,cvsfnc];
else
    cd(workpath);
    [res,txt] = unix('cvs update -d -P');
    if res == 1 && any(strfind(txt,[char(10),'C '])),% res = 1 because of cvs conflict
        res = 0;
    end
end
%
cd(wd);
%