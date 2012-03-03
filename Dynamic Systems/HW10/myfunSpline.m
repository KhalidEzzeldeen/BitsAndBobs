function [TotT,TotxSol] = myfunSpline(Values,x0,Tfin,N,Const)

% x = fmincon(@myfun,x0,A,b,Aeq,beq,options)
% A = [1,0,0,0,0,0;     b = [1;     And '-' constraints as well.
%      0,0,1,0,0,0;          1;
%      0,0,0,0,1,0]          1];
% options=optimset('MaxFunEvals', 5000, 'TolFun',1e-8, 'TolX', 1e-8, 'MaxIter', 5000);

beta = Const(1);
rho = Const(2);
res = Const(3);
TotxSol = [];
TotT = 0;
xStart = [x0,Values(1),Values(2)];
J = 0;
for Section = 1:N
    U = [Values((2*Section-1):(2*Section))'; Values((2*Section+1):(2*Section+2))'];
    [T,xSol] = ode45(@(t1,x1)DiffEqIn(t1,x1,U,beta,Tfin/N),[0,Tfin/N],xStart);
    [~,JTmp] = ode45(@(t,j)DiffEqJ(t,j,U,Tfin/N),[0,Tfin/N],[0,U(1,:)]);
    J = J + JTmp(end,1);
    xStart = xSol(end,:);
    TotT = [TotT; T+TotT(end)];
    TotxSol = [TotxSol;xSol];
end
TotT = TotT(2:end);
J = J + rho*((xSol(end,1)-4)^2 + (xSol(end,2)-4)^2);

color = {'-b+','-ro','--b*','--rx',':bd',':rs','-.bv','-.r^'};

%Make plot for Controls
figure;
title({['\fontsize{16}  Optimal Spline Controls for:  N = ' num2str(N) ', '];...
        ['beta = ' num2str(beta) ', Rho = ' num2str(rho) ', J = ' num2str(J)]});
xlabel('\fontsize{13} Time Units');
ylabel('\fontsize{13} u / Theta');
hold on
for S = 1:N
    U = [Values((2*S-1):(2*S))'; Values((2*S+1):(2*S+2))'];
    tint = ((S-1)*(Tfin/N)):res:(S*(Tfin/N));
    u1 = U(1,1) + (U(2,1)-U(1,1))*(0:res:(Tfin/N))/(Tfin/N);
    u2 = U(1,2) + (U(2,2)-U(1,2))*(0:res:(Tfin/N))/(Tfin/N);
    plot(tint,u1,'--bx',...
         tint,u2,'-rv');
         
end
legend('\fontsize{13} u',...
       '\fontsize{13} Theta',...
       'Location','Best');
hold off

%Make plot for Trajectory
figure;
title({['\fontsize{16}  Optimal Trajectory from Spline for:  N = ' num2str(N) ', '];...
        ['beta = ' num2str(beta) ', Rho = ' num2str(rho) ', J = ' num2str(J)]});
xlabel('\fontsize{13} x1');
ylabel('\fontsize{13} x2');
hold on
plot(3,0,'*k','MarkerSize',16);
plot(0,0,'xr','MarkerSize',16);
plot(4,4,'xr','MarkerSize',16);
plot(TotxSol(:,1),TotxSol(:,2),'--b');
plot(TotxSol(end,1),TotxSol(end,2), '+r','MarkerSize',16);
legend('\fontsize{13} Blackhole',...
       '\fontsize{13} Start',...
       '\fontsize{13} Goal',...
       '\fontsize{13} Trajectory',...
       '\fontsize{13} Final Pos.',...
       'Location','Best');


function dxdy = DiffEqIn(~,x,U,beta,span)
%[T,Y] = solver(odefun,tspan,y0,options)
%U = [u1, theta1; u2, theta2]
u = diff(U)/span;
q = (beta / ((x(2)^2 + (x(1)-3)^2)^(3/2))).*[3-x(1);-x(2)];
dxdy = [x(3);...
        x(4);...
        x(5)*cos(x(6)) + q(1);...
        x(5)*sin(x(6)) + q(2);...
        u(1);...
        u(2)];
    
function dj = DiffEqJ(~,j,U,span)
%U = [u1, theta1; u2, theta2]
u = diff(U)/span;
dj = [(10*j(2)^2 + 4*j(3)^2);...
       u(1);...
       u(2)];