%%x = norma1(x)
%adjusting to [0..1]
function x = norma1(x)
    x(x<0) = 0;
    x = double(x)/double(max(x(~isinf(x))));
end