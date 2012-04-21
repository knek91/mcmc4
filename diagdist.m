function dst = diagdist(trt_x, trt_y, s)

dst = zeros(1,numel(trt_x));
for i = 1 : numel(trt_x)
    dst(i) = abs( -s * trt_x(i) + s * trt_y(i) ) / sqrt(2 * s^2);
end
