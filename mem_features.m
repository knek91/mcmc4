function [X, Y, feat_names] = mem_features(fnumbers)

X = [];
Y = false(0);

% read features names
f = fopen('mfeatures.txt','r');
feat_names = {};
while ~feof(f)
    s = fgetl(f);
    feat_names = [feat_names, s];
end
fclose(f);
% normalization
for i = 1 : numel(feat_names)
    feat_names = [feat_names, [feat_names{i} ' (normalized)']];
end

for fnumber = fnumbers
    
    fname = sprintf('mem_features%d.mat', fnumber);
    model = read_mark(fnumber);
    model = connect_nodes(model);

    if exist(fname,'file')
        load(fname)
    else    
        f = zeros(1, 2 * 37);
        feat = zeros(model.memNumber, numel(f));

        I = norma1(groundtr('gray',model.fnumber));
        wb = waitbar(0, 'Extracting membrane features...');
        for j = 1 : size(model.edges,1)
            n = model.edges(j,:);
            [inds, s] = getSquareInd(model.x(n), model.y(n), size(I));
            img = reshape(I(inds),s,s);
            [trt_int, trt, F] = turtle(img);
            [arc_int, arc, bwarc] = approx_arc(img, trt);    

            % Turtle sum intensity
            feat(j,1) = sum(img(trt));

            % Arc mean intensity 
            feat(j,2) = arc_int;

            % Membrane length
            feat(j,3) = s;

            % TA max,mean,std distance (euclidian)
            [trt_x,trt_y] = ind2sub(size(trt), find(trt));
            dst = arcdist(trt_x, trt_y, arc);
            feat(j,4) = max(dst);
            feat(j,5) = mean(dst);
            feat(j,6) = std(dst);

            % TA mean intensity difference
            feat(j,7) = trt_int - arc_int;

            % Arc radius
            feat(j,8) = arc(3);

            % TA max,mean,std distance (chess, max)
            [dx dy] = pr_arcdist(trt, arc, @max);
            feat(j,9) = max([dx dy]);
            feat(j,10) = mean([dx dy]);
            feat(j,11) = std([dx dy]);

            % TA max,mean,std distance (chess, mean)
            [dx dy] = pr_arcdist(trt, arc, @mean);
            dst = [dx dy];
            feat(j,12) = max(dst);
            feat(j,13) = mean(dst);
            feat(j,14) = std(dst);

            % TA number, value of intensity peaks
            tpeaks = findpeaks(img(trt));
            apeaks = findpeaks(img(bwarc)); 
            feat(j,15) = numel(tpeaks);
            feat(j,16) = numel(apeaks);
            feat(j,17) = numel(max(tpeaks));
            feat(j,18) = numel(max(apeaks));

            % T max,mean,std chess distance to border
            dstx = min(trt_x - 1, s - trt_x);
            dsty = min(trt_y - 1, s - trt_y);
            dst = [dstx(:); dsty(:)];
            feat(j,19) = max(dst);
            feat(j,20) = mean(dst);
            feat(j,21) = std(dst);

            % T discontinuity number; max, mean, std value, min-max
            dy = sum(trt,1);
            dx = sum(trt,2)';
            dd = [dy dx]-1;
            feat(j,22) = nnz(dd);
            feat(j,23) = max(dd);
            feat(j,24) = mean(dd);
            feat(j,25) = std(dd);
            feat(j,26) = min(max(dx,dy));

            % Turtle-diagonal max,mean,std chess max,mean distance
            [~,~,dd] = pr_diagdist(trt,@max);
            feat(j,27) = max(dd);
            feat(j,28) = mean(dd);
            feat(j,29) = std(dd);

            [~,~,dd] = pr_diagdist(trt,@mean);
            feat(j,30) = max(dd);
            feat(j,31) = mean(dd);
            feat(j,32) = std(dd);

            % TD max,mean,std euclidian distance
            dst = diagdist(trt_x, trt_y, s);
            feat(j,33) = max(dst);
            feat(j,34) = mean(dst);
            feat(j,35) = std(dst);

            % T equal ways area, log number
            W = turtle_ways(F);
            feat(j,36) = nnz(W);
            feat(j,37) = log(W(1,1));

            % Normalization 
            feat(j,38:end) = feat(j,1:37) / s;

            %%%%%%%%%%%%%%%%%%%%%%%%

            if mod(j, 100) == 0
                waitbar(j / model.memNumber,wb);
            end
        end

        close (wb);

        save(fname, 'feat')
    end
    
    X = [X; feat];
    Y = [Y; model.mmark];
end



