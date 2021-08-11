function [MacroAUC, MicroAUC]=MM_2AUCs(Outputs,test_target)
%This function calculates Macro and Micro AUCs.
%INPUT:
%   Outputs: a discriminant function matrix of size Classes*Instances. 
%   test_target: an actual binary (+1/-1) label matrix of size Classses*Instances.
%OUTPUT:
%   MacroAUC and Micro AUC.

   [num_class,num_instance]=size(Outputs);
   
   MacroAUC=0.0;
   for i=1:num_class
       auc0=AUC(Outputs(i,:),test_target(i,:));
       MacroAUC=MacroAUC+auc0;
   end
   MacroAUC=MacroAUC/num_class;
       
   MicroAUC=AUC(reshape(Outputs, 1, num_class*num_instance),reshape(test_target, 1, num_class*num_instance));
end