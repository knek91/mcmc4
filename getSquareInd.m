function [inds a] = getSquareInd(x,y,siz)

[CX,CY] = getsquare(x,y);
inds = sub2ind(siz,min(max(floor(CX(:)),1),siz(1)),...
                    min(max(floor(CY(:)),1),siz(2)));
a = size(CX,1);