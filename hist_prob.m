function mpr = hist_prob(X, edges, neg, pos)

mpr = zeros(size(X, 1), 1);
for i = 1 : size(X, 1)
    plus = 1;
    for f = 1 : size(edges, 1)
        ni = find(edges(f, :) <= X(i, f), 1, 'last');
        pi = find(edges(f, :) <= X(i, f), 1, 'last');
        plus = plus * pos(f, pi) / (pos(f, pi) + neg(f, ni));
    end
    mpr(i) = plus;
end