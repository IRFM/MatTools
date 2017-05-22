function s = selectfields_jd(s,fields,mode)
%
% This function removes from s the fields that are not included in the list
% It uses rmfield so that no additional memory is used. It works
% recursively.
%
if nargin < 3
    mode = true;
end

if ~iscell(fields)
    if isempty(fields) || (isscalar(fields) && isnumeric(fields) && isnan(fields))
        return
    elseif ischar(fields)
        fields = {fields};
    else
        if mode 
            disp('WARNING : ''fields'' type not recognized, no selection applied.')
        end
        return
    end
end

% input structure fields
sfieldnames = fieldnames(s).';
ns = length(sfieldnames);
sindex = false(1,ns);

substructures = struct;

for il = 1:length(fields)
    if ~ischar(fields{il})
        if mode 
            disp(['WARNING : cell #',num2str(il),' in ''fields'' is not a string; it is ignored.'])
        end
        continue
    end
    
    % case of substructures
    isubstruct = strfind(fields{il},'.');
    if ~isempty(isubstruct)
        subfield = fields{il}(isubstruct+1:end);
        field = fields{il}(1:isubstruct-1);
    else
        subfield = '';
        field = fields{il};
    end
    
    % test for field existence in s
    is = strcmp(sfieldnames,field);
    if any(is)
        sindex(is) = true;
        
        % case of substructures
        if ~isempty(subfield)
            if ~isfield(substructures,field) % first selected subfield for this field
                substructures.(field) = {};
            end
            substructures.(field){end+1} = subfield;
        end
        
    elseif mode
        disp(['WARNING : ',field,' is not a field name of input structure; discarded.'])
    end
end

% apply to substructures recursively
subsfieldnames = fieldnames(substructures);
for isub = 1:length(subsfieldnames)
    
    subfield = subsfieldnames{isub};
    % test is corresponding field is indeed a sub-strucure
    if ~isstruct(s.(subfield))
        if mode 
            disp(['WARNING : field ',subfield,' is not a sub-structure of the input structure. Correponding subfield discarded.'])
        end
        continue
    end
    
    s.(subfield) = selectfields_jd(s.(subfield),substructures.(subfield),mode);
end
    
s = rmfield(s,sfieldnames(~sindex));
