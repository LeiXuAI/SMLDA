function [RK_6M, IB_6M, MM_8M,Pre_Labels]=MLKNN_test(train_data,train_target,test_data,test_target,Num,Prior,PriorN,Cond,CondN)
%This function is from M-L Zhang and Z-H Zhou, PR, 2007.
%MLKNN_test tests a multi-label k-nearest neighbor classifier.
%
%    Syntax
%
%       [HammingLoss,RankingLoss,OneError,Coverage,Average_Precision,Outputs,Pre_Labels]=MLKNN_test(train_data,train_target,test_data,test_target,Num,Prior,PriorN,Cond,CondN)
%
%    Description
%
%       KNNML_test takes,
%           train_data       - An M1xN array, the ith instance of training instance is stored in train_data(i,:)
%           train_target     - A QxM1 array, if the ith training instance belongs to the jth class, then train_target(j,i) equals +1, otherwise train_target(j,i) equals -1
%           test_data        - An M2xN array, the ith instance of testing instance is stored in test_data(i,:)
%           test_target      - A QxM2 array, if the ith testing instance belongs to the jth class, test_target(j,i) equals +1, otherwise test_target(j,i) equals -1
%           Num              - Number of neighbors used in the k-nearest neighbor algorithm
%           Prior            - A Qx1 array, for the ith class Ci, the prior probability of P(Ci) is stored in Prior(i,1)
%           PriorN           - A Qx1 array, for the ith class Ci, the prior probability of P(~Ci) is stored in PriorN(i,1)
%           Cond             - A Qx(Num+1) array, for the ith class Ci, the probability of P(k|Ci) (0<=k<=Num) i.e. k nearest neighbors of an instance in Ci will belong to Ci , is stored in Cond(i,k+1)
%           CondN            - A Qx(Num+1) array, for the ith class Ci, the probability of P(k|~Ci) (0<=k<=Num) i.e. k nearest neighbors of an instance not in Ci will belong to Ci, is stored in CondN(i,k+1)
%      and returns,
%           HammingLoss      - The hamming loss on testing data
%           RankingLoss      - The ranking loss on testing data
%           OneError         - The one-error on testing data as
%           Coverage         - The coverage on testing data as
%           Average_Precision- The average precision on testing data
%           Outputs          - A QxM2 array, the probability of the ith testing instance belonging to the jCth class is stored in Outputs(j,i)
%           Pre_Labels       - A QxM2 array, if the ith testing instance belongs to the jth class, then Pre_Labels(j,i) is +1, otherwise Pre_Labels(j,i) is -1

    [num_class,num_training]=size(train_target);
    [num_class,num_testing]=size(test_target);
    
