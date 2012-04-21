%%varargout = myparse(array, varargin)
function varargout = myparse(array, varargin)

varargout = {};

for i = 1 : 2 : numel(varargin)
    flag = false;
    for j = 1 : 2 : numel(array)
        if strcmp(varargin{i},array{j})
            varargout = [varargout, {array{j+1}}];
            flag = true;
            break
        end
    end
    if ~flag
        varargout = [varargout, {varargin{i+1}}];
    end
end