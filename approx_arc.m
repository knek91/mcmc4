function [intens_max, c, bw] = approx_arc(I, varargin)

a = size(I,1);
p1 = [a - a / sqrt(2), a / sqrt(2)];
p2 = [a / sqrt(2), a - a / sqrt(2)];
v = p2 - p1;
d = sum(v .^ 2);
if d == 0
    error('d == 0, size of I is %d', a)
end
v = v / sqrt(d);

mapx = repmat((1:size(I,1))',1,size(I,2));
mapy = repmat(1:size(I,2),size(I,1),1);

intens_max = -inf;
bw = [];
p = p1;
while sum((p-p1).^2) < d
    x = (2 * p(2) * a - p(1)^2 - p(2)^2) / (2 * (p(2) - p(1)));
    if isnan(x)
        error('x is nan! a == %d', a);
    end
    y = a - x;
    r = sqrt(x^2 + y^2);
    
%     bwarc = abs((x - mapx).^2 + (y - mapy).^2 - r^2) < 2*r;
    [~, mini] = min(abs((x - mapx).^2 + (y - mapy).^2 - r^2));
    bwarc = false(size(I));
    mini(1) = 1;
    mini(a) = a;
    for i = 1 : a - 1
        bwarc(mini(i):mini(i+1),i) = true;
    end
    intens = mean(I(bwarc));
    if intens_max < intens 
        intens_max = intens;
        c = [x,y,r];
        bw = bwarc;
    end
    
    p = p + v;
end

% if a > 60
%     L = varargin{1};
% 
%     figure
%     subplot(1,3,1)
%     showrgb(norma1(I))
%     title('Original')
% 
%     subplot(1,3,2)
%     showrgb(I,'R',L)
%     title('Turtle')
%     xlabel(sprintf('Mean intensity: %.2f', mean(I(L))))
%     
%     subplot(1,3,3)
%     showrgb(I,'B',bw)
%     title('Arc')
%     xlabel(sprintf('Mean intensity: %.2f', mean(I(bw))))
% end