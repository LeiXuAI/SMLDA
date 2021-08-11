
function [W] = weight_Xu2017_Dependence(X,Y)
% To estimate weight matrix via maximizing HSIC0
% Designed by Jianhua Xu (xujianhua@njnu.edu.cn)
% 2015-05-21
% INPUT:
% X -- A feature matrix of size (N*M), 
%      where each row is a instance, N denotes the number of instances, 
%      M represents the feature dimensions.
% Y -- binary (0/+1) label matrix of size (N*C), where C is the number of
%          classes
% mode -- the opitimazation form
%         1 -- sum W(i,:) =1, W(i,:)>=0
%         2 -- 0<= W(i,:) <= 1
% OUTPUT:
% W -- the weight matrix of size (N*C)

disp('HSIC-based weight estimation ......');
%rand('seed',0);

[N,M] = size(X);
[C] = size(Y,2);

HX = X-repmat(mean(X),N,1);

Q = HX*HX';

% W = weight_estimation(X,(2*Y-1),6);
% HSIC = trace((W.*Y)'*Q*(Y.*W));
% disp(strcat('HSIC = trace((WoY)^HXX^H(WoY)) = ', num2str(HSIC)));

Ny = sum(Y, 2);

% Block coordinate ascend method (bcam) for the entire QP problem

% Initialize a weight matrix
W = Y; 

for i=1:N
    if (Ny(i) == 0) continue; end
    W(i,:) = W(i,:)/Ny(i);
end

W0 = W;

HSIC = trace((W.*Y)'*Q*(Y.*W));
disp(strcat('Initial HSIC = trace((WoY)^HXX^H(YoW)) = ', num2str(HSIC)));

MaxIter = 1000;
iter = 0;
eps = 10^(-6);
while (iter < MaxIter)
    idx_instances = randperm(N); % permutation for instances

    for i = 1:N
        i0 = idx_instances(i);
        
        if(Ny(i0) == 1)  continue; end
        
        % construct a QP sub-problem
        c=zeros(C,1);
        for j=1:N
            if (j == i0) continue; end
            c = c + Q(i0,j)*(Y(j,:)'.*W(j,:)');
        end
        
        g = c.*Y(i0,:)';
        
        W(i0,:) = zeros(1,C);
        
        [~,idxMax] = max(g);            
        W(i0,idxMax) = 1;
        
    end
    
    %tol = norm(W-W0,1);
    tol = sum(sum(abs(W-W0)));
    if (tol < eps ) break;end
    disp(strcat('The tolerance == ',num2str(tol)));
    
    W0 = W;
    iter = iter + 1;
    
    HSIC = trace((W.*Y)'*Q*(Y.*W));
    disp(strcat('No.', num2str(iter),' HSIC = trace((WoY)^HXX^H(YoW)) = ', num2str(HSIC)));
end

HSIC = trace((W.*Y)'*Q*(Y.*W));
disp(strcat('Final HSIC = trace((WoY)^HXX^H(YoW)) = ', num2str(HSIC)));

end

