function [xSol, SSol] = HW05KalmCont(Start, Stop, Guess)

% HW05KalmCont(0,10,1);

%Part (iii):  Calculate the Kalman Gain, get S

%Should be able to use BVP solver to get S, since this works when provided
%with a final value for the function.  No need to re-write S in terms of
%different variables and use ode45.
solinit = bvpinit(linspace(Start,Stop,Stop-Start+1),Guess);
SSol = bvp4c(@SOdeFunc, @SBCFunc, solinit);

%Part (iv):  Simulate the system using the Kalman Gain calculated from part
%(iii)

xSol = ode45(@(t,y)SimxWKalm(t,y,SSol), [0,10], 4);

% %Make plot for uSol and xSol..
% color = {'-b+','-ro','--b*','--rx',':bd',':rs','-.bv','-.r^'};
% tint = linspace(Start,Stop);
% X = deval(xSol, tint);
% U = -deval(SSol, tint).*X;
% figure;
% title({'\fontsize{16} Control from Kalman and';...
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

%Part (vi):  simulate the open loop system with delta function

Delta = inline('4*(t>2).*((3-2)/2-abs(t-2.5)).*(t<3)', 't');
xSolDel = ode45(@(t,y)SimxWKalmIn(t,y,SSol,Delta), [0,10], 4);

% %More plots
% color = {'-b+','-ro','--b*','--rx',':bd',':rs','-.bv','-.r^'};
% tint = linspace(Start,Stop);
% X = deval(xSol, tint);
% XDel = deval(xSolDel, tint);
% VertSpace = linspace(0,4);
% VertParam = ones(size(VertSpace));
% figure;
% title({'\fontsize{16}  X Traj. from Part (iv) and';...
%         'X Traj. with Kalm. and Delta as inputs'});
% xlabel('\fontsize{13} Timestep');
% ylabel('\fontsize{13} Position');
% hold on
% plot(tint,X,color{4},...
%      tint,XDel,color{5},...
%      Stop, X(end), color{4},...
%      Stop, XDel(end), color{5},...
%      2*VertParam,VertSpace,'k',...
%      3*VertParam,VertSpace,'k');
% legend('\fontsize{13} Original Trajectory',...
%        '\fontsize{13} Trajectory with Delta ',...
%       ['\fontsize{13} Orig Pos at t=10:  ' num2str((round(X(end)*1000))/1000)],...
%       ['\fontsize{13} Delta Pos at t=10:  ' num2str((round(XDel(end)*1000))/1000)],...
%        '\fontsize{13} Delta Start', '\fontsize{13} Delta Stop', ...
%        'Location','Best');
% hold off


% %Calculate cost of solution.
% t = linspace(0,10);
% y(:,1) = deval(xSol,t);
% y(:,2) = 0.5*deval(SSol,t);
% CostFunc = inline('.5*z(:,1).^2 + 3*z(:,2).^2', 'z');
% Cost = sum(Stop / length(t) * CostFunc(y)) + 5*y(1,end)^2

%Functions for finding the initial value of S
function dy = SOdeFunc(~,y,~)
dy = -y(1) + y(1)^2*(9/6) - 1;
   
function res = SBCFunc(~, yb)
res = yb(1) - 10;

%Functions for simulating x traj. with the Kalman Gain, feedback
function dy = SimxWKalm(t,y,SSol)
S = (1/2)*deval(SSol, t);
dy = (0.5 - 3*S)*y(1);

%Function with inline input to feed into ode45 for simulating 'x'
function dy = SimxWKalmIn(t,y,SSol,F)
S = (1/2)*deval(SSol, t);
dy = (0.5 - 3*S)*y(1) + F(t);