function p = cellprob(model, s, s2)

if nargin == 3 % union of two cells
    s(1) = s(1) + s2(1); % area
%     s(2) = s(2) + s2(2) - 2; % vertices;
end

xarea = find(model.xcell(1,:) <= s(1), 1, 'last');
if ~isempty(xarea)
%     xvert = model.xcell(2,:) == s(2);
%     if any(xvert)
%         p = model.pcell(1, xarea) * model.pcell(2, xvert);
%     else
%         p = 0;
%     end
    p = model.pcell(1, xarea);
else
    p = 0;
end