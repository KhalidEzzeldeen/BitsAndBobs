function [xSol, uSol] = HW05OpenCont(Start, Stop, Guess)

% HW05OpenCont(0,10,[1,1]);

%Part (i):  Find optimal control for original system

solinit = bvpinit(linspace(Start,Stop,Stop-Start+1),Guess);
uSol = bvp4c(@OrigOdeFunc, @OrigBCFunc, solinit);

%Part (ii):  simulate the system using the theoretical optimal control
%found from Part (i).

%Simulate x trajectory with the Theory Control
xSol = ode45(@(t,y)SimxWCont(t,y,uSol), [0,10], 4);

% %Make plot for BVP
% color = {'-b+','-ro','--b*','--rx',':bd',':rs','-.bv','-.r^'};
% tint = linspace(Start,Stop);
% U = -0.5*deval(uSol, tint,2);
% X = deval(uSol, tint, 1);
% figure;
% title({'\fontsize{16}  Results from BVP'});
% xlabel('\fontsize{13} Timestep');
% ylabel('\fontsize{13} Position / Control');
% hold on
% plot(tint,U,color{4},...
%      tint,X,color{5},...
%      Stop, U(end), color{4},...
%      Stop, X(end), color{5});
% legend('\fontsize{13} Control',...
%        '\fontsize{13} Trajectory',...
%       ['\fontsize{13} Control at t=10:  ' num2str((round(U(end)*1000))/1000)],...
%       ['\fontsize{13} Pos at t=10:  ' num2str((round(X(end)*1000))/1000)],...
%        'Location','Best');
% hold off

% %Make plot for uSol and xSol..
% color = {'-b+','-ro','--b*','--rx',':bd',':rs','-.bv','-.r^'};
% tint = linspace(Start,Stop);
% U = -0.5*deval(uSol, tint,2);
% X = deval(xSol, tint);
% figure;
% title({'\fontsize{16}  Theoretical Optimal Control and';...
%         'Simulated x Trajectory using Control'});
% xlabel('\fontsize{13} Timestep');
% ylabel('\fontsize{13} Position / Control');
% hold on
% plot(tint,U,color{4},...
%      tint,X,color{5},...
%      Stop, U(end), color{4},...
%      Stop, X(end), color{5});
% legend('\fontsize{13} Control',...
%        '\fontsize{13} Trajectory',...
%       ['\fontsize{13} Control at t=10:  ' num2str((round(U(end)*1000))/1000)],...
%       ['\fontsize{13} Pos at t=10:  ' num2str((round(X(end)*1000))/1000)],...
%        'Location','Best');
% hold off

%Part (v):  simulate the open loop system with delta function

Delta = inline('4*(t>2).*((3-2)/2-abs(t-2.5)).*(t<3)', 't');
%Simulate x trajectory with the Theory Control; note, Thy Opt Cont is the
%same as above, only the delta function is new
xSolDel = ode45(@(t,y)SimxWContIn(t,y,uSol,Delta), [0,10], 4);

% %More plots
% color = {'-b+','-ro','--b*','--rx',':bd',':rs','-.bv','-.r^'};
% tint = linspace(Start,Stop);
% X = deval(xSol, tint);
% XDel = deval(xSolDel, tint);
% VertSpace = linspace(0,10);
% VertParam = ones(size(VertSpace));
% figure;
% title({'\fontsize{16}  X Traj. from Part (i) and';...
%         'Simulated X Traj. with TOC, Delta inputs'});
% xlabel('\fontsize{13} Timestep');
% ylabel('\fontsize{13} Position');
% hold on
% plot(tint,X,color{4},...
%      tint,XDel,color{5},...
%      2*VertParam,VertSpace,'k',...
%      3*VertParam,VertSpace,'k');
% legend('\fontsize{13} Original Trajectory',...
%        '\fontsize{13} Sim. Trajectory ',...
%        '\fontsize{13} Delta Start', '\fontsize{13} Delta Stop', ...
%        'Location','Best');
% hold off

%Part (vi):  simulate BVP with delta

