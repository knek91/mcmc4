function adj = val2adj(val, edges, N)

if islogical(val)
	adj = false(N,N);
else
	adj = zeros(N,N);
end

for i = 1 : size(edges,1)
    adj(edges(i,1),edges(i,2)) = val(i);
end

if islogical(val)
	adj = adj | adj';
else
	adj = adj + adj';
end