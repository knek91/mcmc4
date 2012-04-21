function bw = extractcol(rgb, col)

bw = rgb(:,:,1) == col(1) & rgb(:,:,2) == col(2) & rgb(:,:,3) == col(3);