function x = runme2(N,x0,Val0,Const)

Tfin = 6;
options=optimset('Algorithm','interior-point');
% options=optimset('MaxFunEvals', 800);
% A = zeros(2*N);
% b = ones(2*N,1);
% for ind = 1:N
%     %Make sure u stays on [-1,1].
%     A(2*ind-1,2*ind-1) = 1;
%     A(2*ind,  2*ind-1) = -1;
% end
% Val0 = [1;pi/2;1;pi/4;.5;7*pi/8];
lb = [-1;-pi;-1;-pi;-1;-pi];
ub = -lb;
x = fmincon(@(Values)myfunSpline1(Values,x0,Tfin,N,Const),Val0,[],[],[],[],lb,ub,[],...
            optimset('Algorithm','interior-point'));
[TotT,TotxSol] = myfunSpline(x,x0,Tfin,N,Const);