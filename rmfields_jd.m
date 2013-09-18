function s = rmfields_jd(s,fields,rec)
%
% This function removes from s the fields that areincluded in the list
% It can be done recursively if rec is true
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
