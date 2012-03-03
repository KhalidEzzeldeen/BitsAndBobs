function [TotT,TotxSol] = myfun(Values,x0,Tfin,N,Const)

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
xStart = x0;
J = 0;
for Section = 1:N
    u = Values(2*Section-1:2*Section);
    [T,xSol] = ode45(@(t1,x1)DiffEqIn(t1,x1,u,beta),[0,Tfin/N],xStart);
    J = J + (10*u(1)^2 + 4*u(2)^2)*(Tfin/N);
    xStart = xSol(end,:);
    TotT = [TotT; T+TotT(end)];
    TotxSol = [TotxSol;xSol];
    
end
TotT = TotT(2:end);
J = J + rho*((xSol(end,1)-4)^2 + (xSol(end,2)-4)^2);
color = {'-b+','-ro','--b*','--rx',':bd',':rs','-.bv','-.r^'};

%Make plot for Controls
figure;
title({'\fontsize{16}  Optimal Controls for ';...
        ['beta = ' num2str(beta) ', N = ' num2str(N) ', Rho = ' num2str(rho)]});
xlabel('\fontsize{13} Time Units');
ylabel('\fontsize{13} u / Theta');
hold on
for S = 1:N
    tint = ((S-1)*(Tfin/N)):res:(S*(Tfin/N));
    [j,k] = size(tint);
    u = Values(2*S-1:2*S);
    plot(tint,u(1)*ones(j,k),'--bx',...
         tint,u(2)*ones(j,k),'-rv');
         
end
legend('\fontsize{13} u',...
       '\fontsize{13} Theta',...
       'Location','Best');
hold off

%Make plot for Trajectory
figure;
title({['\fontsize{16}  Optimal Trajectory for:  N = ' num2str(N)];...
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


function dxdy = DiffEqIn(~,x,u,beta)
%[T,Y] = solver(odefun,tspan,y0,options)
%u = [u, theta];
q = (beta / ((x(2)^2 + (x(1)-3)^2)^(3/2))).*[3-x(1);-x(2)];
dxdy = [x(3);...
        x(4);...
        u(1)*cos(u(2)) + q(1);...
        u(1)*sin(u(2)) + q(2)];   