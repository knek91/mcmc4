function varargout = mem_thresholding(mpr, mmark, thresh)

if nargin == 2
    thresh = 0 : 0.001 : 1;
end

[prec,recall] = deal(zeros(1,numel(thresh)));
for i = 1 : numel(thresh)
   tmark = mpr > thresh(i);
   prec(i) = nnz(mmark & tmark) / nnz(tmark);
   recall(i) = nnz(mmark & tmark) / nnz(mmark);
end
fscore = 2 * prec .* recall ./ (prec + recall);


if nargout == 0
    varargout = {};
    
    [maxfs, maxi] = max(fscore);
    fprintf('max fscore: %.4f\n', maxfs)

    figure
    plot(prec,recall,'LineWidth', 2)
    title(sprintf('max fscore: %.4f', maxfs))
    hold on
    plot(prec(maxi),recall(maxi),'.r','LineWidth',2)
    xlabel('recision')
    ylabel('recall')
else
    varargout = {fscore, prec, recall};
end