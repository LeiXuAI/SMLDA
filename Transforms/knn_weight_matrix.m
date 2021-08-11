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

