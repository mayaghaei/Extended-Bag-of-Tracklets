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


addpath SparseFlow/
addpath Kovesi/

% Harris corner parameters
sigma = 1;   
radius = 2;
threshold = 1;  

% patch features
use_color = 1;
blocksize = 13;
alphacolor = 0.33;
alphacoord = 0.01;
useL2norm = 1;

% multiple scales
num_scales = 2;                            
scale_factor = 0.5;

Image1 = imread('grimpe1.png');
Image2 = imread('grimpe2.png');

tic;
   disp('Extract correspondences...');
   [pts1, pts2, scores] = extract_correspondences2(Image1, Image2, sigma, threshold, radius, blocksize, alphacolor, alphacoord, use_color, useL2norm, num_scales, scale_factor);
toc
if ~isempty(pts1)
    MM = [pts1 pts2 scores];         
else
    MM = [];
end

MM2 = MM;
if ~isempty(MM2)
    MM2(:,1:4) = round(MM2(:,1:4));
end
    
dlmwrite(path_matches, MM2, 'delimiter', ' ');

disp('Variational SparseFlow computation...');
tic;system(['./fastdeepflow-static ' path_img1 ' ' path_img2 ' ' path_flow ' -sintel -matchf ' path_matches]);toc
% For the variational details please check Weinzaepfel et al, ICCV 2013 paper on DeepFlow method
