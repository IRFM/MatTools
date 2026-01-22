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
function struct_out = conc_struct_jd(struct1,struct2)
%
% This function concatenates two structures into one. In case of doublons,
% the value from struct2 is kept. 
%
% by J. Decker (CEA/DRFC, joan.decker@cea.fr) and Y. Peysson (CEA/DRFC,yves.peysson@cea.fr)
%
if nargin == 1,
    struct_out = struct1;
else
    if ~isstruct(struct1) || ~isstruct(struct2),
        struct_out = struct2;
    else
        f1 = fieldnames(struct1);
        f2 = fieldnames(struct2);
        %
        cell1 = struct2cell(struct1);
        cell2 = struct2cell(struct2);
        %
        for if1 = 1:length(f1),
            for if2 = 1:length(f2),
                if strcmp(f1{if1},f2{if2}),
                    cell1{if1} = conc_struct_jd(cell1{if1},cell2{if2});
                    cell2(if2) = [];
                    f2(if2) = [];
                    break
                end
            end
        end
        %
        cell_out = {cell1{:},cell2{:}};
        f_out = {f1{:},f2{:}};
        struct_out = cell2struct(cell_out,f_out,2);
    end
end

