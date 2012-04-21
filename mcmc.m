%% Start example

% create a model
model = create_model(fnumber, fnumbers);

% start gibbs
iters = gibbs(model, 'maxiter', 10, 'ucross', true, 'uarea', true);

% show result
figure, show_lines(model, iters.mbest)

%% Code below is for one of the reports (unnecessary to run)

%% результаты тестирования старых мсмс на двух картинках
% признаки берутся по обоим картинкам (просто объединяем прецеденты)
% признаки на унарные потенциалы старые
% мсмс без пересечений
% 20 итераций
% запуск от пустой разметки
% ВНИМАНИЕ! картинки изменены: больше нет степеней 1 и 0
% ст 0 и 1 присваивается вероятность [eps^2 eps] на уровне create_model()
% невстреченные при обучении углы: eps 
fnumbers = [1,5]; 
mkdir('old')
fprintf('Результаты тестирования старых мсмс на двух картинках\n')

for fnumber = fnumbers    
    model = create_model(fnumber, fnumbers);
    
    tic
    iters = gibbs(model, 'maxiter', 20, 'ucross', true);
    toc
    
    figure,imshow(norma1(groundtr('gray',fnumber))),title('original')
    pngsave('old/original%d.png',fnumber), close
    
    figure,show_lines(model,model.mtrue)
    title(sprintf('energy: %.0f', energy(model.mtrue,model.mmark,model,false)))
    pngsave('old/mtrue_lines%d.png', fnumber), close
    
    figure,show_turtle(model,model.mtrue)
    title(sprintf('energy: %.0f', energy(model.mtrue,model.mmark,model,false)))
    pngsave('old/mtrue_turtle%d.png', fnumber), close
    
    figure,show_lines(model, iters.mbest), title('lines')
    pngsave('old/lines%d.png',fnumber), close
    
    figure,show_turtle(model,iters.mbest), title('turtle')
    pngsave('old/turtle%d.png',fnumber), close
    
    figure,show_arcs(model,iters.mbest), title('arcs')
    pngsave('old/arcs%d.png', fnumber), close
end

%% Распределение площадей
% построил расределение площадей (обе картинки)
% зафиксировал границу
% NOTE: упомянуть про выпуклость
% NOTE: здесь и далее не делю на число вершин! при этом энергию
% вычисляю верно
fnumbers = [1,5];

fclose('all');

