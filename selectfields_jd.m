function s = selectfields_jd(s,fields,mode)
%
% This function removes from s the fields that are not included in the list
% It uses rmfield so that no additional memory is used.
%
if nargin < 3,
    mode = true;
end
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
if mode && sum(sindex) > ns - nf,
    disp('WARNING : some fields were not recognized and are ignored');
end
%
s = rmfield(s,sfieldnames(sindex));