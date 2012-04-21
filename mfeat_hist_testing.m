%% membranes features
clear, clc
fnumbers = 1;
[X,mmark,names] = mem_features(fnumber);

%% features histograms
hist_size = 30;
[edges, pos, neg] = features2hist(X, hist_size);

%% features quality values

Q = zeros(size(X, 2), 1);
for i = 1 : numel(Q)
    mpr = hist_prob(X(:, i), edges(i, :), neg(i, :), pos(i, :));
    fscore = mem_thresholding(mpr, mmark);
    Q(i) = max(fscore);
    fprintf('%2d %45s\t%.4f\n', i, names{i}, Q(i))
end

%% feature quality thresholding 

clc
% qthresh = 0 : 0.05 : 1;
qthresh = .75;

for t = 1 : numel(qthresh)
    for i = 1 : numel(Q)
        if Q(i) > qthresh(t)
            fprintf('%2d %45s %.4f\n', i, names{i}, Q(i))
        end
    end
    fprintf('Selected features: %d / %d\n', nnz(Q > qthresh), numel(Q))
    
    I = Q > qthresh(t);
    mpr = hist_prob(X(:, I'), edges(I, :), neg(I, :), pos(I, :));
    fscore = mem_thresholding(mpr, mmark);
    fprintf('Max fscore: %.4f\n', max(fscore))
end

%% greedy search

maxs = 0;
[maxq, maxi] = max(Q);
S = [];
QS = [];
while maxs < maxq
    maxs = maxq;
    S = [S maxi];
    QS = [QS maxq];
    fprintf('+ %2d %45s %.5f %.5f\n', maxi, names{maxi}, Q(maxi), maxs)
    
    maxq = 0;
    for f = setdiff(1 : numel(Q), S)
        I = [S f];
        mpr = hist_prob(X(:, I), edges(I', :), neg(I', :), pos(I', :));
    	fscore = mem_thresholding(mpr, mmark);
        if max(fscore) > maxq
            maxq = max(fscore);
            maxi = f;
        end
    end
end

%% testing 
% create a model
fnumber = 1;
model = create_model(fnumber, fnumbers);

% start gibbs (old features)
iters = gibbs(model, 'maxiter', 10, 'ucross', false, 'uarea', false);
% result:
% iter: 10; energy:   5276; musage:  12.15%; prec:  80.03%; recall:  84.05%

%% greedy features
I = S;
model.mpr = hist_prob(X(:, I), edges(I', :), neg(I', :), pos(I', :));
model.mprob = val2adj(model.mpr, model.edges, model.nodNumber);
iters = gibbs(model, 'maxiter', 10, 'ucross', false, 'uarea', false);
% result:
% iter: 10; energy:   6980; musage:  10.43%; prec:  84.23%; recall:  75.93%

%% Q > 0.75
I = find(Q > 0.75)';
model.mpr = hist_prob(X(:, I), edges(I', :), neg(I', :), pos(I', :));
model.mprob = val2adj(model.mpr, model.edges, model.nodNumber);
iters = gibbs(model, 'maxiter', 10, 'ucross', false, 'uarea', false);
% result:
% iter: 10; energy:   4744; musage:  10.77%; prec:  90.89%; recall:  84.59%
% iter: 10; energy:   4785; musage:  10.71%; prec:  90.26%; recall:  83.59%
%
iters = gibbs(model, 'maxiter', 10, 'ucross', true, 'uarea', false);
% results:
% iter: 10; energy:   4882; musage:  10.62%; prec:  93.45%; recall:  85.78%
% iter: 10; energy:   4755; musage:  10.65%; prec:  93.37%; recall:  85.96%
%
iters = gibbs(model, 'maxiter', 10, 'ucross', true, 'uarea', true, 'minit', dtri(model));
% results
% iter: 10; energy:   5279; musage:  10.33%; prec:  95.41%; recall:  85.23%
% iter: 10; energy:   5392; musage:  10.36%; prec:  94.40%; recall:  84.50%

%% Q == max(Q)
I = find(Q == max(Q))';
model.mpr = hist_prob(X(:, I), edges(I', :), neg(I', :), pos(I', :));
model.mprob = val2adj(model.mpr, model.edges, model.nodNumber);
iters = gibbs(model, 'maxiter', 10, 'ucross', false, 'uarea', false);
% result:
% iter: 10; energy:   6330; musage:  11.77%; prec:  65.95%; recall:  67.09%

%% Q > 0.6
I = find(Q > 0.6)';
model.mpr = hist_prob(X(:, I), edges(I', :), neg(I', :), pos(I', :));
model.mprob = val2adj(model.mpr, model.edges, model.nodNumber);
iters = gibbs(model, 'maxiter', 10, 'ucross', false, 'uarea', false);
% result:
% iter: 10; energy:   9109; musage:   9.49%; prec:  91.00%; recall:  74.66%

%% Q > 0.6
I = [find(Q > 0.75)' 4];
model.mpr = hist_prob(X(:, I), edges(I', :), neg(I', :), pos(I', :));
model.mprob = val2adj(model.mpr, model.edges, model.nodNumber);
iters = gibbs(model, 'maxiter', 10, 'ucross', false, 'uarea', false);
% result:
% iter: 10; energy:   5030; musage:  10.57%; prec:  89.92%; recall:  82.13%









