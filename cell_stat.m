function [pval xval] = cell_stat(fnumbers)

S = [];
V = [];
for fnumber = fnumbers
    model = read_mark(fnumber);
    model = connect_nodes(model);
    
    [s v] = cell_areas(model.mtrue, model);
    S = [S s];
    V = [V v];
end

sorted = sort(S);
border = sorted(end - numel(fnumbers) + 1);
I = S < border;
S = S(I);
V = V(I);

hist_size = 15;
[xval, pval] = deal(zeros(2, hist_size));

% area
xval(1,:) = linspace(0, max(S), hist_size);
h = histc(S, xval(1,:));
pval(1,:) = h / sum(h);

% node number
xval(2,:) = min(V) : max(max(V), hist_size + min(V) - 1);
h = histc(V, xval(2,:));
pval(2,:) = h / sum(h);