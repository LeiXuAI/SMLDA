
function [W] = weight_Saliency( X, Y, kNN_perc, V_type)
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here
% This function is the essential part of my work which is built based on
% saliency estimation.
% kNN_perc: the parameter for the calculation of similarity matrix 
% V_type: the parameter for the type of prior information
[N, M] = size(X);
numClass = size(Y, 2);
W = zeros(N, numClass);

%calculate each class mean vector
mean_class = zeros(M, numClass);
for ii = 1:numClass
    mean_class(:, ii) = mean(X(find(Y(:, ii) ~= 0), :));
end

% distance matrix: C*N
Dmat = sqrt((sum(mean_class'.^2, 2)*ones(1, N)) + (ones(numClass, 1)*sum(X.^2, 2)') - (2*(mean_class' * X')));
v_scores = zeros(N, numClass);

Nc_vec = zeros(1, numClass);
for cc = 1:numClass
              
    % calculate the affinity matrix W for each class
    Xc = X(find(Y(:, cc) ~= 0), :);
    Nc = size(X(find(Y(:, cc) ~= 0), :), 1);
    Nc_vec(cc) = Nc;
    curr_ind = find(Y(:, cc) ~= 0);
    if Nc == 1
        H = 1;
    else
        % Amat1 can be calculated in a sparse manner 
        kNN = round(Nc*kNN_perc); if kNN < 5, kNN = size(Xc, 1); end

        Amat1 = knn_weight_matrix(Xc', kNN);
        Amat1 = Amat1 / max(max(Amat1));
        D1 = diag(sum(Amat1, 1));
        D2 = diag(sum(Amat1, 2));
        H = D1/2 + D2/2 - Amat1;   
        H = H / max(max(H));
    end
    
    % the type of V can be extended by exploring various prior information
    switch (V_type)
        case 1
            [~, V_tmp] = V_score(Dmat, Y, v_scores, cc);
            V = diag(V_tmp);
            
        case 2 % correlation
            weights_correlation = correlation_V(Y);
            V_tmp = weights_correlation(curr_ind,cc);
            V = diag(1-V_tmp);
            
        case 3 % fuzzy
            weights_fuzzy = fuzzy_V(X, Y);
            V_tmp = weights_fuzzy(curr_ind, cc);
            V = diag(1-V_tmp);
            
        case 4 % entropy 
            weights_entropy = entropy_V(Y);
            V_tmp = weights_entropy(curr_ind);
            V = diag(1-V_tmp);
                       
        case 5 % binary
            V = 1 - eye(Nc)/Nc;
            
        case 6 %dependence
            weights_dependence = weight_Xu2017_Dependence(X, Y);
            V_tmp = weights_dependence(curr_ind, cc);
            V = diag(1-V_tmp);
    end
    H = H + V;
    %display(strcat('cc is the number of class', num2str(cc)));
    if rank(H) < size(H, 2), H = H + 0.01*diag(diag(H)); end
    alpha_c = H \ ones(Nc, 1);
    alpha_c = alpha_c / sum(alpha_c);
    W(curr_ind, cc) = alpha_c; 

end

end

function [v_scores, curr_scores] = V_score(Dmat, Y, v_scores, class_idx)
% calculate v_scores for each class

    currDvec = Dmat(class_idx, :);
    otherDmat = Dmat; otherDmat(class_idx, :) = [];
    curr_ind = find(Y(:, class_idx) ~= 0);
    numerator = currDvec(1, curr_ind);

    denominator = min(otherDmat(:, curr_ind));
    curr_scores = numerator ./ denominator;
    curr_scores(curr_scores<=1.0) = 0.0;
    v_scores(curr_ind, class_idx) = curr_scores; 
end

function [W, weights] = entropy_V(Y)
    [N, q] = size(Y);
    weights = zeros(N, q);
    for i = 1:N
       num_label = sum(Y(i,:));
       if num_label == 0
           weights(i, :) = 0;
       else
           weights(i, :) = Y(i, :) / num_label;
       end
    end
    W = max(weights, [], 2); 
end

function [weights] = correlation_V(Y)
    
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
            if(sum(Y(i,:))<=0)  continue;end
            weights(i,:) = weights(i,:)/norm(Y(i,:),1);
    end
end

function [weights] = fuzzy_V(X, Y)
    [Nx, d] = size(X);
    [N, q] = size(Y);
    
    [~, W] = entropy_V(Y);
    
    for k = 1:q
       C(k, :) = mean(repmat(W(:, k), 1, d) .* X); 
    end
    
    C0 = C;
    for loop = 1:20
       
        for i = 1:N
            for k = 1:q
                d2(k) = (X(i,:) - C(k)) * (X(i,:) - C(k))';
                d2(k) = Y(i, k) ./ d2(k);
            end
            dd = sum(d2);
            if dd == 0
                W(i, :) = 0;
            else
                W(i, :) = d2 / dd;
            end
        end
        
        %update the central vectors C
        for k = 1:q
           ww = W(:,k)' * W(:,k);
           if (ww == 0)
               C(k,:) = 0;
           else
               C(k,:) = sum(repmat((W(:,k) .* W(:,k)), 1, d) .* X) / ww;
           end
        end
        
        %C
        e2 = norm(C - C0, 'fro');
        disp(strcat('Loop == ',num2str(loop),' Error = ',num2str(e2)));
        if e2 < 0.01 break; end
        C0 = C;       
    end
    weights = W;
end