function [pixels, count] = getpixels(map)
    p = regionprops(map,'PixelList');
    pixels = [];
    count = 0;
    for i = 1 : size(p,1)
        for j = 1 : size(p(i).PixelList,1)
            count = count + 1;
            pixels = [pixels; p(i).PixelList(j,2),...
                p(i).PixelList(j,1)];
        end
    end
end