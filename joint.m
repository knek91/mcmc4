function p = joint(node, mcur, model)

S = model.xnode(1, :) == sum(mcur(node, :));

p = 0;

if any(S)
    X = model.x(mcur(node, :)) - model.x(node);
    Y = model.y(mcur(node, :)) - model.y(node);

    if numel(X) <= 1 
        A = 0;
    else
        A = angle(X + Y * 1i);
        A = sort(A);
        A = A([2 : end 1]) - A;
        A = mod(A, 2 * pi);
        A = min(A, 2 * pi - A);
        A = round(A / pi * 180);
    end

    amax = find(model.xnode(2,:) <= max(A), 1, 'last');
    if ~isempty(amax)
        amin = find(model.xnode(3,:) <= min(A), 1, 'last');
        if ~isempty(amin)
            p = model.pnode(1,S) * model.pnode(2, amax) * model.pnode(3,amin);
        end
    end
end