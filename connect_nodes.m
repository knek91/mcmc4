function model = connect_nodes(model)

mfull = false(size(model.mtrue));
mmark = false(0);
edges = zeros(0);

for i = 1 : model.nodNumber
    for j = i + 1 : model.nodNumber
        if sqrt((model.x(i)-model.x(j))^2 + (model.y(i)-model.y(j))^2) <= model.nodrad
            mfull(i,j) = true;
            mfull(j,i) = true;
            edges = [edges; i, j];
            mmark = [mmark; model.mtrue(i,j)];
        end
    end
end

mfalse = mfull &~ model.mtrue;

model.mfull = mfull;
model.edges = edges;
model.mfalse = mfalse;
model.memNumber = size(model.edges,1);
model.mmark = mmark;