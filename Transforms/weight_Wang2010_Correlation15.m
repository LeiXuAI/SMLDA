function [weights] = weight_Wang2010_Correlation15(X, Y)
% X: N*d matrix for training vectors, where each row indicates a training isntance
% Y: N*q matrix for label vectors with +1/0;
% weights: N*q weight matrix for scatter matrixes using formula (15)
% Reference:
% Wang H, Ding C, Huang H. Multi-label linear discriminant analysis. ECCV2010, LNCS6316, pp.126-139, 2010.
% 

    [N,q]=size(Y);

    % formula (13)
    
    C=ones(q,q)/(N*N);
    for i=1:q
        for j=1:q
            if(norm(Y(:,i),1)<=0 | norm(Y(:,j),1)<=0 )continue;end
            C(i,j)=(Y(:,i)'*Y(:,j))/(norm(Y(:,i),2)*norm(Y(:,j),2));
        end
        C(i,i) = 1.0;
    end

    % formula (14)
    weights = Y*C;
    
   
    %formula (15)
    for i=1:N
            if(sum(Y(i,:))<=0)continue;end
            weights(i,:) = weights(i,:)/norm(Y(i,:),1);
    end
                           
end