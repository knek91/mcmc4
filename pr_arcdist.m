function [dx dy] = pr_arcdist(trt, arc, dist)
s = size(trt,1);

[dx dy] = deal(zeros(1,s));
for x = 1 : s
    y_arc = sqrt(arc(3)^2 - (x-arc(1))^2);
    if y_arc + arc(2) >= 0
        y_arc = y_arc + arc(2);
    elseif y_arc - arc(2) >= 0
        y_arc = y_arc - arc(2);
    else
        error('wtf? both of y(arc) are negative!')
    end
    dx(x) = dist(abs(find(trt(x,:)) - y_arc));
end
for y = 1 : s
    x_arc = sqrt(arc(3)^2 - (y-arc(2))^2);
    if x_arc - arc(1) >= 0 
        x_arc = x_arc - arc(1);
    elseif x_arc + arc(1) >= 0 
        x_arc = x_arc + arc(1);
    else 
        error('wtf? both of x(arc) are negative!')
    end
    dy(y) = dist(abs(find(trt(:,y))-x_arc));
end

dx = reshape(dx,1,s);
dy = reshape(dy,1,s);