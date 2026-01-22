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