function [result] = ShowResult(RK_6M,IB_6M,MM_8M)

disp(strcat('RK_6M.Coverage         =',num2str(RK_6M.Coverage)));
disp(strcat('RK_6M.OneError         =',num2str(RK_6M.OneError)));
disp(strcat('RK_6M.AveragePrecision = ',num2str(RK_6M.AveragePrecision)));
disp(strcat('RK_6M.RankingLoss      = ',num2str(RK_6M.RankingLoss)));
disp(strcat('RK_6M.IsError          =',num2str(RK_6M.IsError)));
disp(strcat('RK_6M.ErrorSetSize     =',num2str(RK_6M.ErrorSetSize)));

disp(strcat('IB_6M.HammingLoss      =',num2str(IB_6M.HammingLoss)));
disp(strcat('IB_6M.Accuracy         =',num2str(IB_6M.Accuracy)));
disp(strcat('IB_6M.Fmeasure         = ',num2str(IB_6M.Fmeasure)));
disp(strcat('IB_6M.Precision        =',num2str(IB_6M.Precision)));
disp(strcat('IB_6M.Recall           =',num2str(IB_6M.Recall)));
disp(strcat('IB_6M.SubsetAccuracy   =',num2str(IB_6M.SubsetAccuracy)));

disp(strcat('MM_8M.MacroPrecision   =',num2str(MM_8M.MacroPrecision)));
disp(strcat('MM_8M.MacroRecall      =',num2str(MM_8M.MacroRecall)));
disp(strcat('MM_8M.MacroF1          =',num2str(MM_8M.MacroF1)));
disp(strcat('MM_8M.MacroAUC         =',num2str(MM_8M.MacroAUC)));

disp(strcat('MM_8M. MicroPrecision  =',num2str(MM_8M.MicroPrecision)));
disp(strcat('MM_8M.MicroRecall      =',num2str(MM_8M.MicroRecall)));
disp(strcat('MM_8M.MicroF1          =',num2str(MM_8M.MicroF1)));
disp(strcat('MM_8M.MicroAUC         =',num2str(MM_8M.MicroAUC)));

result = [
RK_6M.Coverage;
RK_6M.OneError;
RK_6M.AveragePrecision;
RK_6M.RankingLoss;
RK_6M.IsError;
RK_6M.ErrorSetSize;

IB_6M.HammingLoss;
IB_6M.Accuracy;
IB_6M.Fmeasure;
IB_6M.Precision;
IB_6M.Recall;
IB_6M.SubsetAccuracy;

MM_8M.MacroPrecision;
MM_8M.MacroRecall;
MM_8M.MacroF1;
MM_8M.MacroAUC;

MM_8M.MicroPrecision;
MM_8M.MicroRecall;
MM_8M.MicroF1;
MM_8M.MicroAUC;];

end