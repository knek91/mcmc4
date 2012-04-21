%%bw = tortle_draw(M, nlist, fnumber)
% Рисует черепашечьи пути по графу смежности 
%
% OUTPUT 
% binary image of tortle ways 
% 
% INPUT
% I 		 	gray image for tortle
% membranes		adjacency membrane matrix 
% x 			x coordinates of nodes
% y 			y coordinates of nodes
%
% OPTIONAL
% 'dcoef',0		
function bw = tortle_draw(I, membranes, x, y, varargin)

bw = false(size(I));
% wb = waitbar(0,'Чертим черепашку...');
for n1 = 1 : size(membranes,1)
    for n2 = n1+1 : size(membranes,2)
        if membranes(n1,n2)
			bw = tortle_bwdraw(I, bw, x([n1,n2]), y([n1,n2]), varargin{:});
        end
    end
%     waitbar(n1/size(membranes,1));
end
% close(wb)