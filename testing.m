%% ��������� ������� ����������� (����������� + �������)
% ������ � ����������� ������� ��������� �� �������� �����������
% � ������� ����������� ����������� � ������������� �������
% ����� ������������ ������� ����������� ��� ���������������� ���� ������
% � ������ ������, ���� ����� ����� ��������: ���������������
% c*exp(-x2) ��� eps

% �����... ������ �������� ����������� � ���, ��� �������� �� ���������
% �������� �������. ���� �������� �������� ��� ���. ��������, �����
% ��������� ���������
    
% ����� ����������� ��������� �������� �� ������ ��� ������
fprintf('������ ��� �������� ������\n');
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

% ���� ������� �� �� �������
% mcur(model.mprob==1) = true; % ��������� �����������, ������� ����� ������
% mcur(model.mprob==0) = false; % ���� �����
% �����:
    model.mprob(model.mprob==1) = 1 - max(model.mprob(model.mprob<1) * eps);
    model.mprob(model.mprob==0) = min(model.mprob(model.mprob > 0) * eps);
    model.mprob = model.mprob .* model.mfull;
    model.mpr = adj2val(model.mprob, model.edges);

% ������� �������� � ���������, ������� ����� ������ �� ����� DT

% ���� ������� ��-�� ������� ����
    model.pnode(1,model.pnode(1,:)==0) = eps ^ 2;
    model.pnode(1,:) = model.pnode(1,:) / sum(model.pnode(1,:));

% � ������ ��� �������: �������� �� ���� ��������� ������ ����
% ������ ���� ������� ��������� �� �� �������� (�� ���, �� ���������)

% ��� ��� ��������� ��� ����������
    
    tic
    iters = gibbs(model, ...
        'maxiter', 20, ...
        'minit', mcur, ...
        'uarea', true, ...
        'mcoef', 1.5, ...
        'carea', 0.5, ... % ��� ���������� ������� �� �����������...
        'saveall', sprintf('testing/%d',fnumber), ...
        'savefin', sprintf('testing/%d/mbest',fnumber),...
        'savelog', sprintf('testing/log%d.txt',fnumber));
    toc
end