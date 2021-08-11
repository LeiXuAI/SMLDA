function [regressionC, regressionB] = train_LinearRidgeRegression(train_data,train_target,mu)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is to train a multi0-output ridge regressor.
% Editor: Jianhua XU (xujianhua@njnu.edu.cn)
% Date: May, 2015.

% Input:
%   train_data --  a (N*D) training data matrix, where each row indicates a instance                            
%       train_label --  a (N*K) binary label matrix
%       mu -- regularization constant, default = 0.1
% Output: 
% regC -- regression coefficients, where each row indicates a classifier
% regB -- regression bias terms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (nargin<3) mu = 0.1; end
%==========================================================================


    [N, D] = size(train_data);
    
    train_data = [train_data, ones(N, 1)];
    
    S = train_data' * train_data + mu * eye(D+1);
    w = pinv(S) * train_data' * train_target;
    
    regressionC = w(1:D,:)';
    regressionB = w(D+1,:)';
    
end