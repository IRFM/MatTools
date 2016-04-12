function totcomp = comp_struct_yp(structname,struct1,struct2,display_mode)
%
totcomp = 0;
%
struct1_fieldnames = fieldnames(struct1);
struct2_fieldnames = fieldnames(struct2);
%
for istruct1 = 1:length(struct1_fieldnames),
    temp1 = struct1.(struct1_fieldnames{istruct1});
    temp2 = struct2.(struct2_fieldnames{istruct1});
    %
    if ~isstruct(temp1) &&  ~isstruct(temp2)
        if length(temp1) ~= length(temp2)
           totcomp = totcomp + 1;
            if display_mode,
                disp(['**** ',structname,'.',struct1_fieldnames{istruct1},': different value ****']);
            end 
        else
            if strcmp(temp1,temp2) | temp1==temp2,
                if display_mode,
                    disp(['- ',structname,'.',struct1_fieldnames{istruct1},': identical']);
                end
            else
                totcomp = totcomp + 1;
                if display_mode,
                    disp(['**** ',structname,'.',struct1_fieldnames{istruct1},': different value ****']);
                end
            end
        end
    elseif (isstruct(temp1) &&  ~isstruct(temp2)) || (~isstruct(temp1) &&  isstruct(temp2))
            totcomp = totcomp + 1;
            if display_mode,
                disp(['**** ',structname,'.',struct1_fieldnames{istruct1},': different value ****']);
            end
    else
        %
        temp_struct0 = struct1.(struct1_fieldnames{istruct1});
        temp_struct1 = struct2.(struct1_fieldnames{istruct1});
        %
        for itemp_struct0 = 1:length(temp_struct0),
            %
            whos_temp_struct0 = whos('temp_struct0');
            whos_temp_struct1 = whos('temp_struct1');
            %
            totcomp = totcomp + comp_struct_yp([structname,'.',struct1_fieldnames{istruct1},'(',int2str(itemp_struct0),')'],temp_struct0(itemp_struct0),temp_struct1(itemp_struct0),display_mode);
            %
        end
    end
end
%