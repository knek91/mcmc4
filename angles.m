%%a = angles(nnumber, membranes, x, y)
%
% INPUT
% nnumber 		number of the node 
% membranes 	membranes adjacency matrix 
% x				vector of node x-coordinates 
% y 			vector of node y-coordinates
% 
% OUTPUT
% a 			angles btw membranes in the node (rounded degree measures)
function a = angles(nnumber, membranes, x, y)

X = x(membranes(nnumber,:))-x(nnumber);
Y = y(membranes(nnumber,:))-y(nnumber);

if numel(X) <= 1 % number of membranes
	a = 0;
	return
end

a = angle(X + Y*1i);
a = sort(a);
a = a([2:end 1]) - a;
a = mod(a, 2*pi);
a = min(a, 2*pi - a);

a = round(a / pi * 180);
 