Delta = inline('4*(t>2).*((3-2)/2-abs(t-2.5)).*(t<3)', 't');
%Simulate x trajectory with the Theory Control; note, Thy Opt Cont is the
%same as above, only the delta function is new
solinit = bvpinit(linspace(Start,Stop,Stop-Start+1),Guess);
DelSol = bvp4c(@(t,y)OrigOdeFuncIn(t,y,Delta), @OrigBCFunc, solinit);

% %More plots
% color = {'-b+','-ro','--b*','--rx',':bd',':rs','-.bv','-.r^'};
% tint = linspace(Start,Stop);
% X = deval(DelSol, tint,1);
% U = -0.5*deval(DelSol, tint,2);
% VertSpace = linspace(-2,4);
% VertParam = ones(size(VertSpace));
% figure;
% title({'\fontsize{16}  BVP with Delta Input (BVPD)'});
% xlabel('\fontsize{13} Timestep');
% ylabel('\fontsize{13} Position');
% hold on
% plot(tint,U,color{4},...
%      tint,X,color{5},...
%      Stop, U(end), color{4},...
%      Stop, X(end), color{5},...
%      2*VertParam,VertSpace,'k',...
%      3*VertParam,VertSpace,'k');
% legend('\fontsize{13} Control',...
%        '\fontsize{13} Trajectory',...
%       ['\fontsize{13} Control at t=10:  ' num2str((round(U(end)*1000))/1000)],...
%       ['\fontsize{13} Pos at t=10:  ' num2str((round(X(end)*1000))/1000)],...
%        '\fontsize{13} Delta Start', '\fontsize{13} Delta Stop', ...
%        'Location','Best');
% hold off

% %Compare BVP X to simulated X with delta input
% xSolDel = ode45(@(t,y)SimxWContIn(t,y,uSol,Delta), [0,10], 4);
% color = {'-b+','-ro','--b*','--rx',':bd',':rs','-.bv','-.r^'};
% tint = linspace(Start,Stop);
% X = deval(DelSol, tint,1);
% XDel = deval(xSolDel, tint);
% VertSpace = linspace(-2,4);
% VertParam = ones(size(VertSpace));
% figure;
% title({'\fontsize{16} BVPD X Trajectory and Simulated';...
%         'X Trajectory using BVPD Control'});
% xlabel('\fontsize{13} Timestep');
% ylabel('\fontsize{13} Position');
% hold on
% plot(tint,X,color{4},...
%      tint,XDel,color{5},...
%      2*VertParam,VertSpace,'k',...
%      3*VertParam,VertSpace,'k');
% legend('\fontsize{13} BVPD Trajectory',...
%        '\fontsize{13} Simulated Traj. with BVPD Control',...
%        '\fontsize{13} Delta Start', '\fontsize{13} Delta Stop', ...
%        'Location','Best');
% hold off


% %Calculate cost of solution.
% t = linspace(0,10);
% y(:,1) = deval(xSol,t);
% y(:,2) = -0.5*deval(uSol,t,2);
% CostFunc = inline('.5*z(:,1).^2 + 3*z(:,2).^2', 'z');
% Cost = sum(Stop / length(t) * CostFunc(y)) + 5*y(1,end)^2

%Functions for orig system solving
function dxdy = OrigOdeFunc(~,y,~)
dxdy = [.5*y(1) - 3/2*y(2);...
        -y(1) + .5*y(2)];
    
function res = OrigBCFunc(ya, yb)
res = [ya(1) - 4;...
       10*yb(1) - yb(2)];

%Function to feed into ode45 for simulating 'x'
function dy = SimxWCont(t,y,uSol)
u = -0.5*deval(uSol,t,2);
dy = .5*y + 3*u;

%Function with inline input to feed into ode45 for simulating 'x'
function dy = SimxWContIn(t,y,uSol,F)
u = -0.5*deval(uSol,t,2);
dy = .5*y + 3*u + F(t);

%Functions for system with delta solving
function dxdy = OrigOdeFuncIn(t,y,F)
dxdy = [.5*y(1) - 3/2*y(2) + F(t);...
        -y(1) + .5*y(2)];