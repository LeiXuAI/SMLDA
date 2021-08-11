function auc=AUC(x, y)
% This function is to calculate AUC, which is edited by Jianhua Xu
% (xujianhua@njn.edu.cn)
%INPUT:
%    x: the discrimanative fucntion values of insatnces
%    y: (+1/-1) labels of instances
%OUTPUT:
%    auc: AUC value

L=length(x);
P=sum(y>0);
N=sum(y<0);

if (P==0 | N==0)
    auc=0.0;
    return;
end
    
[x1,id]=sort(x,'Descend');
for i=1:L
    y1(i)=y(id(i));
end

FP=0;
TP=0;
FPprev=0;
TPprev=0;

A=0.0;

xprev=min(x)-100.0;

for i=1:L
    if (x1(i) ~= xprev)
        A=A+(FP-FPprev)*(TP+TPprev)/2.0;
        xprev=x1(i);
        FPprev=FP;
        TPprev=TP;
    end
    
    if y1(i)>0
        TP=TP+1;
    else
        FP=FP+1;
    end
    
end

A=A+(FP-FPprev)*(TP+TPprev)/2.0;
A=A/(P*N);
auc=A;
end
% end of file