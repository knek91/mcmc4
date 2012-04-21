function mcross = mem_intersections(model)

fname = sprintf('mem_intersections%d.mat', model.fnumber);
if exist(fname,'file')
	load(fname)
    return 
end

mcross = false(model.memNumber,model.memNumber);
for i = 1 : model.memNumber
    for j = i+1 : model.memNumber
        n1 = model.edges(i,:);
        n2 = model.edges(j,:);
        intr = intersected(model.x(n1),model.y(n1),model.x(n2),model.y(n2));
        if intr
            nmark = (n1 == n2(1) | n1 == n2(2));
            if any(nmark)
                node1 = n1(nmark);
                node2 = n1(~nmark);
                node3 = n2(n2~=node1);
                v1 = [model.x(node2)-model.x(node1) model.y(node2)-model.y(node1)];
                v2 = [model.x(node3)-model.x(node1) model.y(node2)-model.y(node1)];
                s = dot(v1 / sqrt(dot(v1,v1)), v2 / sqrt(dot(v2,v2)));
                if s < 1
                    intr = false;
                end
            end
        end
        mcross(i,j) = intr;
    end
end

mcross = mcross | mcross';

save(fname,'mcross')