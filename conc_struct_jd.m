function struct_out = conc_struct_jd(struct1,struct2);
%
% This function concatenates two structures into one
%
f1 = fieldnames(struct1);
f2 = fieldnames(struct2);
%
cell1 = struct2cell(struct1);
cell2 = struct2cell(struct2);
%
cell_out = {cell1{:},cell2{:}};
f_out = {f1{:},f2{:}};
struct_out = cell2struct(cell_out,f_out,2);

