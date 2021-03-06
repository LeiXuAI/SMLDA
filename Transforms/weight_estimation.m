function [W] = weight_estimation(X, Y, type)
% This fucntion calculates the weight matrix for weighted LDA framework.
% Editor: Jianhua Xu (xujianhua@njnu.edu.cn)
% Date: May, 2015.

% Input: X -- a N*D matrix for instance vectors, where each row indicates a training vector.
%        Y -- a N*Q matrix for label vectors (+1/-1), where each row is a label vector.
%        type -- weight type
%            =1 -- Binary [Park 2008]
%            =2 -- Entropy [Chen 2007]
%            =3 -- Correlation [Wang 2010, formula(14)]
%            =4 -- Fuzzy [Lin 2010 and Xu 2017]
%            =5 -- Dependence [Xu 2017]
%            =6 -- Saliency weights 
%
% Output: W -- a N*Q weight matrix for two scatter matrixes
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       

if(type <0) type = 5; end
if(type >13) type = 13; end
    
% +1/-1 --> +1/0
YY = (Y+1)/2;

t0=clock;

switch (type)
    case 1
        disp('Binary-based weight form');
        [W] = weight_Park2008_Binary(X, YY);
    case 2
        disp('Entropy-based weight form');
        [W] = weight_Chen2007_Entropy(X, YY);
    case 3
        disp('Correlation-based weight form');
        [W] = weight_Wang2010_Correlation15(X, YY);
    case 4
        disp('Fuzzy-based weight form');
        [W] = weight_Lin2010_Fuzzy(X, YY);
    case 5
        disp('Dependence-based weight form');
        [W] = weight_Xu2017_Dependence(X,YY);    
    %  Above methods are from Jianhua Xu's work
    %  Below is from mine work or any other extension
    case 6
        disp('Saliency weight form with missclassification V');
        [W] = weight_Saliency(X, YY, 1, 1); 
    case 7
        disp('Saliency weight form with correlation V');
        [W] = weight_Saliency(X, YY, 1, 2);
    case 8 
        disp('Saliency weight form with Fuzzy V')
        [W] = weight_Saliency(X, YY, 1, 3);
    case 9
        disp('Saliency weight form with entropy V')
        [W] = weight_Saliency(X, YY, 1, 4);
    case 10
        disp('Saliency weight form with binary V')
        [W] = weight_Saliency(X, YY, 1, 5);        
    case 11
        disp('Saliency weight form with dependence V');
        [W] = weight_Saliency(X,YY, 1, 6);      
     
end

t1 = etime(clock,t0);

disp(strcat('Costed time for weight estimation ===== ',num2str(t1)));

end
        
        