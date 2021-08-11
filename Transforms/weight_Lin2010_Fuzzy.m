function [weights] = weight_Lin2010_Fuzzy(X, Y)
% X: N*d matrix for training vectors, where each row indicates a training isntance
% Y: N*q matrix for label vectors with +1/0;
% weights: N*q weight matrix for scatter matrix.

[Nx,d] = size(X);
[N, q] = size(Y);

% initialing the membership functions and central vectors
% W = Y;
% for i=1:N
%     W(i, :) = W(i,:)/norm(W(i,:),1);
% end

%Chen 2007
W=weight_Chen2007_Entropy(X, Y);

%Wang 2010-(15)
%W=weight_Wang15(X, Y);
% %Wang 2010-(16)
%W=weight_Wang16(X, Y);

for k=1:q
    C(k,:) = mean(repmat(W(:,k),1,d).*X);
end

C0 = C;
for loop = 1:100
    
    %update the menbership functions W
    for i = 1:N
        for k = 1:q
            % original one
            % d2(k) = (X(i,:)-C(k))*(X(i,:)-C(k))';
            d2(k) = (X(i,:)-C(k,:))*(X(i,:)-C(k,:))';
            d2(k) = Y(i,k)./d2(k);
        end
        dd = sum(d2);
        if dd == 0
            W(i, :) = 0;
        else
            W(i,:) = d2/dd;
        end
    end
    
    %updata the central vectors C
    for k = 1:q
        ww = W(:,k)'*W(:,k);
        if(ww==0)
            C(k,:) = 0;
        else
            C(k,:) = sum(repmat((W(:,k).*W(:,k)),1,d).*X)/ww;
        end
    end

    %C

    e2 = norm(C-C0,'fro');

    disp(strcat('Loop == ',num2str(loop),' Error = ',num2str(e2)));
    if e2 < 0.01 || isnan(e2)  break; end
    C0 = C;
    
end
    
weights = W;

end