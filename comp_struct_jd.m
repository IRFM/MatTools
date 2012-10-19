function totcomp = comp_struct_jd(struct1,struct2,display_mode,ignoredfieds,str1,str2)
%
if nargin < 6,
    str2 = '';
end
if nargin < 5,
    str1 = '';
end
if nargin < 4,
    ignoredfieds = {};
end
if nargin < 3,
    display_mode = 1;
end
if nargin < 2,
    error('Not enough input arguments.')
end
%
disp_jd(display_mode,' ')
%
if ~isstruct(struct1),
    f1 = struct1;
    clear struct1
    disp_jd(display_mode,'Warning: The first argument is not a structure and is defined as a field f1.');
    disp_jd(display_mode,' ')
    struct1.f1 = f1;
end
%
if ~isstruct(struct2),
    f1 = struct2;
    clear struct2
    disp_jd(display_mode,'Warning: The second argument is not a structure and is defined as a field f1.');
    disp_jd(display_mode,' ')
    struct2.f1 = f1;
end
%
if isempty(str1)
    disp_jd(display_mode,[' **** Comparison of the two structures ',inputname(1),' and ',inputname(2),' ****'])
elseif isempty(str2)
    disp_jd(display_mode,[' **** Comparison of the two structures ',str1,' ****'])
else
    disp_jd(display_mode,[' **** Comparison of the two structures ',str1,' and ',str2,' ****'])
end
%
disp_jd(display_mode,' ')
%
f1 = fieldnames(struct1);
f2 = fieldnames(struct2);
%
is_list = [];
%
for is = 1:length(f1),
    for ii = 1:length(ignoredfieds),
        if strcmp(f1{is},ignoredfieds{ii}),
            is_list = [is_list,is];
        end
    end
end
%
f1(is_list) = [];
%
is_list = [];
%
for is = 1:length(f2),
    for ii = 1:length(ignoredfieds),
        if strcmp(f2{is},ignoredfieds{ii}),
             is_list = [is_list,is];
        end
    end
end
%
f2(is_list) = [];
%
nf1 = length(f1);
nf2 = length(f2);
%
flength = 0;
%
for is = 1:nf1,
    flength = max([flength,length(f1{is})]);
end
%
for is = 1:nf2,
    flength = max([flength,length(f2{is})]);
end
%
if nf2 ~= nf1,
    disp_jd(display_mode,'Warning: The two structures have a different number of fields');
    disp_jd(display_mode,' ')
end
%
str{1} = 'identical';
str{2} = 'different value';
str{3} = 'different type/size';
str{4} = 'could not be compared';
str{5} = 'present only in structure 1';
str{6} = 'present only in structure 2';
%
totcomp = 1;
%
for is = 1:nf1,
    %
    rescomp = 0;
    info = '';
    %
    fname = f1{is};
    eval(['v1 = struct1.',fname,';']);
    %
    if ~isfield(struct2,fname),
        rescomp = 4;
    else
        %
        eval(['v2 = struct2.',fname,';']);
        %
        if ischar(v1),
            %
            if ischar(v2),
                if ~strcmp(v1,v2),
                    rescomp = 1;
                    info = ['s1 : ',v1,' ; s2 : ',v2];
                end
            else
                rescomp = 2;
            end
            %
        elseif isnumeric(v1), 
            %
            if isnumeric(v2),
                if length(size(v2)) == length(size(v1)) && all(size(v2) == size(v1)),
                    %
                    mask_NaN_v1 = isnan(v1);
                    mask_NaN_v2 = isnan(v2);
                    %
                    mask_inf_v1 = isinf(v1);
                    mask_inf_v2 = isinf(v2);
                    %
                    mask_num_v1 = ~mask_NaN_v1 & ~mask_inf_v1;
                    mask_num_v2 = ~mask_NaN_v2 & ~mask_inf_v2;
                    %
                    if any(mask_NaN_v1(:) ~= mask_NaN_v2(:)) | any(mask_inf_v1(:) ~= mask_inf_v2(:))
                        rescomp = 1;
					elseif any(v1(mask_num_v1(:)) ~= v2(mask_num_v2(:))),
                        reldiff = max(abs(v2(mask_num_v1(:)) - v1(mask_num_v1(:)))./(abs(v1(mask_num_v1(:))) + realmin));
                        absdiff = max(abs(v2(mask_num_v1(:)) - v1(mask_num_v1(:))));
                        if length(size(v1)) == 2 && all(size(v1) == [1,1]),
                            info = ['s1 : ',num2str(v1),' ; s2 : ',num2str(v2)];
                        else
                            info = [' ; maximum relative difference is : ',num2str(reldiff),', maximum absolute difference is : ',num2str(absdiff)];
                        end
                        rescomp = 1;
                    end
                else
                    rescomp = 2;
                end
            else
                rescomp = 2;
            end
            %
        elseif islogical(v1),
            %
            if islogical(v2),
                if size(v2) == size(v1),
                    %
                    if any(v1 ~= v2),
                        rescomp = 1;
                    end
                else
                    rescomp = 2;
                end
               
            else
                rescomp = 2;
            end
            %
        elseif isstruct(v1),
            %
            if isstruct(v2) 
                if ~comp_struct_jd(v1,v2,imag(display_mode),ignoredfieds),
                    rescomp = 1;
                end
            else
                rescomp = 2;
            end
            %
        elseif iscell(v1), 
            %
            if iscell(v2),
                if size(v2) == size(v1),
                    for ic = 1:numel(v1),
                        if ~comp_struct_jd(v1{ic},v2{ic},0,ignoredfieds),
                            rescomp = 1;
                            break
                        end
                    end
                else
                    rescomp = 2;
                end
            else
                rescomp = 2;
            end
            %
        else 
            rescomp = 3;
        end
    end
    %
    if rescomp > 0,
        totcomp = 0;
    end
    %
    disp_jd(display_mode,['- ',fname,repmat(' ',[1,flength - length(fname)]),' : ',str{rescomp+1},info]);
    %
end
%
for is = 1:length(f2),
    fname = f2{is};
    rescomp = 5;
    %
    if ~isfield(struct1,fname),
        totcomp = 0;
        disp_jd(display_mode,['- ',fname,' : ',str{rescomp+1}]);
    end
end
%
disp_jd(display_mode,' ')
%
if nargout == 0,
    if totcomp == 1,
        disp_jd(display_mode,'**** The two structures are identical ****')
    else
        disp_jd(display_mode,'**** The two structures are different ****')
    end
    %
    disp_jd(display_mode,' ')
end    
%
function disp_jd(display_mode,str)
%
if real(display_mode) >= 1,
    disp(str);
end
    








        