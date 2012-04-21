function model = read_mark(fnumber)

fname = sprintf('mark%d.mat', fnumber);
if exist(fname,'file')
    load(fname);
    return
end

mn = groundtr('mark',fnumber);
mn = im2double(mn);

bwmem = extractcol(mn, [0 0 1]);
bwnodes = extractcol(mn, [1 0 0]);
bwmem = bwmem &~ imdilate(bwnodes, ones(3));

lnodes = bwlabel(bwnodes,8);
lmem = bwlabel(bwmem,8);

nstats = regionprops(lnodes, 'Area', 'PixelList');
[x,y] = deal(zeros(numel(nstats,1)));
for s = 1 : numel(nstats)
    if nstats(s).Area > 1
        error('Узел имеет более одного пикселя!')
    else
        x(s) = nstats(s).PixelList(1,2);
        y(s) = nstats(s).PixelList(1,1);
    end
end

memnum = max(lmem(:));
nodnum = max(lnodes(:));
adj = false(nodnum,nodnum);
nodrad = -inf;

for m = 1 : memnum
    mem = imdilate(lmem == m, ones(7));
    nodlist = lnodes(mem);
    nodlist = nodlist(logical(nodlist));
    if numel(nodlist) > 2
        figure, showrgb(groundtr, 'B', bwmem, 'R', mem), hold on
        plot(y, x, '*')
        plot(y(nodlist),x(nodlist),'*r')
        error('Мембрана соединяет более двух узлов!')
    elseif numel(nodlist) == 0
        figure, imshow(mem), hold on
        plot(y, x, '*')
        error('Мембрана соединяет ноль узлов!')
    elseif numel(nodlist) == 2
        adj(nodlist(2),nodlist(1)) = true;
        adj(nodlist(1),nodlist(2)) = true;
		nodrad = max(nodrad, ((x(nodlist(2))-x(nodlist(1)))^2 + (y(nodlist(2))-y(nodlist(1)))^2)^0.5);
    end
end

%% model
model = struct();
model.nodrad = ceil(nodrad);
model.x = x;
model.y = y;
model.lnodes = lnodes;
model.mtrue = adj;
model.fnumber = fnumber;
model.nodNumber = numel(x);

%% saving
save(fname, 'model');