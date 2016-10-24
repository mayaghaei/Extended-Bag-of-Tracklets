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

function [pts1, pts2, scores] = extract_correspondences2(I1, I2, sigma, threshold, radius, blocksize, alphacolor, alphacoord, use_color, useL2norm, num_scales, scale_factor, method)

if ~exist('method','var')
    method = 'INN';
end;

    scale = 1;
    pts1 = [];
    pts2 = [];
    scores = [];
    
    X = [];
    Y = [];

    for i = 1:num_scales
        [XX, ppts1] = harris_scaled(I1, scale, sigma, threshold, radius, blocksize, alphacolor, alphacoord, use_color, useL2norm);
        [YY, ppts2] = harris_scaled(I2, scale, sigma, threshold, radius, blocksize, alphacolor, alphacoord, use_color, useL2norm);

        pts1 = [pts1; ppts1];
        pts2 = [pts2; ppts2];
            
        X = [X; XX];
        Y = [Y; YY];
        scale = scale*scale_factor;
    end

    if ~isempty(X) && ~isempty(Y)
        if strcmp(method,'INN')==1
            [iidx1, iidx2, iscores] = INNmatching(X,Y,0.25,14);        
        else
            [iidx1, iidx2, iscores] = LLCmatching(X,Y,7);        
        end
        
        if ~isempty(iidx1)
            scores = iscores';
            pts1 = pts1(iidx1,:);
            pts2 = pts2(iidx2,:);
        end
    end

    if ~isempty(scores)
        [scores, ii] = sort(scores,'descend');
        %na = sum(scores>=thresholdscores);
        na = sum(scores>=0.5);
        %na = size(scores,1);
        %scores = scores(1:na,:);%uncomment it to go to original version
        %Maya
        pts1 = pts1(ii(1:na),:);
        pts2 = pts2(ii(1:na),:);
    end
end