% запустил только с мембранами
fprintf('запустил только с мембранами\n')
for fnumber = fnumbers    
    model = create_model(fnumber, fnumbers);
    % нулевая вероятность для площади? добавь епсилон!
    iters = gibbs(model, ...
        'maxiter', 20, ...
        'minit', model.mtrue, ...
        'uarea', true, ...
        'nodfeat', {},...
        'saveall', sprintf('area/monly/%d',fnumber), ...
        'savefin', sprintf('area/monly/%d/mbest', fnumber),...
        'savelog', sprintf('area/monly/log%d.txt', fnumber));
    
    % гистограмма площади
    figure, bar(model.xcell, model.pcell), title('area')
    pngsave('area/area_hist%d', fnumber), close
    
    % граница
    figure,show_lines(model, model.border | model.border'),title('border')
    pngsave('area/border%d', fnumber), close
end

% Добавляем степень узлов
fprintf('Добавляем степень узлов\n')
for fnumber = fnumbers
    model = create_model(fnumber);
    
    iters = gibbs(model, ...
        'maxiter', 20, ...
        'minit', model.mtrue, ...
        'uarea', true, ...
        'nodfeat', {'pow'},...
        'saveall', sprintf('area/npow/%d',fnumber), ...
        'savefin', sprintf('area/npow/%d/mbest', fnumber),...
        'savelog', sprintf('area/npow/log%d.txt', fnumber));
    
end

% Добавляем мин угол
fprintf('Добавляем мин угол\n')
for fnumber = fnumbers
    model = create_model(fnumber);
    
    iters = gibbs(model, ...
        'maxiter', 20, ...
        'minit', model.mtrue, ...
        'uarea', true, ...
        'nodfeat', {'pow','amin'},...
        'saveall', sprintf('area/npowmin/%d',fnumber), ...
        'savefin', sprintf('area/npowmin/%d/mbest', fnumber),...
        'savelog', sprintf('area/npowmin/log%d.txt', fnumber));
    
end

% Добавляем макс угол
% NOTE: нет висячих вершин
fprintf('Добавляем макс угол\n')
for fnumber = fnumbers
    model = create_model(fnumber);
    
    iters = gibbs(model, ...
        'maxiter', 20, ...
        'minit', model.mtrue, ...
        'uarea', true, ...
        'saveall', sprintf('area/nall3/%d',fnumber), ...
        'savefin', sprintf('area/nall3/%d/mbest', fnumber),...
        'savelog', sprintf('area/nall3/log%d.txt', fnumber));
    
end

%% для лучшего: запустить с квадратом
% iters = gibbs(model, 'maxiter', 20, 'minit', model.mtrue, 'uarea',
% true, 'sfalse', @(x^2)...
fnumbers = [1,5];
    
fprintf('p0^2\n')
for fnumber = fnumbers
    model = create_model(fnumber);
    
    tic
    iters = gibbs(model, ...
        'maxiter', 20, ...
        'minit', model.mtrue, ...
        'uarea', true, ...
        'sfalse', @(x) x^2,...
        'saveall', sprintf('area/sfalse_square/%d',fnumber), ...
        'savefin', sprintf('area/sfalse_square/%d/mbest',fnumber),...
        'savelog', sprintf('area/sfalse_square/log%d.txt',fnumber));
    toc
end

% попробовать также макс
% iters = ...(..., 'strue', @max)

fprintf('max(p1,p2)\n')
for fnumber = fnumbers
    model = create_model(fnumber);
    
    tic
    iters = gibbs(model, ...
        'maxiter', 20, ...
        'minit', model.mtrue, ...
        'uarea', true, ...
        'strue', @max, ...
        'saveall', sprintf('area/strue_max/%d',fnumber), ...
        'savefin', sprintf('area/strue_max/%d/mbest',fnumber),...
        'savelog', sprintf('area/strue_max/log%d.txt',fnumber));
    toc
end
%%
    % можно даже среднее
    % iters = ...(..., 'strue', @mean)
    
fprintf('mean(p1,p2)\n')
for fnumber = fnumbers
    model = create_model(fnumber);
    
    tic
    iters = gibbs(model, ...
        'maxiter', 20, ...
        'minit', model.mtrue, ...
        'uarea', true, ...
        'strue', @mean, ...
        'saveall', sprintf('area/strue_mean/%d',fnumber), ...
        'savefin', sprintf('area/strue_mean/%d/mbest',fnumber),...
        'savelog', sprintf('area/strue_mean/log%d.txt',fnumber));
    toc
end

%% придумать говеное приближение (приближение + граница)
% лучший и стандартный вариант запустить от говеного приближения
% в говеном приближении фиксировать и нефиксировать границу
% можно генерировать говеное приближение как непересекающиеся мини клетки
% в каждом случае, если плохо будет работать: воспользоваться
% c*exp(-x2) или eps
fnumbers = [1,5];
for fnumber = 1
    model = create_model(fnumber, fnumbers);

    C = [];
    for i = 1 : size(model.border,1)
        for j = 1 : size(model.border,2)
            if model.border(i,j)
                C = [C; i j];
            end
        end
    end

    DT = DelaunayTri([model.x' model.y'], C);
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
        'saveall', sprintf('area/init_delaunay_tri/%d',fnumber), ...
        'savefin', sprintf('area/init_delaunay_tri/%d/mbest',fnumber),...
        'savelog', sprintf('area/init_delaunay_tri/log%d.txt',fnumber));
    toc
end

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
        'saveall', sprintf('area/init_delaunay_tri_no_border/%d',fnumber), ...
        'savefin', sprintf('area/init_delaunay_tri_no_border/%d/mbest',fnumber),...
        'savelog', sprintf('area/init_delaunay_tri_no_border/log%d.txt',fnumber));
    toc
end


    %% почему часть мембран выключается?
    % низкие унарные потенциалы (привести таблицу fp, fn)
    % низкие узловые потенциалы (привести таблицу fp, fn)
    % низкие площадки (привести таблицу fp, fn)
    
    % добавить новые признаки
    % нагенерить больше признаков с использованием арок (они лучше приближают
    % верные мембраны)
    % попробовать воспользоваться lasso & 1/(a + exp(-xb))
    % проверить работу mcmc без площадей
    %
    % попробовать гистограммы + Q
    % проверить mcmc без площадей
    %
    % для лучшего: проверить с площадьми
    % 
    % выработать новый критерий качества (а нужно ли? когда всё и так
    % хорошо работает? новый вариант только улучшит результаты, ведь так?)
    % считать верной мембрану, если она попадает в область сетки, считать найденные участки
    % снова всё протестировать для нового критерия 
    %
    % попробовать вариант с миниклетками
    % если ничего в голову не придет, все равно написать о такой идее

    
    
    
    
    
    
    
    
    
    
    
    
    