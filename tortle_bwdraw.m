%%BW = tortle_bwdraw(I,BW,X,Y,'dcoef',0)
%���� ��������� ���� �� ����� [X(1) Y(1)] � ����� [X(2) Y(2)]
%�� ����� ����������� I � ������ ���� � BW (suze(BW) == size(I))
%���. ����� ������� ����������� ������������� ���� ���������.
function BW = tortle_bwdraw(I,BW,X,Y,varargin)

[CX,CY] = getsquare(X,Y);
inds = sub2ind(size(I),min(max(floor(CX(:)),1),size(I,1)), ...
    min(max(floor(CY(:)),1),size(I,2)));
tmp = reshape(I(inds),size(CX));

[~,L] = turtle(tmp,varargin{:});
BW(inds) = BW(inds) | L(:);