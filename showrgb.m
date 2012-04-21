%%[RGB] = rgbshow(I,'R',[],'G',[],'B',[],'scale',1,'norma',false,'show',true)
% Раскрашивает серое изображение c помощью бинарных масок RGB
function varargout = showrgb(I,varargin)

Z = [];
[R,G,B,scale,donorm,show] = ...
    myparse(varargin,'R',Z,'G',Z,'B',Z,'scale',1,'norma',false,'show',true);

I = im2double(I);

if donorm
    I = norma1(I);
end

if numel(I) == 1 && I == 0
    I = zeros([max([size(R,1) size(G,1) size(B,1)]),...
        max([size(R,2) size(G,2) size(B,2)])]);
end

if size(I,3) == 3
    I = rgb2gray(I);
end

if scale < 0
    scale = ones(-scale);
    R = imerode(R,scale);
    G = imerode(G,scale);
    B = imerode(B,scale);
else
    scale = ones(scale);
    R = imdilate(R,scale);
    G = imdilate(G,scale);
    B = imdilate(B,scale);
end

[I1,I2,I3] = deal(I);
I1(R) = 1;
I2(G) = 1;
I3(B) = 1;
rgb = reshape([I1,I2,I3],[size(I) 3]);

if nargout == 1
    varargout = {rgb};
end
if show
    imshow(rgb,'InitialMagnification','fit')
end