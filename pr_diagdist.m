function [dx dy dd] = pr_diagdist(trt, dist)

s = size(trt,1);
[dx dy] = deal(zeros(1,s));
for i = 1 : s
    dx(i) = (abs(i-dist(find(trt(:,i)))));
    dy(i) = (abs(i-dist(find(trt(i,:)))));
end
dx = reshape(dx,1,s);
dy = reshape(dy,1,s);
dd = [dx dy];