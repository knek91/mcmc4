function im = groundtr(imname,fnumber)

if nargin == 1
    fnumber = '';
elseif ischar(fnumber)
else
    fnumber = char('0'+fnumber);
end
im = imread(sprintf('gt/%s%s.png',imname,fnumber));