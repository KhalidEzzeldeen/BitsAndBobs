function PlotTraj(xSol,u,y)

x = xSol;
% u = -1;
% y = 0.05;
%  uf =1;
xf = inline('(k/2)*sin(2*t) + (j - .5*u)*cos(2*t) + .5*u', 't', 'u', 'k', 'j');
vf = inline('k*cos(2*t) - (2*j - u)*sin(2*t)', 't', 'u','k','j');
x1f = inline('k*sin(2*t) + j*cos(2*t) + .5*u', 't', 'u', 'k', 'j');
v1f= inline('2*k*cos(2*t) - 2*j*sin(2*t)', 't', 'u','k','j');

% % Plot 2 Switch
% figure
% title({'\fontsize{16}  Phase Space Traj. for Opt. Switching Curve, 3 Switches';...
%         ['Total Time:  ' num2str((round(x(2)*1000)/1000)) ' units']});
% xlabel('\fontsize{13} Velocity Component');
% ylabel('\fontsize{13} Position Component');
% hold on
% plot(xf(0:y:x(1),u, 1.1,3.3),vf(0:y:x(1),u,1.1,3.3), 'r*')
% plot(x1f(x(1):y:x(1)+pi/2,-u,x(3),x(4)),v1f(x(1):y:x(1)+pi/2,-u,x(3),x(4)), 'b^')
% plot(x1f(x(1)+pi/2:y:x(2),u,x(5),x(6)),v1f(x(1)+pi/2:y:x(2),u,x(5),x(6)), 'r+')
% legend('\fontsize{13} Starting Curve, u=-1',...
%        '\fontsize{13} 2nd Curve',...
%        '\fontsize{13} Final Curve',...
%        'Location','West');
% hold off


% % Plot 3 Switch
% figure
% title({'\fontsize{16}  Phase Space Traj. for Opt. Switching Curve, 3 Switches';...
%         ['Total Time:  ' num2str((round(x(2)*1000)/1000)) ' units']});
% xlabel('\fontsize{13} Velocity Component');
% ylabel('\fontsize{13} Position Component');
% hold on
% plot(xf(0:y:x(1),u, 1.1,3.3),vf(0:y:x(1),u,1.1,3.3), 'r*')
% plot(x1f(x(1):y:x(1)+pi/2,-u,x(3),x(4)),v1f(x(1):y:x(1)+pi/2,-u,x(3),x(4)), 'b^')
% plot(x1f(x(1)+pi/2:y:x(1)+pi,u,x(5),x(6)),v1f(x(1)+pi/2:y:x(1)+pi,u,x(5),x(6)), 'b-')
% plot(x1f(x(1)+pi:y:x(2),u,x(7),x(8)),v1f(x(1)+pi:y:x(2),u,x(7),x(8)), 'r+')
% legend('\fontsize{13} Starting Curve, u=-1',...
%        '\fontsize{13} 2nd Curve',...
%        '\fontsize{13} 3rd Curve',...
%        '\fontsize{13} Final Curve',...
%        'Location','West');
% hold off

% Plot 4 Switch
figure
title({'\fontsize{16}  Phase Space Traj. for Opt. Switching Curve, 4 Switches';...
        ['Total Time:  ' num2str((round(x(2)*1000)/1000)) ' units']});
xlabel('\fontsize{13} Position Component');
ylabel('\fontsize{13} Velocity Component');
hold on
plot(xf(0:y:x(1),u, 1.1,3.3),vf(0:y:x(1),u,1.1,3.3), 'r*')
plot(x1f(x(1):y:x(1)+pi/2,-u,x(3),x(4)),v1f(x(1):y:x(1)+pi/2,-u,x(3),x(4)), 'b^')
plot(x1f(x(1)+pi/2:y:x(1)+pi,u,x(5),x(6)),v1f(x(1)+pi/2:y:x(1)+pi,u,x(5),x(6)), 'b-')
plot(x1f(x(1)+pi:y:x(1)+(3/2)*pi,-u,x(7),x(8)),v1f(x(1)+pi:y:x(1)+(3/2)*pi,-u,x(7),x(8)), 'bv')
plot(x1f(x(1)+(3/2)*pi:y:x(2),u,x(9),x(10)),v1f(x(1)+(3/2)*pi:y:x(2),u,x(9),x(10)), 'r+')
legend('\fontsize{13} Starting Curve, u=-1',...
       '\fontsize{13} 2nd Curve',...
       '\fontsize{13} 3rd Curve',...
       '\fontsize{13} 4th Curve',...
       '\fontsize{13} Final Curve',...
       'Location','SouthEast');
hold off