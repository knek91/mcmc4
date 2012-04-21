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
mem_thresholding(mpr, mmark)

%% testing 
% create a model
model = create_model(1,1);
model.mpr = mpr;
model.mprob = val2adj(model.mpr, model.edges, model.nodNumber);

% start gibbs
iters = gibbs(model, 'maxiter', 10, 'ucross', false, 'uarea', false);

% result: IteratedRidge with logistic function are not working!
