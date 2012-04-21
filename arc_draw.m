function bw = arc_draw(I, membranes, x, y, varargin)

bw = false(size(I));
% wb = waitbar(0,'Arc drawing...');
for n1 = 1 : size(membranes,1)
    for n2 = n1+1 : size(membranes,2)
        if membranes(n1,n2)
            [CX,CY] = getsquare(x([n1,n2]),y([n1,n2]));
            inds = sub2ind(size(I),min(max(floor(CX(:)),1),size(I,1)),...
                min(max(floor(CY(:)),1),size(I,2)));
            tmp = reshape(I(inds),size(CX));
            [~, ~, L] = approx_arc(tmp);
            bw(inds) = bw(inds) | L(:);
        end
    end
%     waitbar(n1/size(membranes,1),wb);
end
% close(wb);