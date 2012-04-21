%% придумать говеное приближение (приближение + граница)
% лучший и стандартный вариант запустить от говеного приближения
% в говеном приближении фиксировать и нефиксировать границу
% можно генерировать говеное приближение как непересекающиеся мини клетки
% в каждом случае, если плохо будет работать: воспользоваться
% c*exp(-x2) или eps

% тааак... теперь проблема заключается в том, что площадки не оказывают
% должного эффекта. мсмс работает какбудто без них. возможно, стоит
% увеличить потенциал
    
% стоит попробовать запустить площадки от делоне без границ
fprintf('Делоне без фиксации границ\n');
fnumbers = [1,5];
for fnumber = fnumbers
    model = create_model(fnumber, fnumbers);
    model.border = zeros(size(model.border));

    DT = DelaunayTri([model.x' model.y']);
    edges = DT.edges;
    mcur = false(size(model.mtrue));
    for i = 1 : size(DT.edges,1)
        n = edges(i,:);
        mcur(n(1),n(2)) = true;
        mcur(n(2),n(1)) = true;
    end

% беск энергия из за мембран
% mcur(model.mprob==1) = true; % возникнут пересечения, поэтому лучше убрать
% mcur(model.mprob==0) = false; % тоже фигня
% лучше:
    model.mprob(model.mprob==1) = 1 - max(model.mprob(model.mprob<1) * eps);
    model.mprob(model.mprob==0) = min(model.mprob(model.mprob > 0) * eps);
    model.mprob = model.mprob .* model.mfull;
    model.mpr = adj2val(model.mprob, model.edges);

% остаётся проблема с границами, которую можно решить на этапе DT

% беск энергия из-за степени узла
    model.pnode(1,model.pnode(1,:)==0) = eps ^ 2;
    model.pnode(1,:) = model.pnode(1,:) / sum(model.pnode(1,:));

% с углами нет проблем: обучение на двух картинках убрало нули
% дальше беск энергия возникает из за площадей (ан нет, не возникает)

% еще раз упомянуть про выпуклость
    
    tic
    iters = gibbs(model, ...
        'maxiter', 20, ...
        'minit', mcur, ...
        'uarea', true, ...
        'mcoef', 1.5, ...
        'carea', 0.5, ... % при вычислении энергии не учитывается...
        'saveall', sprintf('testing/%d',fnumber), ...
        'savefin', sprintf('testing/%d/mbest',fnumber),...
        'savelog', sprintf('testing/log%d.txt',fnumber));
    toc
end