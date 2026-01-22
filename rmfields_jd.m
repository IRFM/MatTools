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
function s = rmfields_jd(s,fields,rec)
%
% This function removes from s the fields that areincluded in the list
% It can be done recursively if rec is true
%
if nargin < 3,
    rec = false;
end
%
sfieldnames = fieldnames(s);
%
if ischar(fields),
    fields = {fields};
end
fields = fields(:).';
%
mask = any(strcmp(repmat(sfieldnames,[1,length(fields)]),repmat(fields,[length(sfieldnames),1])));
%
s = rmfield(s,fields(mask));
%
if rec,
    %
    sfieldnames = fieldnames(s);
    %
    for ifield = 1:length(sfieldnames),
        sfieldname = sfieldnames{ifield};
        if isstruct(s.(sfieldname)),
            s.(sfieldname) = rmfields_jd(s.(sfieldname),fields,rec);
        end
    end
end
