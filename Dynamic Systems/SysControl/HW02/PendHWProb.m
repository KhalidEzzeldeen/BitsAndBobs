function PendHWProb(tspan,g,l)

xin = [pi/18,pi/12,pi/6,pi/3;0,0,0,0];
xmin = [0,0,0,0];
xmax = [.2, .3 ,.55, 1.15];
ymin = [0,0,0,0];
ymax = [.6, .85, 1.75, 3.5];
n = size(xin,2);
options = [];
markers = {'x','o','*','s','d'};
colors = {'b','g','r','bl','c','m','y'};
sAng = {'pi/18', 'pi/12', 'pi/6', 'pi/3'};
for kk = 1:n
  figure;
  
  
  title({['\fontsize{16} Phase Plot for Pendulum, Quad 1, Starting Angle:  ' sAng{kk} '    '] ; 'Comparison of Linear Approximation To Non-Linear Equations    '});
  xlabel('\fontsize{13} Angular Velocity (rad/sec)    ');
  ylabel('\fontsize{13} Angular Displacement (rad. from horizontal)    ');
  axis square
  axis([xmin(kk),xmax(kk),ymin(kk),ymax(kk)]);
  hold on;
  for ii = 1:2
      [~,s] = ode45(@odetest, tspan, xin(:,kk), options,ii, g,l);
      plot(s(:,1), s(:,2),'LineStyle', 'none', 'Marker', markers{ii},...
          'MarkerFaceColor', colors{ii}, 'MarkerEdgeColor', colors{ii}, 'MarkerSize', 9);
      if ii==2, legend('\fontsize{14} Non-Linear Case','\fontsize{14} Linear Case'); end
  end
end
  hold off;
  
% end


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