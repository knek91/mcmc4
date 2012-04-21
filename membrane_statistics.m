function varargout = membrane_statistics(model, varargin)

I = norma1(groundtr('gray',model.fnumber));

for statInd = 1 : numel(varargin)
	switch varargin{statInd}
		case 'Tortle intensity'
			itort = zeros(model.nodNumber);
		case 'Arc intensity'
			iarc = zeros(model.nodNumber);
		case 'Membrane length'
			mlen = zeros(model.nodNumber);
		case 'Max distance'
			maxdst = zeros(model.nodNumber);
		case 'Mean distance'
			meandst = zeros(model.nodNumber);
		case 'Mean square distance'
			msd = zeros(model.nodNumber);
		case 'Tortle-Arc intensity'
			idiff = zeros(model.nodNumber);
		case 'Absolute intensity difference'
			aidiff = zeros(model.nodNumber);
		case 'Arc radius'
			arad = zeros(model.nodNumber);
        case 'Normal continuity'
            ncon = zeros(model.nodNumber);
		otherwise
			error('unknow satistic: ''%s''', varargin{statInd})
	end
end

bwnodes = model.lnodes > 0;
% wb = waitbar(0,['Computing: ' sprintf('%s; ',varargin{:})]);
for n1 = 1 : model.nodNumber
    % узел 1
    x1 = model.x(n1);
    y1 = model.y(n1);
    armap = bwnodes(x1:min(x1+model.nodrad,size(bwnodes,1)),...
        max(y1-model.nodrad,1):min(y1+model.nodrad,size(bwnodes,2)));
    [arlist,arsize] = getpixels(armap);
    for ari = 1 : arsize
        % узел 2
        [x2,y2] = deal(arlist(ari,1)+x1-1, max(y1-model.nodrad,1)+arlist(ari,2)-1);        
        l = ((x2-x1) ^ 2 + (y2-y1) ^ 2) ^ 0.5;

        if l <= model.nodrad

            n2 = model.lnodes(x2,y2);

            if n1 ~= n2 && x1 ~= x2 && y1 ~= y2 && model.mfull(n1,n2)

                % Выбираем квадрат с диагональю через узлы 1,2
                [CX,CY] = getsquare([x1,x2],[y1,y2]);
                inds = sub2ind(size(I),min(max(floor(CX(:)),1),size(I,1)),...
                    min(max(floor(CY(:)),1),size(I,2)));
                tmp = reshape(I(inds),size(CX));

                % Пускаем черепашку
                [E,L] = turtle(tmp);
                
                % Приближаем дугу
                [arcint, arcc, ~] = approx_arc(tmp, L);
                
                % Вычисляем статистики ввиде матриц смежности узлов
                for statInd = 1 : numel(varargin)
                    switch varargin{statInd}
                        case 'Tortle intensity'
                            itort(n1,n2) = E;
                            itort(n2,n1) = E;
                        case 'Arc intensity'
                            iarc(n1,n2) = arcint;
                            iarc(n2,n1) = arcint;
                        case 'Membrane length'
                            mlen(n1,n2) = l;
                            mlen(n2,n1) = l;
                        case 'Max distance'
                            [LX,LY] = ind2sub(size(L), find(L));
                            dst = abs(sqrt((LX-arcc(1)).^2 + (LY-arcc(2)).^2) - arcc(3));
                            maxdst(n1,n2) = max(dst);
                            maxdst(n2,n1) = max(dst);
                        case 'Mean distance'
                            [LX,LY] = ind2sub(size(L), find(L));
                            dst = abs(sqrt((LX-arcc(1)).^2 + (LY-arcc(2)).^2) - arcc(3));
                            meandst(n1,n2) = mean(dst);
                            meandst(n2,n1) = mean(dst);
                        case 'Mean square distance'
                            [LX,LY] = ind2sub(size(L), find(L));
                            dst = abs(sqrt((LX-arcc(1)).^2 + (LY-arcc(2)).^2) - arcc(3));
                            msd(n1,n2) = mean(dst.^2);
                            msd(n2,n1) = mean(dst.^2);
                        case 'Tortle-Arc intensity'
                            idiff(n1,n2) = E - arcint;
                            idiff(n2,n1) = E - arcint;
                        case 'Absolute intensity difference'
                            aidiff(n1,n2) = abs(E-arcint);
                            aidiff(n2,n1) = abs(E-arcint);
                        case 'Arc radius'
                            arad(n1,n2) = arcc(3);
                            arad(n2,n1) = arcc(3);
                        case 'Normal continuity'
                            t = normcont(tmp,L);
                            ncon(n1,n2) = t;
                            ncon(n2,n1) = t;
                    end
                end
            end
        end
    end
%     waitbar(n1/model.nodNumber, wb)
end
% close(wb)

varargout = {};
for statInd = 1 : numel(varargin)
    switch varargin{statInd}
        case 'Tortle intensity'
            varargout = [varargout, itort];
        case 'Arc intensity'
            varargout = [varargout, iarc];
        case 'Membrane length'
            varargout = [varargout, mlen];
        case 'Max distance'
            varargout = [varargout, maxdst];
        case 'Mean distance'
            varargout = [varargout, meandst];
        case 'Mean square distance'
            varargout = [varargout, msd];
        case 'Tortle-Arc intensity'
            varargout = [varargout, idiff];
        case 'Absolute intensity difference'
            varargout = [varargout, aidiff];
        case 'Arc radius'
            varargout = [varargout, arad];
        case 'Normal continuity'
            varargout = [varargout, ncon];
    end
end