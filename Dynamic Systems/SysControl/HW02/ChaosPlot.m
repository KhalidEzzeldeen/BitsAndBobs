function ChaosPlot(tspan,g,l)

xin = [pi/18,pi/12,pi/6,pi/3;0,0,0,0];
options = [];
sAng = {'pi/18', 'pi/12', 'pi/6', 'pi/3'};

for ii = 1:2
    figure;
    title(['\fontsize{16} Phase Plot for Pendulum, Selected Points, Starting Angle:  ' sAng{4} '    ']);    
    xlabel('\fontsize{13} Angular Velocity (rad/sec)    ');
    ylabel('\fontsize{13} Angular Displacement (rad. from horizontal)    ');
    [~,s] = ode45(@odetest, tspan, xin(:,4), options,ii, g,l);
    TestIndex = (1:50:(length(s)-100))+100;
    
    hold on;
    plot(s(TestIndex,1),s(TestIndex,2),'LineStyle', '--', 'Marker', 'o',...
              'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r', 'MarkerSize', 9);
    hold off;
end


function xprime = odetest(~,x,ii,g,l)
% x(1) = x
% x(2) = y

switch ii
    case 1
        gp = @(xin) -g*l*sin(xin);
    case 2
        gp = @(xin) -g*l*xin;
    
end

xprime(1) = x(2);
xprime(2) = gp(x(1));
xprime = xprime(:);