function supertitle(a,b,c)
%
%compatibility with old matlab versions
%
if exist('sgtitle')
    %
    if nargin == 3 && ~isempty(b) && ~isempty(c)
        %
        sgtitle(sprintf([a,'\nURx: upper row index, LRx: lower row index, Mx: module numbering, Ax: ALOHA numbering']),b,c);
        %
    else
        %
        sgtitle(sprintf([a,'\nURx: upper row index, LRx: lower row index, Mx: module numbering, Ax: ALOHA numbering']));
        %
    end
    %
elseif exist('suptitle')
    %
    suptitle(sprintf([a,'\nURx: upper row index, LRx: lower row index, Mx: module numbering, Ax: ALOHA numbering']));
    %
end