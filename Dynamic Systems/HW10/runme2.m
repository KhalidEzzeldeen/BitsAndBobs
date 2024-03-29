function x = runme2(N,Start,Val0,Const,bound)

Tfin = (6+4)*60+30;
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
lb = [-bound;-pi;-bound;-pi;-bound;-pi;-bound;-pi];
ub = -lb;
options=optimset('Algorithm','interior-point');
x = fmincon(@(Values)myfunSpline1(Values,Start,Tfin,N,Const),Val0,[],[],[],[],lb,ub,[],...
            options);
[TotT,TotxSol] = myfunSpline(x,Start,Tfin,N,Const);

% Const = [0  100.0000    0.1000];
% x = [0.8770, 1.1304, 0.1581, 0.2803, -0.0255, -0.0475, 0.0096, 0.0206];

% Const = [1, 100, 0.1];
% x = [0.3305, -0.3107, 0.3687, -0.2299, 0.1429, 0.0883, -0.0353, -0.0346];

% Const = [10,10,0.1];
% bound = 1.1;
% x = [1.0632;-1.2424;0.6749;-0.3635;0.6220;-0.0445;-0.0236;-0.0057];