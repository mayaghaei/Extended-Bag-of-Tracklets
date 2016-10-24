
%This code is a modification of the sparse flow code to compute the optical
%flow between 2 images. The final score is mean of all scores.
function scoreMedia = SparseMatching(Img1,Img2)

% Image1 = imread('171948.jpg');
% Image2 = imread('171918.jpg');

Image1 = Img1;
Image2 = Img2;

% Harris corner parameters
sigma = 1;   
radius = 2;
threshold = 1;  

% patch features
use_color = 1;
blocksize = 1;%13;
alphacolor = 0.33;
alphacoord = 0.01;
useL2norm = 1;

% multiple scales
num_scales = 2;                            
scale_factor = 0.5;

% tic;
%    disp('Extract correspondences...');
   [pts1, pts2, scores] = extract_correspondences2(Image1, Image2, sigma, threshold, radius, blocksize, alphacolor, alphacoord, use_color, useL2norm, num_scales, scale_factor);
%     scoreMedia = mean(scores);
    scoreMedia = median(scores);
%   toc