function en = energy(mcur, mlist, model, uarea)

% membranes
en = - sum(log(model.mpr(mlist)));
en = en - sum(log(1-model.mpr(~mlist)));
% 
% if en == inf
% end

% nodes
for n = 1 : model.nodNumber
	en = en - log(joint(n, mcur, model));
end
% 
% if en == inf
% end

% cells
if uarea
    areas = cell_areas(mcur, model, model.border);
    for area = areas
        en = en - log(cellprob(area, model));
%         if en == inf
%         end
    end
end