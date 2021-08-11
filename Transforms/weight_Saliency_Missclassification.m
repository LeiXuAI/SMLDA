function [ W ] = weight_Saliency_Missclassification(X, Y, kNN_perc)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[N, M] = size(X);
numClass = size(Y, 2);
W = zeros(N, numClass);

% calculate V for each class
[~, W] = saliency_score(X, Y, kNN_perc);
end

function [v_scores, W] = saliency_score(X, Y, kNN_perc)
    [N, M] = size(X);
    C = size(Y, 2); %the number of classes
    W = zeros(N, C);
    
    %calculate each class mean vector
    mean_class = zeros(M, C);
    for ii = 1:C
        mean_class(:, ii) = mean(X(find(Y(:, ii) ~= 0), :));
    end
    
    % distance matrix: C*N
    Dmat = sqrt((sum(mean_class'.^2, 2)*ones(1, N)) + (ones(C, 1)*sum(X.^2, 2)') - (2*(mean_class' * X')));
        
    v_scores = zeros(N, C); 
    for cc = 1:C
        % calculate v_scores for each class
        currDvec = Dmat(cc, :);
        otherDmat = Dmat; otherDmat(cc, :) = [];
        curr_ind = find(Y(:, cc) ~= 0);
        numerator = currDvec(1, curr_ind);
        
        denominator = min(otherDmat(:, curr_ind));
        curr_scores = numerator ./ denominator;
        curr_scores(curr_scores<=1.0) = 0.0;
        v_scores(curr_ind, cc) = curr_scores;  
        
        % calculate the affinity matrix W for each class
        Xc = X(find(Y(:, cc) ~= 0), :);
        Nc = size(X(find(Y(:, cc) ~= 0), :), 1);
        kNN = round(Nc*kNN_perc); if kNN < 5, kNN = 5; end
        
        Amat = knn_weight_matrix(Xc', kNN);
        Amat = Amat / max(max(Amat));
        D = diag(sum(Amat, 2));
        H = D - Amat;
        H = H / max(max(H));
        H = H + diag(curr_scores);
        
        if rank(H) < size(H, 2), H = H + 0.01*diag(diag(H)); end
        alpha_c = H \ ones(Nc, 1);
        alpha_c = alpha_c / sum(alpha_c);
        W(curr_ind, cc) = alpha_c;       
    end
    %v_scores(v_scores<=1.0) = 0.0;
    %v_scores(v_scores>0.0) = 0.1;
    %v_scores = v_scores ./ max(v_scores, 1);
    %v_scores = v_scores ./ sum(v_scores, 1); 
    
    
    
end

function W = knn_weight_matrix(data,kNN)

N = size(data,2);
Dmat = ((sum(data'.^2,2)*ones(1,N))+(sum(data'.^2,2)*ones(1,N))'-(2*(data'*data)));
A = 2*mean(mean(Dmat));     Wmat = exp(-Dmat/A);    W = zeros(size(Dmat));
    for ii=1:N
        [vals ind] = sort(Wmat(ii,:),'descend');
        knn_ind = ind(1:kNN);  
        %W(ii,knn_ind) = 1;
        W(ii,knn_ind) = Wmat(ii,knn_ind);
    end
end