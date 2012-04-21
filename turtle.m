%%[E, L] = tortle(I,'dcoef',0)
%Чертит черепаший путь в прямоугольнике I.
%Вход:
%I			серый прямоугольник для черепашки
%
%Доп: 
%'dcoef',0	коэффициент диагонального хода
%
%Output:
%Е		средняя интенсивность пути
%L		бинарная маска пути (size(L)==size(I))
%(fail) LXY	координаты пути
function [E, L, F] = turtle(I)
    
    F = I;
    F(1:end, 1) = cumsum(F(1:end, 1));
    F(1, 1:end) = cumsum(F(1, 1:end));
    for i = 2 : size(F,1)
        for j = 2 : size(F,2)
            F(i,j) = max([F(i-1,j),F(i,j-1)]) + I(i,j);
        end
    end
    
    L = false(size(F));
    len = 0;
    [x,y] = deal(size(F,1),size(F,2));
    while x ~= 1 && y ~= 1
        L(x,y) = true;
        if F(x-1,y) > F(x,y-1)
            x = x - 1;
        else
            y = y - 1;
        end
    end
    
    if x == 1
        L(1,1:y) = true;
    elseif y == 1
        L(1:x,1) = true;
    end
	
	E = F(end) / nnz(L);
    
%     figure
%     subplot(1,2,1),imshow(imtophat(I,strel('disk',5)))
%     subplot(1,2,2),imshow(L),title(E)
%     imwrite(L,sprintf('test%d.bmp',size(L,1)))
end