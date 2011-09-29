function s = selectfields_jd(s,fields)
%
% This function removes from s the fields that are not included in the list
% It uses rmfield so that no additional memory is used.
%
sfieldnames = fieldnames(s).';
%
ns = length(sfieldnames);
nf = length(fields);
%
sindex = true(1,ns);
%
for il = 1:nf,
    sindex = sindex & ~strcmp(sfieldnames,fields{il});
end
%
if sum(sindex) > ns - nf,
    disp('WARNING : some fields were not recognized and are ignored');
end
%
s = rmfield(s,sfieldnames(sindex));