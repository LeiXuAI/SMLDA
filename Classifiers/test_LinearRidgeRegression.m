function [RK_6M, IB_6M, MM_8M] = test_LinearRidgeRegression(test_data,test_target,lrrC, lrrB)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is to test a ridge regressor.
% Editor: Jianhua Xu (xujianhua@njnu.edu.cn)
% Date: May, 2015.
% Input:
%       test_data -- a (N*D) testing instance matrix
%       test_label -- a (N*q) binary label matrix
%       lrrC -- coefficients from linear ridge regression (q*D)
%       lrrB -- bias terms form LRR (q*1)
%  Output: 
%       20 measures
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   [nr_instance, nr_dimension] = size(test_data);
   [nr_instance, nr_class] = size(test_target);
   
    pred_fvals = test_data*lrrC' +  repmat(lrrB', nr_instance, 1);
    
    pred_labels = zeros(nr_instance, nr_class);
    
    for i = 1: nr_instance
        for j=1:nr_class
            if(pred_fvals(i,j)  >= 0)
                pred_labels(i,j) = 1;
            else
                pred_labels(i,j) = -1;
            end
        end
        
        if (sum(pred_labels(i, :)) + nr_class == 0)
            %disp('One label is determined');
            [Max_val,k]= max(pred_fvals(i,:));
            pred_labels(i,k) = +1;
        end
    end
    
    [RK_6M, IB_6M, MM_8M] = evaluation_20measures(test_target, pred_fvals, pred_labels);
    
end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%