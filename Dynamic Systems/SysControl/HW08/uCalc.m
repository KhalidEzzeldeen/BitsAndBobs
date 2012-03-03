function u = uCalc(tempW,TX,X,B,xspan)

%Calculate inverses of the above final results for u(t) calc.
tempSTM = X(end,:);
n = (length(tempW)^.5);
Wr = [];
STM = [];
for jj = 1:n
   Wr = [Wr,tempW(1+(n*(jj-1)):n*jj)'];
   STM = [STM,tempSTM(1+(n*(jj-1)):n*jj)'];
end
Wr = Wr^-1;
STM = STM^-1;

u = [];
K = Wr*(xspan(:,2) - STM*xspan(:,1));
for jk = 1:length(TX)
    index = n*(jk-1);
    Xjk = [X(1+index:2+index)',X(3+index:4+index)'];
    u(jk) = B(TX(jk))'*Xjk'*K;
end