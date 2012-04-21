function bw = lines_draw(siz, mark, x, y)


bw = false(siz);
for i = 1 : numel(x)
    for j = i+1 : numel(x)
        if mark(i,j)
%             bw = line_bwdraw(bw, [x(i) x(j)], [y(i) y(j)]);
            [CX, CY] = getsquare([x(i) x(j)], [y(i) y(j)]);
            CX = round(CX);
            CY = round(CY);
            ind = sub2ind(siz,diag(CX),diag(CY));
            bw(ind) = true;
        end
    end
end

