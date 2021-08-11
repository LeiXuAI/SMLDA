function [is_error, error_set_size]=RK_2Measures(Outputs,test_target)
%This function estimates two ranking-based measures.
%INPUT:
%   Outputs: the predicted function value matrix of size
%            (Classses)*(Instances).
%   test_target: the actual label (+1/-1) matrix.
%OUTPUT: 
%  is error and error set size.

   [num_class,num_instance]=size(Outputs);
    
   % calculate the IS-Error
   mat_max=max(max(Outputs))+1.0;
   mat_min=min(min(Outputs))-1.0;
   is_error=0;
   error_set_size=0;
   for i=1:num_instance
        rl_min=mat_max;
        rl_max=mat_min;
        for j=1:num_class
            if (test_target(j,i) > 0)
                if (Outputs(j,i)<rl_min)
                    rl_min=Outputs(j,i);
                end
            else
                if (Outputs(j,i)>rl_max)
                    rl_max=Outputs(j,i);
                end
            end
        end
        
        if (rl_min<= rl_max)
            is_error=is_error+1.0;
        end
   end
   is_error=is_error/num_instance;
   
   % calcualte the error_set_size
   for i=1:num_instance
       for j1=1:num_class
           if (test_target(j1,i)>0)
               for j2=1:num_class
                   if (test_target(j2,i)<0)
                       if (Outputs(j1,i)<=Outputs(j2,i))
                           error_set_size = error_set_size +1.0;
                       end
                   end
               end
           end
       end
   end
   
   error_set_size=error_set_size/num_instance;
end
   
   