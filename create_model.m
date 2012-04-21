%%model = create_model(fnumber, ffeat)
% fnumber   image number
% ffeat     image numbers to extract features
function model = create_model(fnumber, ffeat, varargin)
%% ������� �� �����
fname = sprintf('model%d.mat',fnumber);
if numel(varargin) == 0
    if exist(fname,'file')
        load(fname)
        fprintf('%s ��������� � �����\n',fname);
        return
    end
end

if nargin == 1
    ffeat = fnumber;
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

% old working features
% model.mpr = mem_feature_old(model, ffeat); 

% lasso features (doesnt work)
% [X, mmark] = mem_features(ffeat);
% Y = zeros(size(mmark));
% Y(mmark) = 1;
% Y(~mmark) = -1;
% w = LassoIteratedRidge(X, double(Y), 2);
% model.mpr = 1 ./ (1 + exp(- X * w ));

% hist features (working better)
X = mem_features(ffeat);
hist_size = 30;
[edges, pos, neg] = features2hist(X, model.mmark, hist_size);
I = [4 6 27 29 30 32 33 35];
model.mpr = hist_prob(X(:, I), edges(I', :), neg(I', :), pos(I', :));

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