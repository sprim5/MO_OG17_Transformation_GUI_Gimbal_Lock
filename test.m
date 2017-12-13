
function test(Object)
    if nargin < 1
        disp('[ERR] Usage: test <object>');
        return
    end

    if ~isa(Object, 'struct')
        disp('[ERR] Object is not a struct');
        return
    end
end
