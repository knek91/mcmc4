function fesave(name,varargin)

name = sprintf(name,varargin{:});
hgsave([name '.fig'])
print('-depsc','-tiff','-r300',name)