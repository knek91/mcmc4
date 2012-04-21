%% Start example

% create a model
model = create_model(fnumber, fnumbers);

% start gibbs
iters = gibbs(model, 'maxiter', 10, 'ucross', true, 'uarea', true);

% show result
figure, show_lines(model, iters.mbest)

%% Code below is for one of the reports (unnecessary to run)

%% ���������� ������������ ������ ���� �� ���� ���������
% �������� ������� �� ����� ��������� (������ ���������� ����������)
% �������� �� ������� ���������� ������
% ���� ��� �����������
% 20 ��������
% ������ �� ������ ��������
% ��������! �������� ��������: ������ ��� �������� 1 � 0
% �� 0 � 1 ������������� ����������� [eps^2 eps] �� ������ create_model()
% ������������� ��� �������� ����: eps 
fnumbers = [1,5]; 
mkdir('old')
fprintf('���������� ������������ ������ ���� �� ���� ���������\n')

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

%% ������������� ��������
% �������� ������������ �������� (��� ��������)
% ������������ �������
% NOTE: ��������� ��� ����������
% NOTE: ����� � ����� �� ���� �� ����� ������! ��� ���� �������
% �������� �����
fnumbers = [1,5];

fclose('all');

% �������� ������ � ����������
fprintf('�������� ������ � ����������\n')
for fnumber = fnumbers    
    model = create_model(fnumber, fnumbers);
    % ������� ����������� ��� �������? ������ �������!
    iters = gibbs(model, ...
        'maxiter', 20, ...
        'minit', model.mtrue, ...
        'uarea', true, ...
        'nodfeat', {},...
        'saveall', sprintf('area/monly/%d',fnumber), ...
        'savefin', sprintf('area/monly/%d/mbest', fnumber),...
        'savelog', sprintf('area/monly/log%d.txt', fnumber));
    
    % ����������� �������
    figure, bar(model.xcell, model.pcell), title('area')
    pngsave('area/area_hist%d', fnumber), close
    
    % �������
    figure,show_lines(model, model.border | model.border'),title('border')
    pngsave('area/border%d', fnumber), close
end

% ��������� ������� �����
fprintf('��������� ������� �����\n')
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

% ��������� ��� ����
fprintf('��������� ��� ����\n')
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

% ��������� ���� ����
% NOTE: ��� ������� ������
fprintf('��������� ���� ����\n')
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

%% ��� �������: ��������� � ���������
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

% ����������� ����� ����
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
    % ����� ���� �������
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

%% ��������� ������� ����������� (����������� + �������)
% ������ � ����������� ������� ��������� �� �������� �����������
% � ������� ����������� ����������� � ������������� �������
% ����� ������������ ������� ����������� ��� ���������������� ���� ������
% � ������ ������, ���� ����� ����� ��������: ���������������
% c*exp(-x2) ��� eps
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
        'saveall', sprintf('area/init_delaunay_tri/%d',fnumber), ...
        'savefin', sprintf('area/init_delaunay_tri/%d/mbest',fnumber),...
        'savelog', sprintf('area/init_delaunay_tri/log%d.txt',fnumber));
    toc
end

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
        'saveall', sprintf('area/init_delaunay_tri_no_border/%d',fnumber), ...
        'savefin', sprintf('area/init_delaunay_tri_no_border/%d/mbest',fnumber),...
        'savelog', sprintf('area/init_delaunay_tri_no_border/log%d.txt',fnumber));
    toc
end


    %% ������ ����� ������� �����������?
    % ������ ������� ���������� (�������� ������� fp, fn)
    % ������ ������� ���������� (�������� ������� fp, fn)
    % ������ �������� (�������� ������� fp, fn)
    
    % �������� ����� ��������
    % ���������� ������ ��������� � �������������� ���� (��� ����� ����������
    % ������ ��������)
    % ����������� ��������������� lasso & 1/(a + exp(-xb))
    % ��������� ������ mcmc ��� ��������
    %
    % ����������� ����������� + Q
    % ��������� mcmc ��� ��������
    %
    % ��� �������: ��������� � ���������
    % 
    % ���������� ����� �������� �������� (� ����� ��? ����� �� � ���
    % ������ ��������? ����� ������� ������ ������� ����������, ���� ���?)
    % ������� ������ ��������, ���� ��� �������� � ������� �����, ������� ��������� �������
    % ����� �� �������������� ��� ������ �������� 
    %
    % ����������� ������� � ������������
    % ���� ������ � ������ �� ������, ��� ����� �������� � ����� ����

    
    
    
    
    
    
    
    
    
    
    
    
    