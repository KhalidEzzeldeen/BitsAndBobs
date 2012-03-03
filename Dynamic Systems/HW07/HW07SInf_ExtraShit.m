function SinfSol = HW07SInf(A,B,Q,R,SBC,T,guess)

infinity = T;
% maxinfinity = -50;

% SinfSol = HW07SInf(A,B,Q,R,SBC,1000,[20,5,5,10]');
% [20,5,5,10]
    Rinv = R^-1;
    interval = linspace(0,infinity,10*infinity);

    solinit = bvpinit(interval,guess);
    options = bvpset('RelTol', 1e-5);
    SinfSol = bvp4c(@(x,s)SOdeFunc(x,s,A,B,Q,Rinv),...
                    @(ya,yb)SBCFunc(ya,yb,SBC), solinit,options);
                
    f = SinfSol.y;
    fprintf('Value computed using infinity = %g is %7.5f %7.5f %7.5f %7.5f.\n', ...
         infinity,f(1,1),f(2,1),f(3,1),f(4,1))
%     count=1;
%     for Bnew = -(infinity)+10:10:-maxinfinity
%         count = count+1;
%         solinit = bvpinit(SinfSol,[-Bnew,0]);
%         SinfSol = bvp4c(@(x,s)SOdeFunc(x,s,A,B,Q,Rinv),...
%                     @(ya,yb)SBCFunc(ya,yb,SBC),solinit,options);
%                 
%         eta = SinfSol.x;
%         f = SinfSol.y;
%         fprintf('Value computed using infinity = %g is %7.5f.\n', ...
%                 -Bnew,f(4,1))
%     end

%     S = deval(SinfSol, interval,1);
%     plot(interval,S);
% %          linspace(0,T,num),S(2,:),...
% %          linspace(0,T,num),S(3,:),...
% %          linspace(0,T,num),S(4,:));
%             
            
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