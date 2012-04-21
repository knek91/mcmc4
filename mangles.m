function mang = mangles(model)

mang = zeros(size(model.mfull));
for n1 = 1 : model.nodNumber
    for n2 = 1 : model.nodNumber
        if model.mfull(n1,n2)
            n = [n1,n2];
            a = angle(model.x(n(1)) - model.x(n(2)) + 1i * (model.y(n(1)) - model.y(n(2))));
            a = mod(a, 2*pi);
            a = min(a, 2*pi - a);
            a = round(a / pi * 180);
            mang(n1,n2) = a;
        end
    end
end