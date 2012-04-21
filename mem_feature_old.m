function mpr = mem_feature_old(model, ffeat)
fname = sprintf('mem_feat_old%d.mat',model.fnumber);
if exist(fname, 'file')
    load(fname)
    return
end
    
%% Разделяющие признаки на мембраны
[mlen, merr, mint] = membrane_statistics(model, ...
    'Membrane length', 'Max distance', 'Tortle-Arc intensity');

xtrue = [];
xfalse = [];
for fnumber = ffeat
    tm = read_mark(fnumber);
    tm = connect_nodes(tm);
    
    [ml, me, mi] = membrane_statistics(tm, ...
        'Membrane length', 'Max distance', 'Tortle-Arc intensity');
    
    xtrue = [xtrue; [ml(tm.mtrue) me(tm.mtrue) mi(tm.mtrue)]];
    xfalse = [xfalse; [ml(tm.mfalse) me(tm.mfalse) mi(tm.mfalse)]];
end
% xtrue = [mlen(model.mtrue) merr(model.mtrue) mint(model.mtrue)];
% xfalse = [mlen(model.mfalse) merr(model.mfalse) mint(model.mfalse)];

%% Разделяющие признаки на мембраны: гистограммы


mfeatures = {mlen, merr, mint};
xname = {'membrane length','membrane-arc distance','membrane-arc intensity'};
xin = {0:10:110, 15, 15};
xout = cell(size(xin));
hfalse = cell(size(xin));
htrue = cell(size(xin));

for i = 1 : numel(xname)
    if numel(xin{i}) == 1
        xmax = max([xtrue(:,i); xfalse(:,i)]);
        xout{i} = 0:xmax/xin{i}:xmax;
    else
        xout{i} = xin{i};
    end
    htrue{i} = hist(xtrue(:,i),xout{i});
    htrue{i} = htrue{i} / sum(htrue{i});
    hfalse{i} = hist(xfalse(:,i),xout{i});
    hfalse{i} = hfalse{i} / sum(hfalse{i});
% 
%     figure, hold on
%     bar(xout{i},[htrue{i}' hfalse{i}'], 2.5)
%     legend('true','false')
%     xlabel(xname{i})
end

%% Список вероятностей мембран

% wb = waitbar(0,'Вычисляем вероятность мембран...');
mpr = zeros(model.memNumber,1);
for j = 1 : model.memNumber
	ptrue = 1;
	pfalse = 1;
	for i = 1 : numel(xin)
		mpar = mfeatures{i}(model.edges(j,1),model.edges(j,2));
		d = (xout{i}(2) - xout{i}(1))/2;
		ptrue = ptrue * htrue{i}(find(xout{i}+d>=mpar,1,'first'));
		pfalse = pfalse * hfalse{i}(find(xout{i}+d>=mpar,1,'first'));
	end
	mpr(j) = ptrue / (pfalse + ptrue);
% 	waitbar(j / model.memNumber, wb)
end
% close(wb)	

save(fname,'mpr')