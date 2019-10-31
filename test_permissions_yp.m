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