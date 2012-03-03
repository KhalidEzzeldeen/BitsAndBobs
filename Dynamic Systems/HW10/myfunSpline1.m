function J = myfunSpline1(Values,x0,Tfin,N,Const)

% x = fmincon(@myfun,x0,A,b,Aeq,beq,options)
% options=optimset('MaxFunEvals', 5000, 'TolFun',1e-8, 'TolX', 1e-8, 'MaxIter', 5000);
%Values need to have one more entry now, namely the final value of u and
%theta

beta = Const(1);
rho = Const(2);
xStart = [x0,Values(1),Values(2)];
J = 0;
for Section = 1:N
    U = [Values((2*Section-1):(2*Section))'; Values((2*Section+1):(2*Section+2))'];
    [~,xSol] = ode45(@(t1,x1)DiffEqIn(t1,x1,U,beta,Tfin/N),[0,Tfin/N],xStart);
    [~,JTmp] = ode45(@(t,j)DiffEqJ(t,j,U,Tfin/N),[0,Tfin/N],[0,U(1,:)]);
    J = J + JTmp(end,1);
    xStart = xSol(end,:);
    
end
J = J + rho*((xSol(end,1)-4)^2 + (xSol(end,2)-4)^2);


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