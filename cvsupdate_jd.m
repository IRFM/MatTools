function [res,txt] = cvsupdate_jd(cvsfunctions)
%
nfncs = length(cvsfunctions);
%
wd = pwd;
%
for ifnc = 1:nfncs,
    cvsfnc = cvsfunctions{ifnc};
    workpath = fileparts(which(cvsfnc));
    %
    if isempty(workpath),
        res.(cvsfnc) = 1;
        txt.(cvsfnc) = ['No path set to function ',cvsfnc,'.'];
    else
        cd(workpath);
        [res.(cvsfnc),txt.(cvsfnc)] = unix('cvs update -d -P');
    end
    %
end
%
cd(wd);
%