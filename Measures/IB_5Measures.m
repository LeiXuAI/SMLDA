function [Subset_Accuracy, Precision, Recall, Fm, Accuracy]=IB_5Measures(Pred_Labels,test_target)
%This function calculates five measures based on instances, which is edited
%by Jianhua Xu (xujianhua@njnu.edu.cn)
%INPUT:
%    Pred_Labels: a predicted binary (+1/-1) label matrix of size
%                 C(classes)*N(instances).
%    test_target: a actual binary label matrix of size C*N.
%OUTPUT:
%    Five instance-based measures.

    [num_class,num_instance]=size(Pred_Labels);
        
    Subset_Accuracy=mean(sum(Pred_Labels==test_target)==num_class);
    
    Size_Int=sum((Pred_Labels>0).*(test_target>0));
    Size_Uni=sum(((Pred_Labels>0)+(test_target>0))>0);
    Size_Pred=sum(Pred_Labels>0);
    Size_Tar=sum(test_target>0);
    
    Precision0 = zeros(num_instance,1);
    for i=1:num_instance
        Precision0(i)=0;
        if(Size_Pred(i)>0)
           Precision0(i)= Size_Int(i)/Size_Pred(i);
        end
    end

    Recall0= (Size_Int./Size_Tar);
    
    Precision= mean(Precision0);
    Recall= mean(Recall0);
    Fm= mean(2*Size_Int./(Size_Pred+Size_Tar));
    Accuracy=mean(Size_Int./Size_Uni);
end
    
  