%Computing distances between training instances and testing instances

   %str=version('-release');
   % ver_num=str2num(str(3:4));
   % if(ver_num>=8)
   %     userview=memory;
   %     max_mat_elements=(userview.MaxPossibleArrayBytes)/8;
   %     max_mat_elements=(max_mat_elements*0.2)/2;
   %else
   %    max_mat_elements=5000*5000;
   %end
    
    max_mat_elements=5000*5000;
    
    if(num_training*num_testing<max_mat_elements)
    
        mat1=concur(sum(train_data.^2,2),num_testing);
        mat2=concur(sum(test_data.^2,2),num_training)';
        dist_matrix=mat1+mat2-2*train_data*test_data';
        dist_matrix=sqrt(dist_matrix);
        dist_matrix=dist_matrix';

        %Find neighbors of each testing instance
        Neighbors=cell(num_testing,1); %Neighbors{i,1} stores the Num neighbors of the ith testing instance
        for i=1:num_testing
            [temp,index]=sort(dist_matrix(i,:));
            Neighbors{i,1}=index(1:Num);
        end

        %Computing Outputs
        Outputs=zeros(num_class,num_testing);
        for i=1:num_testing
            %         if(mod(i,100)==0)
            %             disp(strcat('computing outputs for instance:',num2str(i)));
            %         end
            temp=zeros(1,num_class); %The number of the Num nearest neighbors of the ith instance which belong to the jth instance is stored in temp(1,j)
            neighbor_labels=[];
            for j=1:Num
                neighbor_labels=[neighbor_labels,train_target(:,Neighbors{i,1}(j))];
            end
            for j=1:num_class
                temp(1,j)=sum(neighbor_labels(j,:)==ones(1,Num));
            end
            for j=1:num_class
                Prob_in=Prior(j)*Cond(j,temp(1,j)+1);
                Prob_out=PriorN(j)*CondN(j,temp(1,j)+1);
                if(Prob_in+Prob_out==0)
                    Outputs(j,i)=Prior(j);
                else
                    Outputs(j,i)=Prob_in/(Prob_in+Prob_out);
                end
            end
        end
        
    else
        
        block_size=floor(max_mat_elements/num_training);
        num_blocks=ceil(num_testing/block_size);
        
        Neighbors=cell(num_testing,1); %Neighbors{i,1} stores the Num neighbors of the ith testing instance
        Outputs=zeros(num_class,num_testing);
        
        for iter=1:num_blocks
            low=block_size*(iter-1)+1;
            if(iter==num_blocks)
                high=num_testing;
            else
                high=block_size*iter;
            end
            
            tmp_data=test_data(low:high,:);
            tmp_size=size(tmp_data,1);
            mat1=concur(sum(train_data.^2,2),tmp_size);
            mat2=concur(sum(tmp_data.^2,2),num_training)';
            tmp_dist_matrix=mat1+mat2-2*train_data*tmp_data';
            tmp_dist_matrix=sqrt(tmp_dist_matrix);
            tmp_dist_matrix=tmp_dist_matrix';
            
            for i=low:high
                [temp,index]=sort(tmp_dist_matrix(i-low+1,:));
                Neighbors{i,1}=index(1:Num);
            end

            %Computing Outputs
            for i=low:high
                temp=zeros(1,num_class); %The number of the Num nearest neighbors of the ith instance which belong to the jth class is stored in temp(1,j)
                neighbor_labels=[];
                for j=1:Num
                    neighbor_labels=[neighbor_labels,train_target(:,Neighbors{i,1}(j))];
                end
                for j=1:num_class
                    temp(1,j)=sum(neighbor_labels(j,:)==ones(1,Num));
                end
                for j=1:num_class
                    Prob_in=Prior(j)*Cond(j,temp(1,j)+1);
                    Prob_out=PriorN(j)*CondN(j,temp(1,j)+1);
                    if(Prob_in+Prob_out==0)
                        Outputs(j,i)=Prior(j);
                    else
                        Outputs(j,i)=Prob_in/(Prob_in+Prob_out);
                    end
                end
            end
        end
    end
    
%Evaluation
    Pre_Labels=zeros(num_class,num_testing);
    for i=1:num_testing
        for j=1:num_class
            if(Outputs(j,i)>=0.5)
                Pre_Labels(j,i)=1;
            else
                Pre_Labels(j,i)=-1;
            end
        end
    end
    
    %Outputs(:, 1:5)'
    %Pre_Labels(:,1:5)'
    % test_target(:,1:5)'
    
    
    RK_6M.RankingLoss=Ranking_loss(Outputs,test_target);
    RK_6M.OneError=One_error(Outputs,test_target);
    RK_6M.Coverage=Coverage(Outputs,test_target);
    RK_6M.AveragePrecision=Average_precision(Outputs,test_target);
    [RK_6M.IsError, RK_6M.ErrorSetSize]=RK_2Measures(Outputs,test_target);
    
    IB_6M.HammingLoss=Hamming_loss(Pre_Labels,test_target);
    [IB_6M.SubsetAccuracy, IB_6M.Precision, IB_6M.Recall, IB_6M.Fmeasure, IB_6M.Accuracy]=IB_5Measures(Pre_Labels,test_target);
        
    [MM_8M. MacroPrecision, MM_8M.MacroRecall, MM_8M.MacroF1, MM_8M. MicroPrecision, MM_8M.MicroRecall, MM_8M.MicroF1]=MM_6Measures(Pre_Labels,test_target);
    [MM_8M.MacroAUC, MM_8M.MicroAUC]=MM_2AUCs(Outputs, test_target);
    
    %end of  file