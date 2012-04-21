function W = turtle_ways(F)

s = size(F,1);
M = zeros(size(F)+2);
M(2:end-1,2:end-1) = F;
W = zeros(size(F)+2);
for i = s+1 :-1: 2
    for j = s+1 :-1: 2
        if i == s+1 && j == s+1
            W(i,j) = 1;
        else
            if W(i,j+1)~=0 && M(i,j) >= M(i-1,j+1)
                W(i,j) = W(i,j) + W(i,j+1);
            end
            if W(i+1,j)~=0 && M(i,j) >= M(i+1,j-1)
                W(i,j) = W(i,j) + W(i+1,j);
            end
        end
    end
end
W = W(2:end-1,2:end-1);