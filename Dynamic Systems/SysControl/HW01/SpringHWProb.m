function SpringHWProb(tspan, xin, k, a)

n = size(xin,2);
options = [];
colors = {'b','g','r','bl','c','m','y'};
for ii = 1:3
  figure;  
  switch ii
      case 1, spring = 'Hard Spring';
      case 2, spring = 'Linear Spring';
      case 3, spring = 'Soft Spring';
  end
  title(['\fontsize{16} Phase Plot for ' spring]);
  xlabel('\fontsize{13} Velocity Component');
  ylabel('\fontsize{13} Position Component');
  axis square
  axis([-1 1 -1 1])
  hold on;
  for kk = 1:n
      [~,s] = ode45(@odetest, tspan, xin(:,kk), options, ii,a,k);
      plot(s(:,1), s(:,2),'Color', colors{1+mod(kk,6)});
  end
  hold off;
  
end


function xprime = odetest(~,x,ii,a,k)
% x(1) = x
% x(2) = y

switch ii
    case 1
        gp = @(xin) k*(1+a^2*xin^2)*xin;
    case 2
        gp = @(xin) k*xin;
    case 3
        gp = @(xin) k*(1-a^2*xin^2)*xin;
end

xprime(1) = x(2);
xprime(2) = -gp(x(1));
xprime = xprime(:);