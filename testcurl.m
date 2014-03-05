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