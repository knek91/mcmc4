function en = energy(mcur, mlist, model, uarea)

% membranes
en = - sum(log(model.mpr(mlist)));
en = en - sum(log(1-model.mpr(~mlist)));

% nodes
for n = 1 : model.nodNumber
	en = en - log(joint(n, mcur, model));
end

% cells
if uarea
    [areas vertices] = cell_areas(mcur, model, model.border);
    for i = 1 : numel(areas)
        en = en - log(cellprob(model, [areas(i) vertices(i)]));
        if isinf(en)
        end
    end
end