function [RK_6M, IB_6M, MM_8M] = evaluation_20measures(true_labels, pred_fvals, pred_labels)
% This function is to calculate 20 measures for testing instances, which is
% edited by Jianhua XU (xujianhua@njnu.edu.cn).

% Six ranking-based measures: coverage, one error, average precision, ranking
%                         loss, is error and error set size.
% Six instance-based measures: Hamming loss, accuracy, F1, recall,
%                         precision and sub-set accuracy.
% Eight label-based measures: Micro/Macro precision, recall, F1 and AUC.
% INPUT:
%   true_labels: true label matrix of size N*C.
%   pred_fvals: predicted discriminant function matrix of size N*C.
%   pred_labels: predicted label matrix of size N*C.
%   where N--the number of testing instances and C--the number of classes.
% OUTPUT:
%   RK_6M: six ranking-based measures.
%   IB_6M: six instance-based measures.
%   MM_8M: eight lable-based  measures.

    Outputs = pred_fvals';
    test_target = true_labels';
    Pre_Labels = pred_labels';
    
    sums = sum(test_target' == 1);
    Outputs = Outputs(sums > 0,:);
    test_target = test_target( sums > 0, :);
    
    RK_6M.RankingLoss = Ranking_loss(Outputs,test_target);
    RK_6M.OneError = One_error(Outputs,test_target);
    RK_6M.Coverage = Coverage(Outputs,test_target);
    RK_6M.AveragePrecision = Average_precision(Outputs,test_target);
    [RK_6M.IsError, RK_6M.ErrorSetSize] = RK_2Measures(Outputs,test_target);
    
    IB_6M.HammingLoss = Hamming_loss(Pre_Labels,test_target);
    [IB_6M.SubsetAccuracy, IB_6M.Precision, IB_6M.Recall, IB_6M.Fmeasure, IB_6M.Accuracy] = IB_5Measures(Pre_Labels,test_target);
        
    [MM_8M.MacroPrecision, MM_8M.MacroRecall, MM_8M.MacroF1, MM_8M. MicroPrecision, MM_8M.MicroRecall, MM_8M.MicroF1] = MM_6Measures(Pre_Labels,test_target);
    [MM_8M.MacroAUC, MM_8M.MicroAUC] = MM_2AUCs(Outputs, test_target);
    
end
    