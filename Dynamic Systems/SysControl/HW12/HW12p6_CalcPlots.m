function HW12p6_CalcPlots()

%Declare basic problem variables
A = [3,1;1,3];
B = [1;2];
C = [2,1];
Fc = [6,-9];
CC = [B,A*B];
CCinv = CC^-1;
q = CCinv(end,:);
P = [q;q*A];
F = Fc*P;
% ue = 2 - F*[-.25;-1.25];
ue = 0;

%Get K from part 5
CharPoly1 = inline('A*A+6*A+9*eye(length(A))');
% CharPoly2 = inline('A*A-20*A+100*eye(length(A))');
temp = HW12p5_Calcs(CharPoly1);
K = temp(:,1);

%Declare Problem Specific Variables
% Ap1 = [A+B*F,0*ones(size(A));...
%        K*C,A-K*C+B*F];
Ap2 = [A,0*ones(size(A));...
       K*C,A-K*C];
% Ap3 = [A+B*F,0*ones(size(A));...
%        K*C,A-K*C];
Bp = [B;B];
Cp = [C,0*ones(size(C));...
      0*ones(size(C)),C];
  
%Define variables for calc'ing trajectories, plotting
t_int = 0:0.2:10;
ErrorTerms = zeros(length(t_int),8);
x_start = [-.25, -.2501, -.256, -.1; -1.25, -1.2487, -1.256, -2.7];
x_obs_start = [2;3.5];
color = {'-b+','--ro',':b*','-.rx',':bd',':rs','-.bv','-.r^'};
% sys1 = ss(Ap1,Bp,Cp,[]);
sys2 = ss(Ap2,Bp,Cp,[]);
% sys3 = ss(Ap3,Bp,Cp,[]);


figure;
hold on;
for jj = 1:4
    [~,t,x] = lsim(sys2,ue*ones(size(t_int)),t_int,...
                  [x_start(:,jj)',x_obs_start']');
    ErrorTerms(:, 2*jj-1:2*jj) = x(:,1:2)-x(:,3:4);
    subplot(2,2,jj); 
    plot(t,x(:,1), color{1},...
         t,x(:,2), color{2},...
         t,x(:,3), color{3},...
         t,x(:,4), color{4});
    title({('\fontsize{14} System With Feedback and Observer,');...
           ['\fontsize{14} ue = 2, Initial Condition ' num2str(jj) ' ']});
%     title({('\fontsize{14} System Without Feedback and Observer, ');...
%            ['\fontsize{14} Initial Condition ' num2str(jj) ' ']});
%     title({('\fontsize{14} System With Partial Feedback ');...
%            ['\fontsize{14} and Observer, Initial Condition ' num2str(jj) ' ']});
    xlabel('\fontsize{13} Time');
    ylabel('\fontsize{13} x trajectories');
    legend('\fontsize{8} x1',...
           '\fontsize{8} x2',...
           '\fontsize{8} x1 obs',...
           '\fontsize{8} x2 obs',...
           'Location','NE');
%        
end
hold off;


% STILL NEED E1, E2 PLOTS!!!!!!!!!

figure;
hold on;
for jj = 1:4
    subplot(2,2,jj); 
    plot(t,ErrorTerms(:,2*jj-1), color{1},...
         t,ErrorTerms(:,2*jj), color{2});
%     title({('\fontsize{14} Error Terms:  System With Feedback ');...
%            ['\fontsize{14} and Observer, ue = 2,Initial Condition ' num2str(jj) ' ']});
    title({('\fontsize{14} Error Terms:  System Without Feedback ');...
           ['\fontsize{14}  and Observer, Initial Condition ' num2str(jj) ' ']});
    xlabel('\fontsize{13} Time');
    ylabel('\fontsize{13} x trajectory errors');
    legend('\fontsize{8} e1',...
           '\fontsize{8} e2',...
           'Location','Best');
end
hold off;
