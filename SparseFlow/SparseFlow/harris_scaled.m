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

function [X, pts] = harris_scaled(I, scale, sigma, threshold, radius, blocksize, alphacolor, alphacoord, usecolor, useL2norm)

    if scale~= 0
        I = imresize(I,scale);
    end
    
    if usecolor==1 && size(I,3) > 1
        gI = rgb2gray(I);
    else
        gI = I;
    end        
    
    [cim, r, c] = harris(gI, sigma, threshold, radius);                            
                           
    [feats, pts] = extractFeatures(gI,[c r],'Method','Block','BlockSize',blocksize);
    spts = pts;
    spts(:,1) = spts(:,1)/size(I,2);
    spts(:,2) = spts(:,2)/size(I,1);
    
    pts = pts/scale;
    
    if usecolor==1 && size(I,3) > 1
        [featsR]= extractFeatures(I(:,:,1),[c r],'Method','Block','BlockSize',blocksize);
        [featsG] = extractFeatures(I(:,:,2),[c r],'Method','Block','BlockSize',blocksize);
        [featsB] = extractFeatures(I(:,:,3),[c r],'Method','Block','BlockSize',blocksize);
        featsR = mean(featsR,2);
        featsG = mean(featsG,2);
        featsB = mean(featsB,2);
        X = [double(feats) size(feats,2)*alphacolor*double(featsR) size(feats,2)*alphacolor*double(featsG) size(feats,2)*alphacolor*double(featsB) size(feats,2)*alphacoord*255*spts];        
    else
        X = [double(feats) size(feats,2)*alphacoord*255*spts];         
    end
    if useL2norm == 1
        X = normalize_data(X,'l2');
    end
end