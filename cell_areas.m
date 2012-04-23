function [S V border] = cell_areas(mcur, model, ignore)

if nargin == 2
    ignore = false(size(model.mtrue));
end

border = false(size(model.mtrue));

S = [];
V = []; 

visited = true(size(model.mtrue));
visited(mcur) = false;
mlist = adj2val(mcur, model.edges);

% figure,show_lines(model,model.mtrue)

for j = find(mlist)'

    n = model.edges(j,:);
    nodes = n(1);
    while ~visited(n(1),n(2)) && ~ignore(n(1),n(2))
        visited(n(1),n(2)) = true;
        neig = find(mcur(n(2),:));
        X = model.x(neig) - model.x(n(2));
        Y = model.y(neig) - model.y(n(2));
        a = angle(X + Y*1i);
        a = a - a(neig == n(1));
        a = mod(2 * pi + a, 2 * pi);
        [~,maxi] = max(a);
        n = [n(2) neig(maxi)];
        nodes = [nodes n(1)];
    end

    if numel(nodes) > 3 && nodes(end) == nodes(1)
        s = polyarea(model.x(nodes), model.y(nodes));
        S = [S s];
        V = [V numel(nodes)-1];
        
        border_area = 10000;
        if nargout == 3 && s > border_area % consider S > border_area as a border
            for n = 1 : numel(nodes)-1
                border(nodes(n),nodes(n+1)) = true;
            end
        end
    end
end