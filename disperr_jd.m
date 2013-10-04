function disperr_jd(err)
%
if ischar(err),
    disp(err);
else
    for i = 1:length(err),
        disp(err{i});
    end
end