function [sol, Cost] = NumSolveCode(Start,Stop,Guess)

%Creates initial guess for solution to bvp
%solinit = bvpinit(xDomain, yguess, params)

% %Part (i)
% sol = bvp4c(@OdeFunc, @(ya,yb) BCFunc(ya,yb,Init,Final), solinit);

%Part (ii)
lambda = 0.05;
solinit = bvpinit(linspace(Start,Stop,Stop-Start+1),Guess);
sol = bvp4c(@OdeFunc, @BCFunc, solinit);

color = {'-b+','-ro','--b*','--rx',':bd',':rs','-.bv','-.r^'};

%plot part (i)
x = linspace(Start,Stop);
%Evaluates solution to problem @ points from x
y = deval(sol,x);
y2 = deval(sol,2);
%Calculate cost of solution.
CostFunc = inline('.5*z(1,:).^2 + .5*z(2,:).^2', 'z');
Cost = (Stop / length(x) * CostFunc(y));
for Index = 2:length(Cost)
    Cost(Index) = Cost(Index) + Cost(Index-1);
end
Cost(end) = Cost(end) + .5*y(1,end)^2;
% size(CostFunc(y)), size(Cost), size(x), size(y), pause

figure;
title('\fontsize{16}  Numerically Calculated Trajectory and Control');
% title({'\fontsize{16}  Numerically Calculated Trajectory and Control'; 'Set Final Position'});
xlabel('\fontsize{13} Timestep');
ylabel('\fontsize{13} Position / Control');
hold on
plot(x,y(1,:),color{4}, x,-y(2,:),color{5},...
     Stop, y(1,end), color{6},...
     2,y2(1),color{6},...
     x,Cost, color{3},...
     Stop, Cost(end), color{1});
legend('\fontsize{13} Trajectory',...
       '\fontsize{13} Control',...
      ['\fontsize{13} Pos at t=2:  ' num2str((round(y2(1)*1000))/1000)],...
      ['\fontsize{13} Final Pos:  ' num2str((round(y(1,end)*1000))/1000)],...
       '\fontsize{13} Approx Cost',...
      ['\fontsize{13} Final Cost:  ' num2str((round(Cost(end)*10000))/10000)],...
       'Location','Best');
hold off

%Calculate cost of solution.
CostFunc = inline('.5*z(:,1).^2 + .5*z(:,2).^2', 'z');
Cost = sum(Stop / length(x) * CostFunc(y)) + .5*y(1,end)^2;

% %plot part (ii)
% x = linspace(Start,Stop);
% %Evaluates solution to problem @ points from x
% y = deval(sol,x);
% figure;
% title('\fontsize{16}  Numerically Calculated Trajectories, Part (ii)');
% xlabel('\fontsize{13} Timestep');
% ylabel('\fontsize{13} Position');
% hold on
% plot(x,y(1,:),color{4},x,y(2,:),color{5});
% legend('\fontsize{13} x1 Trajectory',...
%        '\fontsize{13} x2 Trajectory',...
%        'Location','Best');  
% hold off


function dxdy = OdeFunc(~,y,~)

dxdy = [-y(1)^3 - y(2);...
        3*y(2)*y(1)^2 - y(1)];
    
% function res = BCFunc(ya, yb, lambda)
% 
% res = [ya(1) - 0.5;...
%        yb(1) - yb(2);...
%        yb(1) - lambda ];
   
   
function res = BCFunc(ya, yb)

res = [ya(1) - 0.5;...
       yb(1) - yb(2)];