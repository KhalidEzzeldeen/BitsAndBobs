function HW07SInf(A,B,Q,R,SBC,T,guess)
% SinfSol = HW07SInf(A,B,Q,R,SBC,1000,[20,5,5,10]');


Rinv = R^-1;

interval = linspace(0,T,10*T);
solinit = bvpinit(interval,guess);
options = bvpset('RelTol', 1e-5);
SinfSol = bvp4c(@(x,s)SOdeFunc(x,s,A,B,Q,Rinv),...
                @(ya,yb)SBCFunc(ya,yb,SBC), solinit,options);
%                 f = SinfSol.y;
% fprintf('Value computed using infinity = %g is %7.5f %7.5f %7.5f %7.5f.\n', ...
%          T,f(1,1),f(2,1),f(3,1),f(4,1))
     
%Get Sinf and define Kinf    
Sinf = SinfSol.y(:,1);
Sinf = [Sinf(1:2),Sinf(3:4)];
Kinf = Rinv*B'*Sinf;

%Get S(t) for K(t), T=1, 10
T1 = 10;
Tinterval = linspace(0,T1,100*T1);
solinit = bvpinit(Tinterval,guess);
SSol = bvp4c(@(x,s)SOdeFunc(x,s,A,B,Q,Rinv),...
             @(ya,yb)SBCFunc(ya,yb,SBC), solinit,options);
Kt = deval(Tinterval,SSol);
            
% %Plot that shit, use multiplot
% color = {'-b+','--ro',':b*','-.rx',':bd',':rs','-.bv','-.r^'};
% figure;
% hold on;
% for jj = 1:2
%     subplot(2,1,jj); 
%     plot(Tinterval,Kinf(jj)*ones(size(Tinterval)), color{1},...
%          Tinterval,(Kt(jj,:)+Kt(jj+2,:))*Rinv, color{2});
%     title({('\fontsize{14} Kinf vs. K(t) for T = 10,');...
%            ['\fontsize{14} Component ' num2str(jj) ' ']});
% %     title({('\fontsize{14} Kinf vs. K(t) for T = 10,');...
% %            ['\fontsize{14} Component ' num2str(jj) ' ']});
%     xlabel('\fontsize{13} Time');
%     ylabel('\fontsize{13} K values');
%     legend(['\fontsize{8} Kinf Comp ' num2str(jj) ' '],...
%            ['\fontsize{8} K(t) Comp ' num2str(jj) ' '],...
%            'Location','NE');
% %        
% end
% hold off;
            

%Get Trajectories for the two systems; this will allow for cost calculation and
%plotting Kinf vs. K(t)
solinit = bvpinit(Tinterval,[2,4]');
xSolKinf = bvp4c(@(t,y)KinfOdeFunc(t,y,A,B,Kinf),...
                 @(ya,yb)TrajBC(ya,yb), solinit,options);
xSolKvar = bvp4c(@(t,y)KvarOdeFunc(t,y,A,B,Rinv,SSol),...
                 @(ya,yb)TrajBC(ya,yb), solinit,options);

% %Plot that shit, use multiplot
% color = {'-b+','--ro',':b*','-.rx',':bd',':rs','-.bv','-.r^'};
% figure;
% hold on;
% for jj = 1:2
%     xinf = deval(Tinterval,xSolKinf,jj);
%     xt = deval(Tinterval,xSolKvar,jj);
%     subplot(2,1,jj); 
%     plot(Tinterval,xinf, color{1},...
%          Tinterval,xt, color{2});
%     title({('\fontsize{14} Comparison of Trajectories for T = 10,');...
%            ['\fontsize{14} Component ' num2str(jj) ' ']});
% %     title({('\fontsize{14} Kinf vs. K(t) for T = 10,');...
% %            ['\fontsize{14} Component ' num2str(jj) ' ']});
%     xlabel('\fontsize{13} Time');
%     ylabel('\fontsize{13} x trajectories');
%     legend(['\fontsize{8} Traj from Kinf, Comp ' num2str(jj) ' '],...
%            ['\fontsize{8} Traj from K(t), Comp ' num2str(jj) ' '],...
%            'Location','NE');
% %        
% end
% hold off;
 
%Calculate cost of solution.
Kt = [Kt(1,:)+Kt(3,:); Kt(2,:)+Kt(4,:)] / 2;
xinf = deval(Tinterval,xSolKinf);
xt = deval(Tinterval,xSolKvar);
CostInf = 0;
CostT = 0;
parts = length(Tinterval);
for ind = 1:length(Tinterval)
    CostT = CostT + xt(:,ind)'*(Q + 2*Kt(:,ind)*Kt(:,ind)')*xt(:,ind)*(T1/parts);
    CostInf = CostInf + xinf(:,ind)'*(Q + 2*Kinf(:)*Kinf(:)')*xinf(:,ind)*(T1/parts);
end
CostT = (CostT + xt(:,end)'*SBC*xt(:,end)) / 2;
CostInf = (CostInf + xinf(:,end)'*SBC*xinf(:,end)) / 2;

fprintf('Costs associated with T = %g are %7.5f (Kinf) and %7.5f.\n', ...
         T1,CostInf, CostT)

           
%Functions for finding Sinf from given S(T)
%Update S
function ds = SOdeFunc(~,s,A,B,Q,Rinv)
    n = length(A);
    S = zeros(n);
    %Wrap vector s into matrix S
    for index = 1:n
        S(:,index) = s((index-1)*n+1:index*n);
    end
    dS = -A'*S - S*A - Q + S*B*Rinv*B'*S;
    ds = zeros(size(s));
    %Unwrap matrix dS into vector ds
    for index = 1:n
        ds((index-1)*n+1:index*n) = dS(:,index);
    end

%Define BC, i.e. S(T), for Sinf
function res = SBCFunc(~, yb,SBC)
    n = length(SBC);
    sBC = zeros(n^2,1);
    for index = 1:n
        sBC((index-1)*n+1:index*n,1) = SBC(:,index);
    end
    res = yb(:) - sBC;
    
%Function for otp system solving
function dy = KvarOdeFunc(t,y,A,B,Rinv,SSol)
    y = y(:);
    S = deval(SSol, t);
    S = [S(1:2),S(3:4)];
    dy = (A - B*Rinv*B'*S)*y;
    dy = dy(:);

%Function for Kinf system
function dy = KinfOdeFunc(~,y,A,B,Kinf)
    y = y(:);
    dy = (A - B*Kinf)*y;
    dy = dy(:);
    
%Boundary condition for traj; same for both systems
function res = TrajBC(ya,~)
    res = ya - [1;-1];