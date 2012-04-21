function res = intersected(x1,y1,x2,y2)

    res = false;
    
    if ((max(x1) >= min(x2) && max(x2) >= min(x1) && ...
         max(y1) >= min(y2) && max(y2) >= min(y1)))
        v1 = vect(x1(1),y1(1),x1(2),y1(2),x2(1),y2(1));
        v2 = vect(x1(1),y1(1),x1(2),y1(2),x2(2),y2(2));
        if v1 * v2 <= 0
            v3 = vect(x2(1),y2(1),x2(2),y2(2),x1(1),y1(1));
            v4 = vect(x2(1),y2(1),x2(2),y2(2),x1(2),y1(2));
            if v3 * v4 <= 0
                res = true;
            end
        end
    end

end
