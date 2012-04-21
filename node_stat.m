function [pfeat, xfeat] = node_stat(ffeat)

[pfeat,xfeat] = deal(zeros(3,13));
xfeat(1,:) = 0 : size(xfeat,2)-1;
xfeat(2,:) = 0 : 15 : 180;
xfeat(3,:) = xfeat(2,:);

nfeat = node_features(ffeat);

for f = 1 : size(nfeat,2)
   h = histc(nfeat(:,f), xfeat(f, :));
   pfeat(f, :) = h / sum(h);
end

% добавляем вероятность пустой и весячей вершин
pfeat(1, 1:2) = [eps^2 eps];
pfeat(1, :) = pfeat(1,:) / sum(pfeat(1,:));

% добавляем невстреченные углы
for i = 2 : 3
    pfeat(i, pfeat(i,:)==0) = eps;
    pfeat(i, :) = pfeat(i, :) / sum(pfeat(i, :));
end