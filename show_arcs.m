function show_arcs(model, mark)

I = norma1(groundtr('gray',model.fnumber))/5;
gt = groundtr('mark',model.fnumber);
bw = extractcol(gt,[0 0 255]);
bw = extractcol(gt,[255 0 0]) | bw;
I(imdilate(bw,ones(3))) = 1/5;

bwt = arc_draw(I, mark, model.x, model.y);
bw5 = imdilate(bw, ones(5));

showrgb(I, 'G', bwt & bw5, 'R', bwt &~ bw5, 'scale', 3)