function [res,txt] = cvsupdate_jd(cvsfunctions)
%
nfncs = length(cvsfunctions);
%
wd = pwd;
%
for ifnc = 1:nfncs,
    cvsfnc = cvsfunctions{ifnc};
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
        res.(cvsfnc) = 1;
        txt.(cvsfnc) = [msg,cvsfnc];
    else
        cd(workpath);
        [res.(cvsfnc),txt.(cvsfnc)] = unix('cvs update -d -P');
        if res.(cvsfnc) == 1 && any(strfind(txt.(cvsfnc),[char(10),'C '])),% res = 1 because of cvs conflict
            res.(cvsfnc) = 0;
        end
    end
    %
end
%
cd(wd);
%