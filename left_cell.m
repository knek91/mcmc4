function [f nodes] = left_cell(n, mcur, model, ignore)

if nargin == 3
    ignore = false(size(model.mtrue));
end

first = n;
nodes = n(1);
while ~ignore(n(1),n(2))
    neig = find(mcur(n(2),:));
    X = model.x(neig) - model.x(n(2));
    Y = model.y(neig) - model.y(n(2));
    a = angle(X + Y*1i);
    a = a - a(neig == n(1));
    a = mod(2 * pi + a, 2 * pi);
    [maxv,maxi] = max(a);
    if maxv == 0 
        break
    end
    n = [n(2) neig(maxi)];
    nodes = [nodes n(1)];
    if all(first == n)
        break
    end
end

if numel(nodes) > 3 && nodes(end) == nodes(1)
    f = polyarea(model.x(nodes), model.y(nodes));
else
    f = nan;
end

end