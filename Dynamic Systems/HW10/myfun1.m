function J = myfun1(Values,x0,Tfin,N,Const)

% x = fmincon(@myfun,x0,A,b,Aeq,beq,options)
% A = [1,0,0,0,0,0;     b = [1;     And '-' constraints as well.
%      0,0,1,0,0,0;          1;
%      0,0,0,0,1,0]          1];
% options=optimset('MaxFunEvals', 5000, 'TolFun',1e-8, 'TolX', 1e-8, 'MaxIter', 5000);

beta = Const(1);
rho = Const(2);
xStart = x0;
J = 0;
for Section = 1:N
    u = Values(2*Section-1:2*Section);
    [~,xSol] = ode45(@(t1,x1)DiffEqIn(t1,x1,u,beta),[0,Tfin/N],xStart);
    J = J + (10*u(1)^2 + 4*u(2)^2)*(Tfin/N);
    xStart = xSol(end,:);
    
end
J = J + rho*((xSol(end,1)-4)^2 + (xSol(end,2)-4)^2);


function dxdy = DiffEqIn(~,x,u,beta)
%[T,Y] = solver(odefun,tspan,y0,options)
%u = [u, theta];
q = (beta / ((x(2)^2 + (x(1)-3)^2)^(3/2))).*[3-x(1);-x(2)];
dxdy = [x(3);...
        x(4);...
        u(1)*cos(u(2)) + q(1);...
        u(1)*sin(u(2)) + q(2)];   