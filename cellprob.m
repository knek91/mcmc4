function p = cellprob(s, model)

xind = find(model.xcell <= s, 1, 'last');
if ~isempty(xind)
    p = model.pcell(xind);
else
    p = 0;
%     p = eps;
%     xmax = find(model.pcell > 0,1,'last');
%     vmax = model.pcell(xmax);
%     c = vmax * exp(xmax ^ 2);
%     p = c * exp(-s^2);
end