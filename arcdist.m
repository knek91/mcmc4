function dst = arcdist(x, y, arc)

dst = abs(sqrt((x-arc(1)).^2 + (y-arc(2)).^2) - arc(3));