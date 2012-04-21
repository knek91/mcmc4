function [edges, pos, neg] = features2hist(X, mmark, hist_size)

[edges, pos, neg] = deal(zeros(size(X, 2), hist_size));
for i = 1 : size(X, 2)
    edges(i,:) = linspace(min(X(:, i)), max(X(:, i)), hist_size);
    
    pos(i, :) = histc(X(mmark, i)', edges(i, :));
    pos(i, :) = pos(i, :) / sum(pos(i, :));
    
    neg(i, :) = histc(X(~mmark, i)', edges(i, :));
    neg(i, :) = neg(i, :) / sum(neg(i, :));
end