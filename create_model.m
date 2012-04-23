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

% ��� �������� ������� (������� ����������� �� ����� �����)
add_size = 15;
model.xcell = [model.xcell zeros(2, add_size)];
model.pcell = [model.pcell zeros(2, add_size)];
model.pcell(:, end - add_size + 1 : end) = eps ^ 2;
model.xcell(2, end - add_size : end) = model.xcell(2, end - add_size) : model.xcell(2, end - add_size) + add_size;
ds = model.xcell(1, 2) - model.xcell(1, 1);
for i = size(model.xcell, 2) - add_size + 1 : size(model.xcell, 2)
    model.xcell(1, i) = model.xcell(1, i - 1) + ds;
end

model.pcell(2, model.pcell(2, :) == 0) = eps ^ 2;
model.pcell(2, :) = model.pcell(2, :) / sum(model.pcell(2, :));
% figure,bar(model.xcell(1,:),model.pcell(1,:))
% figure,bar(model.xcell(2,:),model.pcell(2,:))

% ��� �������� ������� (������� ����������� �� ������� �����)
model.pnode(1,model.pnode(1,:) == 0) = eps ^ 2;
model.pnode(1,:) = model.pnode(1,:) / sum(model.pnode(1,:));

% ���� ������� �� �� �������
% mcur(model.mprob==1) = true; % ��������� �����������, ������� ����� ������
% mcur(model.mprob==0) = false; % ���� �����
% �����:
model.mprob(model.mprob == 1) = 1 - max(model.mprob(model.mprob < 1) * eps);
model.mprob(model.mprob == 0) = min(model.mprob(model.mprob > 0) * eps);
model.mprob = model.mprob .* model.mfull;
model.mpr = adj2val(model.mprob, model.edges);

fprintf('done (%.2f sec)\n', toc)

%% �������
% [~, ~, border] = cell_areas(model.mtrue, model);
% model.border = border;
model.border = false(size(model.mtrue)); % ��������� �������

%% ��������� ������
fprintf('��������� ������...'), tic
save(fname, 'model')
fprintf('done (%.2f sec)\n', toc)
