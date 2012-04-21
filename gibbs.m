%%iters = gibbs(model, varargin)
%
% varargin:
% maxiter   число итераций (10)
% minit     начальная разметка (Deloney triangulation)
% umark     сохранять разметку на каждой итерации (false)
% ucross    запрещать пересечения (false)
% uarea     использовать площади клеток (false)
% savefin   сохранить результирующую разметку в файл ('')
% saveall   сохранять разметку на каждой итерации в папку ('')
% savelog   сохранить таблицу (precision, recall, ...) в файл ('')
%
% iters: structure
% energy(i) энергия
% prec(i)   точность 
% recall(i) полнота
% musage(i) включено мембран
% time(i)   время от начала работы до итерации i
% maxiter   число итераций
% mark{i}   разметка на итерации i   
% mbest     разметка с мин энергией
% minit     начальная разметка
function iters = gibbs(model, varargin)

timer = tic;

[maxiter, minit, umark, ucross, uarea, ...
    nodfeat, savefin, saveall, savelog] = ...
    myparse(varargin, 'maxiter', 10, ... 
                      'minit', dtri(model), ...
                      'umark', false,...
                      'ucross', false,...
                      'uarea', false,...
                      'nodfeat', true,...
                      'savefin', [],...
                      'saveall', [],...
					  'savelog', []);

iters = struct();
iters.energy = zeros(1,maxiter) * NaN;
iters.prec = zeros(1,maxiter) * NaN;
iters.recall = zeros(1,maxiter) * NaN;
iters.musage = zeros(1,maxiter) * NaN;
iters.time = zeros(1,maxiter-1) * NaN;
iters.maxiter = maxiter;

if umark
	iters.mark = cell(1,maxiter);
end

if uarea
    ucross = true;
    model.mprob(model.border | model.border') = 1;
    model.mpr = adj2val(model.mprob, model.edges);
end

mcur = minit;
mlist = adj2val(mcur, model.edges);
iters.mbest = minit;
iters.minit = minit;
iters.mbest_energy = inf;

if ~isempty(saveall) && ~exist(saveall, 'dir')
    mkdir(saveall);
end

if ~isempty(savefin)
    pathstr = fileparts(savefin);
    if ~isempty(pathstr) && ~exist(pathstr, 'dir')
        mkdir(pathstr);
    end
end

foutput = 1;
if ~isempty(savelog) 
    pathstr = fileparts(savelog);
	if ~isempty(pathstr) && ~exist(pathstr, 'dir')
        mkdir(pathstr);
	end
	f = fopen(savelog,'w');
	foutput = [foutput f];
end

for fout = foutput
    fprintf(fout, 'gibbs scheme (file: %d; nocross: %d; uarea: %d)\n', model.fnumber, ucross, uarea);
    if ~islogical(nodfeat)
        model.use_nodfeat = nodfeat;
        fprintf(fout, 'using node features:');
        if isempty(nodfeat)
            fprintf(fout, ' none');
        else
            fprintf(fout, ' %s;', nodfeat{:});
        end
        fprintf(fout, '\n');
    end
    fprintf(fout, 'true energy: %.0f\n', energy(model.mtrue, model.mmark, model, uarea));
end

for iter = 1 : maxiter 
   % статистика
   iters.energy(iter) = energy(mcur, mlist, model, uarea);
   iters.prec(iter) = nnz(model.mtrue & mcur) / nnz(mcur);
   iters.recall(iter) = nnz(model.mtrue & mcur) / nnz(model.mtrue);
   iters.musage(iter) = nnz(mcur) / nnz(model.mfull);
   
   for fout = foutput
	   fprintf(fout, 'img: %2d; iter: %2d; energy: %6.0f; musage: %6.2f%%; prec: %6.2f%%; recall: %6.2f%%\n',...
		   model.fnumber, ...
           iter, ...
		   iters.energy(iter), ...
		   100 * iters.musage(iter),...
		   100 * iters.prec(iter),...
		   100 * iters.recall(iter));
   end
   
   if ~isempty(saveall)
       figure,show_lines(model,mcur)
       title(sprintf('iter %d; energy: %.0f', iter, iters.energy(iter)))
       pngsave('%s/%d', saveall, iter);
       close;
   end
   
   % лучшая энергия
   if iters.energy(iter) < iters.mbest_energy
       iters.mbest_energy = iters.energy(iter);
       iters.mbest = mcur;
   end
   
   if umark
		iters.mark{iter} = mcur;
   end
   
   if iter == maxiter
       break
   end
   
   % проход по мембранам
   for j = randperm(model.memNumber)       		       
        n1 = model.edges(j,1);
        n2 = model.edges(j,2);
		if model.mpr(j) == 1
            mcur(n1, n2) = true;
            mcur(n2, n1) = true;
            mlist(j) = true;
        else			
			mcur(n1, n2) = false;
			mcur(n2, n1) = false;
			pfalse = (1 - model.mpr(j)) * joint(n1, mcur, model) * joint(n2, mcur, model);
            
			mcur(n1, n2) = true;
			mcur(n2, n1) = true;
			ptrue = model.mpr(j) * joint(n1, mcur, model) * joint(n2, mcur, model);
			
            if ucross && ptrue > 0
                for j2 = find(mlist)'
                    if model.mcross(j,j2)
                        ptrue = 0;
                        break
                    end
                end
            end
            
			% cell area
            if uarea && ptrue > 0 && pfalse > 0
                s1 = left_cell([n1 n2], mcur, model, model.border);
                s2 = left_cell([n2 n1], mcur, model, model.border);
                
                if ~isnan(s1) && ~isnan(s2)
                    p1 = cellprob(s1, model);
                    p2 = cellprob(s2, model);
                    p0 = cellprob(s1+s2, model);
                    
                    ptrue = ptrue * p1 * p2;
                    pfalse = pfalse * p0;
                end
            end
			
			cur = rand < ptrue / (ptrue + pfalse);
			mcur(n1, n2) = cur;
			mcur(n2, n1) = cur;
            mlist(j) = cur;
		end
   end
   
   iters.time(iter) = toc(timer);
   
end

for fout = foutput
    fprintf('iter mean time: %.2f\n', mean(iters.time(2:end)-iters.time(1:end-1)))
end

if ~isempty(savefin)
    figure, show_lines(model,iters.mbest), title(min(iters.energy))
    pngsave('%s', savefin);
    close;
end

if ~isempty(savelog)
	fclose(foutput(2));
end