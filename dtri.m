function mcur = dtri(model)    
    DT = DelaunayTri([model.x' model.y']);
    edges = DT.edges;
    mcur = false(size(model.mtrue));
    for i = 1 : size(DT.edges,1)
        n = edges(i,:);
        mcur(n(1),n(2)) = true;
        mcur(n(2),n(1)) = true;
    end
    mcur = mcur & model.mfull;