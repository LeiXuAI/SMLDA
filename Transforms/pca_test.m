function [Vectors,At,Values,Psi] = pca_test(A,numvecs)

% pca - compute the principal component analysis.
%
%   [Y,X1,v] = pca(X,numvecs)
%
%   X is a matrix of size dimension x numexamples of data points.
%   X1 is the matrix of size numvect x numexamples (projection on the numvect first eigenvectors)
%	Y the matrix  of size dimension x numvect of numvect first eigenvector of the correlation matrix A*A'
%		(this matrix is computed using the traditional flipping trick if numexamples is large).
%	v is the vector of size numvecs of eigenvalues.
%
%   Copyright (c) 2005 Gabriel Peyr
% Matthew Dailey 2000

% Check arguments
if nargin ~= 2
    error('usage: [Vectors,Values,Psi] = pca(A,numvecs)');
end;
nexamp = size(A,2);

% Now compute the eigenvectors of the covariance matrix, using
% a little trick from Turk and Pentland 1991

% Compute the "average" vector
% mean(A) gives you a row vector containing the mean of each column of A
% fprintf(1,'Computing average vector and vector differences from avg...\n');
Psi = mean(A')';

% Compute difference with average for each vector
%for i = 1:nexamp,  A(:,i) = A(:,i) - Psi;  end;
A = A - Psi*ones(1,size(A,2));

% Get the patternwise (nexamp x nexamp) covariance matrix
% fprintf(1,'Calculating L=A''A\n');
L = A'*A;

% Get the eigenvectors (columns of Vectors) and eigenvalues (diag of Values)
% fprintf(1,'Calculating eigenvectors of L...\n');
[Vectors,Values] = eig(L);

% Sort the vectors/values according to size of eigenvalue
% fprintf(1,'Sorting evectors/values...\n');
[Vectors,Values] = sortem(Vectors,Values);

% Convert the eigenvectors of A'*A into eigenvectors of A*A'
% fprintf(1,'Computing eigenvectors of the real covariance matrix..\n');
Vectors = A*Vectors;

% Get the eigenvalues out of the diagonal matrix and
% normalize them so the evalues are specifically for cov(A'), not A*A'.
Values = diag(Values);
Values = Values / (nexamp-1);

% Normalize Vectors to unit length, kill vectors corresponding to tiny evalues
% if numvecs >= 1.0
%     num_good = 0;
%     for i = 1:nexamp
%         Vectors(:,i) = Vectors(:,i)/norm(Vectors(:,i));
%         if Values(i) < 0.00001
%             % Set the vector to the 0 vector; set the value to 0.
%             Values(i) = 0;
%             Vectors(:,i) = zeros(size(Vectors,1),1);
%         else
%             num_good = num_good + 1;
%         end;
%     end;
%     if (numvecs > num_good)
%         %fprintf(1,'Warning: numvecs is %d; only %d exist.\n',numvecs,num_good);
%         numvecs = num_good;
%     end;
% if numvecs < 1.0
% 	%acc_vals = cumsum(Values);
% 	%energy = acc_vals / sum(Values);
% 	%energy = [0.8 0.9 0.93 0.95 0.96 0.97 0.98 0.989 0.99 0.991 0.992 0.993 1.0]
% 	
% 	%keep_ind = find(energy>=numvecs);
% 	%tmpNumVecs = keep_ind(1);
%     %for tmpNumVecs=1:length(Values)
%     %    energy = sum(Values(1:tmpNumVecs)) / sum(Values);
%     %    if energy > numvecs, break; end
%     %end
%     numvecs = tmpNumVecs;
% end

Vectors = Vectors(:,1:numvecs);
At = (Vectors')*A;



function [vectors values] = sortem(vectors, values)

%this error message is directly from Matthew Dailey's sortem.m
if nargin ~= 2
    error('Must specify vector matrix and diag value matrix')
end;

vals = max(values); %create a row vector containing only the eigenvalues
[svals inds] = sort(vals,'descend'); %sort the row vector and get the indicies
vectors = vectors(:,inds); %sort the vectors according to the indicies from sort
values = max(values(:,inds)); %sort the eigenvalues according to the indicies from sort
values = diag(values); %place the values into a diagonal matrix