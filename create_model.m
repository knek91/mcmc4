function model = create_model(fnumber, ffeat)
%% ������� �� �����
% fname = 'tmp.mat';
fname = sprintf('model%d.mat',fnumber);
if exist(fname,'file')
    load(fname)
    fprintf('%s ��������� � �����\n',fname);
    return
end
    
%% ��������� ������ ��������
fprintf('��������� ������ ��������...'), tic
model = read_mark(fnumber);
fprintf('done (%.2f sec)\n', toc)

%% ��������� ������ ��������
fprintf('��������� ������ ��������...'), tic
model = connect_nodes(model);
fprintf('done (%.2f sec)\n', toc)

%% ������� ����� �����������
fprintf('������� ����� �����������...'), tic
model.mcross = mem_intersections(model);
fprintf('done (%.2f sec)\n', toc)

%% ����������� �������� �� ��������
fprintf('����������� �������� �� �������� (������� ����������)...'), tic
% model.mpr = mem_feature_old(model, ffeat); % old working features
[X, mmark] = mem_features(ffeat);
Y = zeros(size(mmark));
Y(mmark) = 1;
Y(~mmark) = -1;
w = LassoIteratedRidge(X, double(Y), 2);
model.mpr = 1 ./ (1 + exp(- X * w ));
model.mprob = val2adj(model.mpr, model.edges, model.nodNumber);
fprintf('done (%.2f sec)\n', toc)

%% ���������� ������������� �� �����
fprintf('���������� ������������� �� ����� (���������� �� ����������� ��������)...'), tic
[pfeat, xfeat] = node_stat(ffeat);
model.xnode = xfeat;
model.pnode = pfeat;
fprintf('done (%.2f sec)\n', toc)

%% ������������� �� ������
fprintf('������������� �� ������...'), tic
[pfeat, xfeat] = cell_stat(ffeat);
model.xcell = xfeat;
model.pcell = pfeat;
fprintf('done (%.2f sec)\n', toc)

%% �������
[~, border] = cell_areas(model.mtrue, model);
model.border = border;

%% ��������� ������
fprintf('��������� ������...'), tic
save(fname, 'model')
fprintf('done (%.2f sec)\n', toc)