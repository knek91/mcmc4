function show_turtle(model, mark)

I = norma1(groundtr('gray',model.fnumber)) / 5;
bwt = tortle_draw(I, mark, model.x, model.y);
gt = groundtr('mark',model.fnumber);
bw = extractcol(gt,[0 0 255]);
bw = bw | extractcol(gt,[255 0 0]);
I(imdilate(bw,ones(3))) = 1/5;
bw5 = imdilate(bw,ones(8));
showrgb(I, 'G', bwt & bw5, 'R', bwt &~ bw5, 'scale', 3)