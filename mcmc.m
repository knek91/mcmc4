%% Start example

% image number
fnumber = 1;
fnumbers = [1 5];

% create a model
model = create_model(fnumber, fnumbers);

% start gibbs
    
iters = gibbs(model, 'maxiter', 15, 'ucross', true, 'uarea', true);

%% граница фиксируется внутри gibbs()
% на одном запуске, нефиксированная граница повышает recall и уменьшает prec
% протестировать на mtrue
% сделать больше итераций (20) 
% сильно понизить приоритет, чтобы проц не сгорел

% шаманство + vertices & area
% true energy: 6370
% img:  1; iter:  1; energy:  58338; musage:  21.98%; prec:  51.06%; recall:  96.99%
% img:  1; iter:  2; energy:  17633; musage:  10.39%; prec:  61.62%; recall:  55.33%
% img:  1; iter:  3; energy:  15015; musage:  11.30%; prec:  66.79%; recall:  65.27%
% img:  1; iter:  4; energy:  13362; musage:  10.88%; prec:  70.64%; recall:  66.45%
% img:  1; iter:  5; energy:  12377; musage:  10.98%; prec:  73.87%; recall:  70.10%
% img:  1; iter:  6; energy:  11625; musage:  10.94%; prec:  75.70%; recall:  71.56%
% img:  1; iter:  7; energy:  11116; musage:  10.96%; prec:  76.80%; recall:  72.74%
% img:  1; iter:  8; energy:  10914; musage:  11.01%; prec:  77.30%; recall:  73.56%
% img:  1; iter:  9; energy:  10676; musage:  10.96%; prec:  78.06%; recall:  73.93%
% img:  1; iter: 10; energy:  10452; musage:  10.94%; prec:  78.88%; recall:  74.57%
% img:  1; iter: 11; energy:  10371; musage:  10.90%; prec:  79.40%; recall:  74.84%
% img:  1; iter: 12; energy:  10184; musage:  10.91%; prec:  79.81%; recall:  75.30%
% img:  1; iter: 13; energy:  10193; musage:  10.85%; prec:  79.69%; recall:  74.75%

% only vertices
% true energy: 5535
% img:  1; iter:  1; energy:  54496; musage:  21.98%; prec:  51.06%; recall:  96.99%
% img:  1; iter:  2; energy:  14905; musage:  10.27%; prec:  63.96%; recall:  56.79%
% img:  1; iter:  3; energy:  11687; musage:  10.99%; prec:  73.03%; recall:  69.37%
% img:  1; iter:  4; energy:   9769; musage:  10.67%; prec:  79.25%; recall:  73.11%
% img:  1; iter:  5; energy:   8843; musage:  10.69%; prec:  82.25%; recall:  76.03%
% img:  1; iter:  6; energy:   8429; musage:  10.70%; prec:  83.84%; recall:  77.58%
% img:  1; iter:  7; energy:   8163; musage:  10.78%; prec:  85.13%; recall:  79.31%
% img:  1; iter:  8; energy:   7902; musage:  10.71%; prec:  86.02%; recall:  79.67%
% img:  1; iter:  9; energy:   7795; musage:  10.76%; prec:  86.37%; recall:  80.31%
% img:  1; iter: 10; energy:   7715; musage:  10.75%; prec:  87.05%; recall:  80.86%
% img:  1; iter: 11; energy:   7553; musage:  10.77%; prec:  87.46%; recall:  81.40%
% img:  1; iter: 12; energy:   7467; musage:  10.76%; prec:  87.55%; recall:  81.40%
% img:  1; iter: 13; energy:   7446; musage:  10.79%; prec:  88.07%; recall:  82.13%
% img:  1; iter: 14; energy:   7379; musage:  10.83%; prec:  87.93%; recall:  82.32%
% img:  1; iter: 15; energy:   7302; musage:  10.81%; prec:  88.10%; recall:  82.32%

% area only
% true energy: 5812
% img:  1; iter:  1; energy:  54201; musage:  21.98%; prec:  51.06%; recall:  96.99%
% img:  1; iter:  2; energy:  13727; musage:   9.55%; prec:  72.08%; recall:  59.53%
% img:  1; iter:  3; energy:   9701; musage:  10.78%; prec:  80.63%; recall:  75.11%
% img:  1; iter:  4; energy:   7571; musage:  10.26%; prec:  86.64%; recall:  76.85%
% img:  1; iter:  5; energy:   7031; musage:  10.29%; prec:  89.45%; recall:  79.58%
% img:  1; iter:  6; energy:   6668; musage:  10.28%; prec:  90.67%; recall:  80.58%
% img:  1; iter:  7; energy:   6447; musage:  10.23%; prec:  92.16%; recall:  81.49%
% img:  1; iter:  8; energy:   6219; musage:  10.18%; prec:  93.37%; recall:  82.13%
% img:  1; iter:  9; energy:   6088; musage:  10.26%; prec:  93.53%; recall:  82.95%
% img:  1; iter: 10; energy:   6045; musage:  10.24%; prec:  93.72%; recall:  82.95%
% img:  1; iter: 11; energy:   6021; musage:  10.19%; prec:  94.41%; recall:  83.14%
% img:  1; iter: 12; energy:   6027; musage:  10.19%; prec:  94.20%; recall:  82.95%
% img:  1; iter: 13; energy:   6006; musage:  10.24%; prec:  94.23%; recall:  83.41%
% img:  1; iter: 14; energy:   6005; musage:  10.24%; prec:  94.34%; recall:  83.50%
% img:  1; iter: 15; energy:   6001; musage:  10.24%; prec:  94.64%; recall:  83.77%
%% show result
figure, show_lines(model, iters.mbest)

%% 
m = iters.mark{end};
en = energy(m, adj2val(m, model.edges), model, true)

%% 
for i = 1 : iters.maxiter
    figure,show_lines(model, iters.mark{i})
end

%% Code below is for the past report (do not run)
% результаты тестирования старых мсмс на двух картинках
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
        'uarea', true);
    toc
end
%%
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
        'uarea', true);
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

    
    
    
    
    
    
    
    
    
    
    
    
    