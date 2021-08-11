function [RK_6M, IB_6M, MM_8M] = execute_classifier(train_data, train_label, test_data, test_label, classifier_type,classifier_parameter)
% This function is train and test a classifier using training and testing
% data set respectively.
% Editor: Jianhua XU (xujianhua@njnu.edu.cn)
% Date: May, 2015.
% Input: 
%       train_data  -- a (N*D) training instance matrix
%       train_label -- a (N*Q) training label matrix
%       test_data   -- a (M*D) training instance matrix
%       test_label  -- a (M*Q) testing label matrix
%       classifier_type -- classifier type
%                   =1 ML-kNN (M-L Zhang and Z-H Zhou, 2007)
%                   =2 Linear ridge regrssion
% Output:
%       20 measures
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


switch (classifier_type)
    case 1 %ML-kNN
         kNN = classifier_parameter.MLkNN_k;
         disp(strcat('The number of nearest neighbor instances in ML-kNN =',num2str(kNN)));
         [Prior,PriorN,Cond,CondN] = MLKNN_train(train_data,train_label', kNN, 1.0);
         [RK_6M, IB_6M, MM_8M,Pre_Labels] = MLKNN_test(train_data, train_label', test_data, test_label', kNN, Prior, PriorN, Cond, CondN);
         
    case 2 % linear ridge regression
         reg = classifier_parameter.RidgeR_reg;
         disp(strcat('The regularization constant in ridge regression = ',num2str(reg)));
         [W, B] = train_LinearRidgeRegression(train_data, train_label, reg);
         [RK_6M, IB_6M, MM_8M] = test_LinearRidgeRegression(test_data,test_label, W, B);         
end
end