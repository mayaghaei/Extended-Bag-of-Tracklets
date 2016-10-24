%% SparseFlow codes by Radu Timofte
%
% This code is provided for research purposes and personal use.
%
% Please refer to:
% R. Timofte and L.Van Gool,
% "SparseFlow: Sparse Matching for Small to Large Displacement Optical Flow",
% WACV, 2015
% 
% latest changes:
%   09.03.2015, updated, cleaned up
%   25.03.2014, written

function [idx1, idx2, scores] = LLCmatching(X,Y,K)
        idx1 = [];
        idx2 = [];
        scores = [];
    if isempty(X) || isempty(Y)
        return;
    end
    [v1, i1] = LLC(Y',X',K);
    [v2, i2] = LLC(X',Y',K);    

    valid = i2(i1) == 1:1:size(X,1);
    idx1 = find(valid==1);
    if isempty(idx1)
        return;
    end
    idx2 = i1(idx1);
    scores = (v1(idx1) + v2(idx2))/2;
end