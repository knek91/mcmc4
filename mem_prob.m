function mpr = mem_prob(pfeat, xfeat, good_features, fnumber)

% membrane probabilities
mfeat = mem_features(fnumber);
mfeat = mfeat(:, good_features);
mpr = zeros(size(mfeat,1),1);
for m = 1 : size(mfeat,1)
    p = 1;
    for f = 1 : size(mfeat,2)
        x = find(xfeat(f,:) <= mfeat(m,f), 1, 'last');
        p = p * pfeat(f,x);
    end
	mpr(m) = p;
end