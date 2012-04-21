function [X, Y] = mem_features(fnumbers)

X = [];
Y = false(0);

for fnumber = fnumbers
    
    fname = sprintf('mem_features%d.mat', fnumber);

    if exist(fname,'file')
        load(fname)
    else    
        model = read_mark(fnumber);
        model = connect_nodes(model);

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
            f(1) = sum(img(trt));

            % Arc mean intensity 
            f(2) = arc_int;

            % Membrane length
            f(3) = s;

            % TA max,mean,std distance (euclidian)
            [trt_x,trt_y] = ind2sub(size(trt), find(trt));
            dst = arcdist(trt_x, trt_y, arc);
            f(4) = max(dst);
            f(5) = mean(dst);
            f(6) = std(dst);

            % TA mean intensity difference
            f(7) = trt_int - arc_int;

            % Arc radius
            f(8) = arc(3);

            % TA max,mean,std distance (chess, max)
            [dx dy] = pr_arcdist(trt, arc, @max);
            f(9) = max([dx dy]);
            f(10) = mean([dx dy]);
            f(11) = std([dx dy]);

            % TA max,mean,std distance (chess, mean)
            [dx dy] = pr_arcdist(trt, arc, @mean);
            dst = [dx dy];
            f(12) = max(dst);
            f(13) = mean(dst);
            f(14) = std(dst);

            % TA number, value of intensity peaks
            tpeaks = findpeaks(img(trt));
            apeaks = findpeaks(img(bwarc)); 
            f(15) = numel(tpeaks);
            f(16) = numel(apeaks);
            f(17) = numel(max(tpeaks));
            f(18) = numel(max(apeaks));

            % T max,mean,std chess distance to border
            dstx = min(trt_x - 1, s - trt_x);
            dsty = min(trt_y - 1, s - trt_y);
            dst = [dstx(:); dsty(:)];
            f(19) = max(dst);
            f(20) = mean(dst);
            f(21) = std(dst);

            % T discontinuity number; max, mean, std value, min-max
            dy = sum(trt,1);
            dx = sum(trt,2)';
            dd = [dy dx]-1;
            f(22) = nnz(dd);
            f(23) = max(dd);
            f(24) = mean(dd);
            f(25) = std(dd);
            f(26) = min(max(dx,dy));

            % Turtle-diagonal max,mean,std chess max,mean distance
            [~,~,dd] = pr_diagdist(trt,@max);
            f(27) = max(dd);
            f(28) = mean(dd);
            f(29) = std(dd);

            [~,~,dd] = pr_diagdist(trt,@mean);
            f(30) = max(dd);
            f(31) = mean(dd);
            f(32) = std(dd);

            % TD max,mean,std euclidian distance
            dst = diagdist(trt_x, trt_y, s);
            f(33) = max(dst);
            f(34) = mean(dst);
            f(35) = std(dst);

            % T equal ways area, log number
            W = turtle_ways(F);
            f(36) = nnz(W);
            f(37) = log(W(1,1));

            % Normalization 
            f(38:end) = f(1:37) / s;

            %%%%%%%%%%%%%%%%%%%%%%%%

            feat(j,:) = f;

            if mod(model.memNumber, 100) == 0
                waitbar(j / model.memNumber,wb);
            end
        end

        close (wb);

        save(fname, 'feat')
    end
    
    X = [X; feat];
    Y = [Y; model.mmark];
end



