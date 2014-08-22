function err = disperr_jd(err)
%
if isobject(err),
    %
    stack = err.stack;
    message = err.message;
    %
    nstack = length(stack);
    err = cell(1,4+nstack);
    err{1} = 'The action was cancelled due to the following error:';
    err{2} = '';
    err{3} = message;
    err{4} = '';
    for il = 1:nstack,
        err{4+il} =['In ',stack(il).file,' at line ',num2str(stack(il).line)];
    end
end
%
if nargout == 0,% display error
    %
    if ischar(err),
        disp(err);
    else
        for i = 1:length(err),
            disp(err{i});
        end
    end
end