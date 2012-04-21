function [pfeat, xfeat, good_features] = mem_stat(ffeat)

[X,Y] = mem_features(ffeat); %3,4,7

good_features = [3,4,7]; % mlen, TA intdiff, TA maxdist
% good_features = [4 6 9 11 19 21 27 29 33 35];
X = X(:,good_features);

% histograms
[pfeat, xfeat] = deal(zeros(size(X,2), 30));
for f = 1 : size(X,2)
    xfeat(f,:) = linspace(min(X(:,f)), max(X(:,f)), 30);
    hfalse = histc(X(~Y, f), xfeat(f,:));
    hfalse = hfalse / sum(hfalse);
    htrue = histc(X(Y, f), xfeat(f,:));
    htrue = htrue / sum(htrue);
%     figure,bar(xfeat(f,:), [htrue hfalse], 2.5), title(f)
%     legend('true','false')
    pfeat(f,:) = htrue ./ (htrue + hfalse);
end