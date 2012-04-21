function model = create_model(fnumber, ffeat)
%% Смотрим на диске
% fname = 'tmp.mat';
fname = sprintf('model%d.mat',fnumber);
if exist(fname,'file')
    load(fname)
    fprintf('%s загружена с диска\n',fname);
    return
end
    
%% Считываем ручную разметку
fprintf('Считываем ручную разметку...'), tic
model = read_mark(fnumber);
fprintf('done (%.2f sec)\n', toc)

%% Добавляем ложные мембраны
fprintf('Добавляем ложные мембраны...'), tic
model = connect_nodes(model);
fprintf('done (%.2f sec)\n', toc)

%% Создаем карту пересечений
fprintf('Создаем карту пересечений...'), tic
model.mcross = mem_intersections(model);
fprintf('done (%.2f sec)\n', toc)

%% Разделяющие признаки на мембраны
fprintf('Разделяющие признаки на мембраны (унарные потенциалы)...'), tic
% [pfeat, xfeat, good_features] = mem_stat(ffeat);
% mpr = mem_prob(pfeat, xfeat, good_features, fnumber);
% model.mpr = mpr;
model.mpr = mem_feature_old(model, ffeat);
model.mprob = val2adj(model.mpr, model.edges, model.nodNumber);
fprintf('done (%.2f sec)\n', toc)

%% Совместное распределение на узлах
fprintf('Совместные распределение на узлах (потенциалы на инцидентные мембраны)...'), tic
[pfeat, xfeat] = node_stat(ffeat);
model.xnode = xfeat;
model.pnode = pfeat;
fprintf('done (%.2f sec)\n', toc)

%% Распределение на клетки
fprintf('Распределение на клетки...'), tic
[pfeat, xfeat] = cell_stat(ffeat);
model.xcell = xfeat;
model.pcell = pfeat;
fprintf('done (%.2f sec)\n', toc)

%% Граница
[~, border] = cell_areas(model.mtrue, model);
model.border = border;

%% Сохраняем модель
fprintf('Сохраняем модель...'), tic
save(fname, 'model')
fprintf('done (%.2f sec)\n', toc)