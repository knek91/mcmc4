function pngsave(name,varargin)

name = sprintf(name,varargin{:});
print('-dpng','-r100',name)