function supertitle(a,b,c)
%
%compatibility with old matlab versions
%
if exist('sgtitle')
    %
    sgtitle(sprintf([h1.Name,'\nURx: upper row index, LRx: lower row index, Mx: module numbering, Ax: ALOHA numbering']),b,c);
    %
elseif exist('suptitle')
    %
    suptitle(sprintf([h1.Name,'\nURx: upper row index, LRx: lower row index, Mx: module numbering, Ax: ALOHA numbering']));
    %
end