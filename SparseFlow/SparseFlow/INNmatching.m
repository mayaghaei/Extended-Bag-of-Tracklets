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

function [idx1, idx2, scores] = INNmatching(X,Y,lambda,K)
        idx1 = [];
        idx2 = [];
        scores = [];
    if isempty(X) || isempty(Y)
        return;
    end
    coeffX = INN_blocky(Y,X,lambda,1000,K)';
    coeffY = INN_blocky(X,Y,lambda,1000,K)';
    [v1, i1] = max(abs(coeffX),[],1);
    [v2, i2] = max(abs(coeffY),[],1);

    valid = i2(i1) == 1:1:size(X,1);
    idx1 = find(valid==1);
    if isempty(idx1)
        return;
    end
    idx2 = i1(idx1);
    scores = (v1(idx1) + v2(idx2))/2;
end