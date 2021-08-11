function [W] = weight_Saliency_Binary(X, Y, kNN_perc)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
[N, M] = size(X);
numClass = size(Y, 2);
W = zeros(N, numClass);

for cc = 1:numClass
    % calculate the affinity matrix W for each class
    Xc = X(find(Y(:, cc) ~= 0), :);
    Nc = size(X(find(Y(:, cc) ~= 0), :), 1);
    kNN = round(Nc*kNN_perc); if kNN < 5, kNN = 5; end
    

end

end

