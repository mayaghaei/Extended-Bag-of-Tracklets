%% written by Radu Timofte
%
% Reference:
% R. Timofte and L.Van Gool,
% "Iterative Nearest Neighbors for Classification and Dimensionality Reduction",
% CVPR, 2012
% 
% latest update: 31.07.2013
% 27.04.2014, replaced max(res) with max(res,[],1)

function [W]    = INN_blocky(X, y, gamma, blocksize, K, verbose)

if ~exist('gamma','var')
    gamma = 0.25;
end;
if ~exist('blocksize','var') || (blocksize > size(y,1))
    blocksize = size(y,1);
end;
if ~exist('verbose','var')
    verbose = 0;
end;
if ~exist('K','var')
K = ceil(-log(0.05)/log(1+gamma));    	
if verbose == 1
    fprintf('K = %g\n',K);
end
end;

if gamma < 0
    beta = abs(gamma);
    gamma = exp(-log(1-beta)/K)-1;
end

W = zeros(size(y,1),size(X,1));

start_INNC_blocky = tic;

for iter1 = 1:blocksize:size(y,1)
    if iter1+blocksize-1 > size(y,1)
        blocksize = size(y,1)-iter1+1;
    end
    if verbose == 1
        fprintf('Block %g-%g\n',iter1,iter1+blocksize-1);
    end        
         temp = y(iter1:iter1+blocksize-1,:);         
         WW = zeros(blocksize,size(X,1));
         for k = 1:K
            res = X * temp';
            [HHH, ID] = max(res,[],1);
            %res = EuDist2(tr_feats,temp,0);
            %res = EuDist2(tr_feats,temp);
            %[HHH, ID] = min(res);
            ID2 = [1:size(ID,2)]+size(temp,1)*(ID-1);                        
            WW(ID2) = WW(ID2) + gamma/(1.0+gamma)^k;            
            temp = temp + gamma*(temp - X(ID,:));            
         end; 
         W(iter1:iter1+blocksize-1,:) = WW;    
    if verbose==1
        toc(start_INNC_blocky);    
    end
end