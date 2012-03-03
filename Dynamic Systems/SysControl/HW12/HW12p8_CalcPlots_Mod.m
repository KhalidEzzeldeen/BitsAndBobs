function HW12p8_CalcPlots_Mod()

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
% ue=2;

%Get K from part 5
CharPoly1 = inline('A*A+6*A+9*eye(length(A))');
% CharPoly2 = inline('A*A-20*A+100*eye(length(A))');
temp = HW12p5_Calcs(CharPoly1);
K = temp(:,1);

%Declare Problem Specific Variables
% Ap1 = [A+B*F,0*ones(size(A));...
%        K*C,A-K*C+B*F];
% Bp = [B;0*ones(size(B))];
% Cp = [C,0*ones(size(C));...
%       0*ones(size(C)),C];
  
%Define variables for calc'ing trajectories, plotting
t_int = 0:0.2:20;
ErrorTerms = zeros(length(t_int),8);
x_start = [-.25, -.2501, -.256, -.1; -1.25, -1.2487, -1.256, -2.7];
x_obs_start = [2;3.5];
color = {'-b+','--ro',':b*','-.rx',':g^',':rs','-.bv','-.r^'};
% sys1 = ss(Ap1,Bp,Cp,[]);
sys1 = ss(A+B*F,B,[],[]);


figure;
hold on;
for jj = 1:4
    [~,~,x] = lsim(sys1,DeltaPlot(t_int,0),...
                   t_int,[x_start(:,jj)',x_obs_start']');
    [~,t,x_hat] = lsim(sys1_hat,DeltaPlot(t_int,0),...
                   t_int,[x_start(:,jj)',x_obs_start']');
    ErrorTerms(:, 2*jj-1:2*jj) = x(:,1:2)-x(:,3:4);
    subplot(2,2,jj); 
    plot(t,x(:,1), color{1},...
         t,x(:,2), color{2},...
         t,x_hat(:,1), color{3},...
         t,x_hat(:,2), color{4},...
         t,DeltaPlot(t_int,0), color{5});
%     axis([4 7 -4 4])
    title({('\fontsize{11} System With Feedback and Observer,');...
           ['\fontsize{11} Delta Impulse, Initial Condition ' num2str(jj) ' ']});
    xlabel('\fontsize{13} Time');
    ylabel('\fontsize{13} x trajectories');
    legend('\fontsize{8} x1',...
           '\fontsize{8} x2',...
           '\fontsize{8} x1 obs',...
           '\fontsize{8} x2 obs',...
           'Location','SE');
%                   '\fontsize{8} Delta Imp.',...
end

hold off;


% STILL NEED E1, E2 PLOTS!!!!!!!!!

figure;
hold on;
for jj = 1:4
    subplot(2,2,jj); 
    plot(t,ErrorTerms(:,2*jj-1), color{1},...
         t,ErrorTerms(:,2*jj), color{2});
    axis([4 7 -4 4])
    title({('\fontsize{11} Error Terms:  System With Feedback ');...
           ['\fontsize{11} and Observer, Initial Condition ' num2str(jj) ' ']});
%     title({('\fontsize{11} Error Terms:  System Without Feedback ');...
%            ['\fontsize{11}  and Observer, Initial Condition ' num2str(jj) ' ']});
    xlabel('\fontsize{13} Time');
    ylabel('\fontsize{13} x trajectory errors');
    legend('\fontsize{8} e1',...
           '\fontsize{8} e2',...
           'Location','Best');
end
hold off;