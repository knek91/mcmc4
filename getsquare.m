%%[CX, CY] = getsquare(x,y)
% Получает список координат точек залитого квадтрата с диагональю [x; y]
function [CX, CY] = getsquare(x,y)
    if x(2) < x(1)
        x = x(2:-1:1);
        y = y(2:-1:1);
    end
    
    vd = [x(2)-x(1), y(2)-y(1)];
    len = sqrt(sum(vd.^2));
    a = floor ( len / sqrt(2) );
    
    vdr = vd(1) + 1i*vd(2);
    vdr1 = vdr * exp(1i*pi/4);
    vdr2 = vdr * exp(-1i*pi/4);
    
    vr = [real(vdr1) imag(vdr1)];
    vr = vr ./ sqrt(sum(vr.^2));
    vl = [real(vdr2) imag(vdr2)];
    vl = vl ./ sqrt(sum(vl.^2));
    if isnan(vr(1))
        vr = [0 0];
    end
    if isnan(vl(1))
        vl = [0 0];
    end
    
    
    A = [0:a; 0:a]';
    [CX,CY] = deal(zeros(a+1,a+1));
    X = bsxfun(@plus, bsxfun(@times, A, vr), [x(1) y(1)]);
    for xi = 1 : floor(a)+1
        CX(:,xi) = X(:,1);
        CY(:,xi) = X(:,2);
        X = bsxfun(@plus, X, vl);
    end
end