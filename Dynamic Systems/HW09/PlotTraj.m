function PlotTraj(xSol,start,u,y,W,NumSwitch)

x = xSol;
xf = inline('(k/w)*sin(w*t) + (j - u/w^2)*cos(w*t) + u/w^2', 't', 'u', 'j', 'k','w');
vf = inline('k*cos(w*t) - w*(j - u/w^2)*sin(w*t)', 't', 'u','j','k','w');
x1f = inline('k*sin(w*t) + j*cos(w*t) + u/w^2', 't', 'u', 'j', 'k','w');
v1f= inline('w*k*cos(w*t) - w*j*sin(w*t)', 't', 'u','j','k','w');


color = {'b+','ro','g*','kx',':bd',':rs','-.bv','-.r^'};

% Plot Variable Switches, given xSol, Bang-Bang or Bang-Off-Bang
w = W;
figure
title({['\fontsize{16}  Phase Space Traj. for Opt. Switching Curve, '...
        num2str(NumSwitch) ' Switches'];...
        ['Start:  [' num2str(start(1)) ',' num2str(start(2))...
        '], Total Time:  ' num2str((round(x(2)*1000)/1000)) ' units']});
xlabel('\fontsize{13} Velocity Component');
ylabel('\fontsize{13} Position Component');
hold on
%Plot start curve
plot(xf(0:y:x(1),u,start(1),start(2),w),vf(0:y:x(1),u,start(1),start(2),w), 'r+')
u1 = -u;
for SwiInd = 2:NumSwitch
    Start = 2*SwiInd-1;
    End = 2*SwiInd;
%     u1 = u*mod(SwiInd,2)*(-1)^((SwiInd-1)/2);
    TInt = (x(1)+(SwiInd-2)*pi/w):y:(x(1)+(SwiInd-1)*pi/w);
    plot(x1f(TInt,u1,x(Start),x(End),w),v1f(TInt,u1,x(Start),x(End),w), 'b-')
    u1 = -u1;
end
%Plot final curve
% u1 = u*mod(SwiInd+1,2)*(-1)^((SwiInd)/2);
plot(x1f(TInt(end):y:x(2),u1,x(Start+2),x(End+2),w),...
     v1f(TInt(end):y:x(2),u1,x(Start+2),x(End+2),w), 'r+')
hold off




% % Furthest Distance Plot for N Switches, Bang-Bang
% figure
% title('\fontsize{16}  Furthest Distance in Phase Space for N Switches');
% xlabel('\fontsize{13} Position Component');
% ylabel('\fontsize{13} Velocity Component');
% hold on
% for wInd = 1:length(W)
%     w = W(wInd);
%     plot(xf(0:y:pi/w,u,0,0,w),vf(0:y:pi/w,u,0,0,w), color{wInd})
%     xI = xf(pi/w,u, 0,0,w);
%     vI = vf(pi/w,u,0,0,w);
%     for SwiInd = 2:NumSwitch+1
%         plot(xf(0:y:pi/w,(-1)^(SwiInd-1)*u,vI,xI,w),...
%              vf(0:y:pi/w,(-1)^(SwiInd-1)*u,vI,xI,w), color{wInd})
%         xI = xf(pi/w,(-1)^(SwiInd-1),vI,xI,w);
%         vI = vf(pi/w,(-1)^(SwiInd-1),vI,xI,w);
%     end
% end
% hold off

% PlotTraj([],1,.05,[1,1.25,2],5)


% % Plot 4 Switch
% figure
% title({'\fontsize{16}  Phase Space Traj. for Opt. Switching Curve, 4 Switches';...
%         ['Total Time:  ' num2str((round(x(2)*1000)/1000)) ' units']});
% xlabel('\fontsize{13} Position Component');
% ylabel('\fontsize{13} Velocity Component');
% hold on
% plot(xf(0:y:x(1),u, 1.1,3.3,w),vf(0:y:x(1),u,1.1,3.3,w), 'r*')
% plot(x1f(x(1):y:x(1)+pi/2,-u,x(3),x(4),w),v1f(x(1):y:x(1)+pi/2,-u,x(3),x(4),w), 'b^')
% plot(x1f(x(1)+pi/2:y:x(1)+pi,u,x(5),x(6),w),v1f(x(1)+pi/2:y:x(1)+pi,u,x(5),x(6),w), 'b-')
% plot(x1f(x(1)+pi:y:x(1)+(3/2)*pi,-u,x(7),x(8),w),v1f(x(1)+pi:y:x(1)+(3/2)*pi,-u,x(7),x(8),w), 'bv')
% plot(x1f(x(1)+(3/2)*pi:y:x(2),u,x(9),x(10),w),v1f(x(1)+(3/2)*pi:y:x(2),u,x(9),x(10),w), 'r+')
% legend('\fontsize{13} Starting Curve, u=-1',...
%        '\fontsize{13} 2nd Curve',...
%        '\fontsize{13} 3rd Curve',...
%        '\fontsize{13} 4th Curve',...
%        '\fontsize{13} Final Curve',...
%        'Location','SouthEast');
% hold off