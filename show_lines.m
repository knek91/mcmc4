function show_lines(model, mark)

I = norma1(groundtr('gray',model.fnumber))/5;
gt = groundtr('mark',model.fnumber);
bw = extractcol(gt,[0 0 255]);
bw = extractcol(gt,[255 0 0]) | bw;
I(imdilate(bw,ones(3))) = 1/5;

bwt = lines_draw(size(I), mark & model.mtrue, model.x, model.y);
bwf = lines_draw(size(I), mark & model.mfalse, model.x, model.y);

showrgb(I, 'G', bwt, 'R', bwf, 'scale', 3)