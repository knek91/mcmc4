%% membranes features
fnumbers = 1;
[X,mmark,names] = mem_features(fnumbers);
Y = zeros(size(mmark));
Y(mmark) = 1;
Y(~mmark) = -1;

%% lasso (http://www.di.ens.fr/~mschmidt/Software/lasso.html)

w = LassoIteratedRidge(X, double(Y), 2);

%% print features weights
for i = 1 : numel(w)
    if w(i) > 0
        fprintf('%50s\t+%.4f\n', names{i}, w(i))
    elseif w(i) < 0
        fprintf('%50s\t-%.4f\n', names{i}, abs(w(i)))
    else
        fprintf('%50s\t %.4f\n', names{i}, w(i))
    end
end

fprintf('\nNonnegative weights: %d / %d\n\n', nnz(w), numel(w))

%% logistic function
mpr = 1 ./ (1 + exp(- X * w ));

%% membrane thresholding (prec, recall)

thresh = 0 : 0.01 : 1;
[prec,recall] = deal(zeros(1,numel(thresh)));
for i = 1 : numel(thresh)
   tmark = mpr > thresh(i);
   prec(i) = nnz(mmark & tmark) / nnz(tmark);
   recall(i) = nnz(mmark & tmark) / nnz(mmark);
end
fscore = 2 * prec .* recall ./ (prec + recall);

[maxfs, maxi] = max(fscore);
fprintf('max fscore: %.4f\n', maxfs)

figure
plot(prec,recall,'LineWidth', 2)
title(sprintf('max fscore: %.4f', maxfs))
hold on
plot(prec(maxi),recall(maxi),'.r','LineWidth',2)
xlabel('recision')
ylabel('recall')

