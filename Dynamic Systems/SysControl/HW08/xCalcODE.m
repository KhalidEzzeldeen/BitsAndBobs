function xprime = xCalcODE(t,xin,A,B,K)

%Set current values for X and x; make sure they are corect orientation and
%that X is in matrix form.

Q = xin(1:4); Q=Q(:); Q = [Q(1:2),Q(3:4)];
x = xin(5:end); x = x(:);

tempQ = A(t)*Q; %X
tempxp = A(t)*x + B(t)*B(t)'*(Q^-1)'*K; %Ax+Bu

xprime = [tempQ(:,1);tempQ(:,2);tempxp(:)];