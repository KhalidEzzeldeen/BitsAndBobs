function BasePlot(xin,k)

u = -1;
x = xin';
% xin = [3.3,1.1;4,2;0,0];

xf = inline('(k/2)*sin(2*t) + (j - .5*u)*cos(2*t) + .5*u', 't', 'u', 'k', 'j');
vf = inline('k*cos(2*t) - (2*j - u)*sin(2*t)', 't', 'u','k','j');
x1f = inline('k*sin(2*t) + j*cos(2*t) + .5*u', 't', 'u', 'k', 'j');
v1f= inline('2*k*cos(2*t) - 2*j*sin(2*t)', 't', 'u','k','j');

xdot = vf;
vdot = inline('-4*((k/2)*sin(2*t) + (j - .5*u)*cos(2*t) +.5*u) + 2*u', 't', 'u', 'k', 'j');
x1dot = v1f;
v1dot = inline('-4*(k*sin(2*t) + j*cos(2*t) +.5*u) + 2*u', 't', 'u', 'k', 'j');


figure
title({'\fontsize{16} Phase Space Traj. for Several';...
        '\fontsize{16} Initial Values, with Direction'});
xlabel('\fontsize{13} Position Component');
ylabel('\fontsize{13} Velocity Component');
hold on
plot(-.5,0,'k^','MarkerSize',16)
plot(0.5,0,'kv','MarkerSize',16)
plot(0,0,'ko','MarkerSize',18)
for ind = 1:k
%     %u = 1
%     quiver(xf(1:.1:5,1,x(1,ind),x(2,ind)),vf(1:.1:5,1,x(1,ind),x(2,ind)),...
%            xdot(1:.1:5,1,x(1,ind),x(2,ind)),vdot(1:.1:5,1,x(1,ind),x(2,ind)),'r-')
%     %u = -1
%     quiver(xf(1:.1:5,-1, x(1,ind),x(2,ind)),vf(1:.1:5,-1,x(1,ind),x(2,ind)),...
%            xdot(1:.1:5,-1,x(1,ind),x(2,ind)),vdot(1:.1:5,-1,x(1,ind),x(2,ind)),'b-')
%     %u = 0
%     quiver(xf(1:.1:5,0, x(1,ind),x(2,ind)),vf(1:.1:5,0,x(1,ind),x(2,ind)),...
%            xdot(1:.1:5,0,x(1,ind),x(2,ind)),vdot(1:.1:5,0,x(1,ind),x(2,ind)),'g-')
       %u = 1
    plot(xf(1:.1:5,1,x(1,ind),x(2,ind)),vf(1:.1:5,1,x(1,ind),x(2,ind)),'^r')
    %u = -1
    plot(xf(1:.1:5,-1, x(1,ind),x(2,ind)),vf(1:.1:5,-1,x(1,ind),x(2,ind)),'xb')
    %u = 0
    plot(xf(1:.1:5,0, x(1,ind),x(2,ind)),vf(1:.1:5,0,x(1,ind),x(2,ind)),'+g')
end
legend('\fontsize{13} Center for u=1 curves ',...
       '\fontsize{13} Center for u=-1 curves ',...
       '\fontsize{13} Center for u=0 curves ',...
       '\fontsize{13} u=1 curves ',...
       '\fontsize{13} u=-1 curves ',...
       '\fontsize{13} u=0 curves ',...
       'Location','Best');
hold off

% figure
% title({'\fontsize{16} Phase Space Traj. for Several';...
%         '\fontsize{16} Initial Values, Alternating u'});
% xlabel('\fontsize{13} Position Component');
% ylabel('\fontsize{13} Velocity Component');
% hold on
% plot(-.5,0,'k^','MarkerSize',16)
% plot(0.5,0,'kv','MarkerSize',16)
% for ind = 1:k
%     plot(xf(1:.1:5,(-1)^(ind-1)*u,x(1,ind),x(2,ind)),vf(1:.1:5,(-1)^(ind-1)*u,x(1,ind),x(2,ind)),'r-')
% end
% legend('\fontsize{13} Center for u=1 curves ',...
%        '\fontsize{13} Center for u=-1 curves ',...
%        'Location','Best');
% hold off