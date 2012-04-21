function adj = edges2adj(edges,N)

adj = false(N);
for i = 1 : size(edges,1)
    adj(edges(i,1),edges(i,2)) = true;
    adj(edges(i,2),edges(i,1)) = true;
end