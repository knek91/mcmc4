function p = joint(node, mcur, model)

if ~isfield(model, 'use_nodfeat')

    S = model.xnode(1,:) == sum(mcur(node,:));

    p = 0;

    if any(S)
        X = model.x(mcur(node,:))-model.x(node);
        Y = model.y(mcur(node,:))-model.y(node);

        if numel(X) <= 1 
            A = 0;
        else
            A = angle(X + Y*1i);
            A = sort(A);
            A = A([2:end 1]) - A;
            A = mod(A, 2*pi);
            A = min(A, 2*pi - A);
            A = round(A / pi * 180);
        end

        amax = find(model.xnode(2,:) <= max(A),1,'last');
        if ~isempty(amax)
            amin = find(model.xnode(3,:) <= min(A),1,'last');
            if ~isempty(amin)
                p = model.pnode(1,S) * model.pnode(2, amax) * model.pnode(3,amin);
            end
        end
    end

else
  
    p = 1;
    
    if isempty(model.use_nodfeat) 
        return
    end

    if numel(model.use_nodfeat) > 1 % заглушка: проверяем, что используются углы
        
        X = model.x(mcur(node,:))-model.x(node);
        Y = model.y(mcur(node,:))-model.y(node);

        if numel(X) <= 1 
            A = 0;
        else
            A = angle(X + Y*1i);
            A = sort(A);
            A = A([2:end 1]) - A;
            A = mod(A, 2*pi);
            A = min(A, 2*pi - A);
            A = round(A / pi * 180);
        end
    end

    for i = 1 : numel(model.use_nodfeat)
        switch model.use_nodfeat{i}
            case 'pow'
                S = model.xnode(1,:) == sum(mcur(node,:));
                if any(S)
                    p = p * model.pnode(1,S);
                else
                    p = 0;
                    break;
                end
            case 'amin'
                amin = find(model.xnode(3,:) <= min(A),1,'last');
                if isempty(amin)
                    p = 0;
                    break
                else
                    p = p * model.pnode(3,amin);
                end
            case 'amax'
                amax = find(model.xnode(2,:) <= max(A),1,'last');
                if isempty(amax)
                    p = 0;
                    break
                else
                    p = p * model.pnode(2, amax);
                end
            otherwise
                error('unknown keyword: %s', model.use_nodfeat{i})
        end
    end
  
end