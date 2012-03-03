function xprime = odetest(t,x,ii)
% x(1) = x
% x(2) = y
A = inline('[1,t;0,2]','t');
B = inline('[1;5-t]','t');
n = length(x)^.5;
xNew = [];
for jj = 1:n
    xNew = [xNew,x(1+(n*(jj-1)):n*jj,1)];
end

switch ii
    case 1 %Calculate W
        gp = @(t,xin) A(t)*xin + xin*A(t)' + B(t)*B(t)';
    case 2 %Calculate X
        gp = @(t,xin) A(t)*xin;
end
tempgp = gp(t,xNew);
gpNew =[];
for jj = 1:n
    gpNew = [gpNew;tempgp(:,jj)];
end

xprime = gpNew;