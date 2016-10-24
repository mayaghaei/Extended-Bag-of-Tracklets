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

function [val,idx] = LLC(X,Y,K)

val = [];
idx = [];
if isempty(X) || isempty(Y)
    return;
end;

[D,N] = size(Y);
% STEP1: COMPUTE PAIRWISE DISTANCES & FIND NEIGHBORS 

distance = X'*Y;
[sorted,index] = sort(distance,1,'descend');
if size(distance,1) > K    
    neighborhood = index(1:K,:);
else
    K = size(distance,1);
    neighborhood = index(1:K,:);
end

% STEP2: SOLVE FOR RECONSTRUCTION WEIGHTS

if(K>D) 
  fprintf(1,'   [note: K>D; regularization will be used]\n'); 
  tol=1e-3; % regularlizer in case constrained fits are ill conditioned
else
  tol=0;
end

W = zeros(K,N);
val = zeros(1,N);
idx = zeros(1,N);

for ii=1:N
   z = X(:,neighborhood(:,ii))-repmat(Y(:,ii),1,K); % shift ith pt to origin
   C = z'*z;                                        % local covariance
   C = C + eye(K,K)*tol*trace(C);                   % regularlization (K>D)
   %W(:,ii) = C\ones(K,1);                           % solve Cw=1   
   %W(:,ii) = W(:,ii)/sum(W(:,ii));                  % enforce sum(w)=1
   
   % modified
   W(:,ii) = abs(C\ones(K,1));                      % solve Cw=1 and take abs  
   W(:,ii) = W(:,ii)/sum(W(:,ii));                  % enforce sum(w)=1
   
   [val(ii) idx(ii)] = max(W(:,ii),[],1);
   idx(ii) = neighborhood(idx(ii),ii);
end;

end