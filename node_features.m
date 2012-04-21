function X = node_features(fnumbers)

X = [];

for fnumber = fnumbers

    fname = sprintf('node_features%d.mat', fnumber);

    if exist(fname,'file')
        load(fname)
    else
        model = read_mark(fnumber);
        model = connect_nodes(model);

        nfeat = zeros(model.nodNumber,3);

        for n = 1 : model.nodNumber
           % ������� ����
           nfeat(n, 1) =  sum(model.mtrue(n,:));

           % ������������ ����
           A = angles(n, model.mtrue, model.x, model.y);
           nfeat(n, 2) = max(A);

           % ����������� ����
           nfeat(n, 3) = min(A);
        end
        
        save(fname, 'nfeat')
    end
    
    X = [X; nfeat];
end