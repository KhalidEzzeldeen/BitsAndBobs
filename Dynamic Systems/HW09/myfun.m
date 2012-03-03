function F = myfun(x,u,w,start,T,NumSwitch, OptCond)

% x0 = [(pi+0.1)/4; (3*pi+0.1)/4; -2; -1];
% options=optimset('MaxFunEvals', 5000, 'TolFun',1e-8, 'TolX', 1e-8, 'MaxIter', 5000);
% [xSol,fval] = fsolve(@myfun,x0,options)
% u = 1;
%  uf =1;
xf = inline('(k/w)*sin(w*t) + (j - u/w^2)*cos(w*t) + u/w^2', 't', 'u', 'j', 'k','w');
vf = inline('k*cos(w*t) - w*(j - u/w^2)*sin(w*t)', 't', 'u','j','k','w');
x1f = inline('k*sin(w*t) + j*cos(w*t) + u/w^2', 't', 'u', 'j', 'k','w');
v1f= inline('w*k*cos(w*t) - w*j*sin(w*t)', 't', 'u','j','k','w');

% % Variable Switching, Bang-Bang
% F = [xf(x(1),u,start(1),start(2),w) - x1f(x(1),-u,x(3),x(4),w);...
%      vf(x(1),u,start(1),start(2),w) - v1f(x(1),-u,x(3),x(4),w)];
%  u1 = -u;
% for SwiInd = 2:NumSwitch
%     Start = 2*SwiInd-1;
%     End = 2*SwiInd;
%     u2 = -u1;
%     F = [F;...
%          x1f(x(1)+(SwiInd-1)*pi/w,u1,x(Start),x(End),w) - ...
%          x1f(x(1)+(SwiInd-1)*pi/w,u2,x(Start+2),x(End+2),w);...
%          v1f(x(1)+(SwiInd-1)*pi/w,u1,x(Start),x(End),w) - ...
%          v1f(x(1)+(SwiInd-1)*pi/w,u2,x(Start+2),x(End+2),w)];
%     u1 = u2;
% end
% F = [F;...
%      x1f(x(2),u2,x(Start+2),x(End+2),w);...
%      v1f(x(2),u2,x(Start+2),x(End+2),w)];
% % x0 = [(pi-1)/4; 2.5*pi-1; .4; 2.3; .33; 1.5; .25; .9; .2; .5];
% % options=optimset('MaxFunEvals', 5000, 'TolFun',1e-8, 'TolX', 1e-8,
% % 'MaxIter', 5000);


% Variable Switching, Bang-off-Bang
% x0 = [SwiTimes; DiffNowToOpt; Coeffs];
Lookup = [0,1,0; 1,0,-1; 0, -1, 0];
times = x(1:NumSwitch);
del = x(NumSwitch+1:2*NumSwitch-1);
coeffs = x(2*NumSwitch:end);
F = [xf(times(1),u,start(1),start(2),w) - x1f(times(1),0,coeffs(1),coeffs(2),w);...
     vf(times(1),u,start(1),start(2),w) - v1f(times(1),0,coeffs(1),coeffs(2),w);...
     coeffs(end)/w*cos(w*times(1)) - Lookup(u+2,2)];
for SwiInd = 2:NumSwitch
    %Index for new curve coeffs
    Start = 2*(ceil((SwiInd)/2))-1;
    End = 2*(ceil((SwiInd-1)/2));
    %Index for opt curve coeffs
    Start1 = 2*(ceil((SwiInd+1)/2))-1+2;
    End1 = 2*(ceil((SwiInd+1)/2))+2;
    %Compute u's for opt curves [1 1 -1 -1 1 1...]
    u1 = (-u)*(-1)^((mod(SwiInd-2,4)-mod(SwiInd,2))/2);
    F = [F;...
         x1f(times(SwiInd)-del(SwiInd-1),u1,OptCond(Start1),OptCond(End1),w) - ...
         x1f(times(SwiInd),0,coeffs(Start),coeffs(End),w);...
         v1f(times(SwiInd)-del(SwiInd-1),u1,OptCond(Start1),OptCond(End1),w) - ...
         v1f(times(SwiInd),0,coeffs(Start),coeffs(End),w)];
     if SwiInd<=3
         F = [F;coeffs(end)/w*cos(w*times(SwiInd)) - Lookup(u1+2,2)];
     end
end
F = [F;...
     x1f(T-del(end),u1,OptCond(Start1),OptCond(End1),w);...
     v1f(T-del(end),u1,OptCond(Start1),OptCond(End1),w);...
     T - sum(del) - OptCond(2)];
F = F'*F;

%5 switch, xstart = [3,2]
% x0 = [(pi-1)/4; 3*pi-1.5; .8; 3; .6; 2.3; .45; 1.5; .32; .9; .2; .5];
% xSol = [0.3218;7.8540; 1.8500; 1.2000; 1.4500; 0.9000; 1.0500; 0.6000;0.6500; 0.3000; 0.2500; -0.0000];

%4 switch, xstart = [1.1,3.3]
% x0 = [(pi-1)/4; 2.5*pi-1; .6; 2; .45; 1.5; .32; .9; .2; .5];

% 3 switch
% x0 = [pi/2-.5; 2*pi-.75; .45; 1.5; .32; .9; .2; .5];
% [xSol,fval] = fsolve(@(x)myfun(x,-1,2,[1.3,.7],0,3),x0,options)
% PlotTraj(xSol,[1.3,.7],-1,.01,2,3)