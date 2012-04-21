function val = adj2val(adj, edges)

if isnumeric(adj)
    val = zeros(size(edges,1),1);
else
    val = false(size(edges,1),1);
end

for j = 1 : numel(val)
    val(j) = adj(edges(j,1),edges(j,2));
end