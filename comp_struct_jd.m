function comp_struct_jd(struct1,struct2);
%
f1 = fieldnames(struct1);
f2 = fieldnames(struct2);
%
nf = length(f1);
%
if  length(f2) ~= nf,
    error('The two structures have a different number of fields');
end
%
f0 = zeros(1,nf);
%
for is = 1:nf,
    fname = f1{is};
    eval(['v1 = struct1.',fname,';']);
    eval(['v2 = struct2.',fname,';']);
    if ischar(v1),
        if ischar(v2),
            if ~strcmp(v1,v2),
                f0(is) = 1;
            end
        else
            f0(is) = 2;
        end
    elseif isnumeric(v1), 
        if isnumeric(v2),
            if size(v2) == size(v1),
                if v1 ~= v2
                    f0(is) = 1;
                end
            else
                f0(is) = 2;
            end
        else
            f0(is) = 2;
        end
    else 
        f0(is) = 3;
    end
end
%
str0 = [];
str1 = [];
str2 = [];
str3 = [];
%
for is = 1:nf,
    if f0(is) == 0,
        str0 = [str0,', ',f1{is}];
    elseif f0(is) == 1,
        str1 = [str1,', ',f1{is}];
    elseif f0(is) == 2,
        str2 = [str2,', ',f1{is}];
    elseif f0(is) == 3,
        str3 = [str3,', ',f1{is}];
    end
end
%
if ~isempty(str0),
    if isempty(str1) & isempty(str2) & isempty(str2),
        disp(['The two structures are identical']);
    else
        disp(['The fields ',str0,' are identical']);
    end
end
%
if ~isempty(str1),
    disp(['The fields ',str1,' are different']);
end
%
if ~isempty(str2),
    disp(['The fields ',str2,' are of different type']);
end
%
if ~isempty(str3),
    disp(['The fields ',str3,' were not compared']);
end
    








        