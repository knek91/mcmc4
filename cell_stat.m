function [pval xval] = cell_stat(fnumbers)

S = [];
for fnumber = fnumbers
    model = read_mark(fnumber);
    model = connect_nodes(model);
    
    S = [S cell_areas(model.mtrue, model)];
end

sorted = sort(S);
border = sorted(end-numel(fnumbers)+1);
S = S(S < border);
xval = linspace(0, max(S), 15);
h = histc(S, xval);
pval = h / sum(h);

% figure, bar(xval, pval), title('cell area')