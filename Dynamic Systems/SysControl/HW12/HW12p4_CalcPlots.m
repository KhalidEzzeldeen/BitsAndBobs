function HW12p4_CalcPlots(GraphMethod)

A = [3,1;1,3];
B = [1;2];
Fc = [6,-9];
CC = [B,A*B];
CCinv = CC^-1;
q = CCinv(end,:);
P = [q;q*A];
F = Fc*P;
ue = 2 - F*[-.25;-1.25];

%Part (4):  Plot original system with control feedback

    t_int = 0:0.2:10;
    x_start = [-.25, -.2501, -.256, -.1; -1.25, -1.2487, -1.256, -2.7];
    sys1 = ss(A+B*F,B,[],[]);
    color = {'-b+','-ro','--b*','--rx',':bd',':rs','-.bv','-.r^'};
    switch GraphMethod
        case 1
        figure;
        title('\fontsize{16} System With Feedback for Various Initial Conditions');
        xlabel('\fontsize{13} Time');
        ylabel('\fontsize{13} x trajectories');
        hold on;
            for jj = 1:4
                [~,t,x] = lsim(sys1,ue*ones(size(t_int)),t_int,x_start(:,jj));
                plot(t,x(:,1), color{2*jj-1},...
                     t,x(:,2), color{2*jj});
            end
        legend('\fontsize{13} Start Cond 1, x1',...
               '\fontsize{13} Start Cond 1, x2',...
               '\fontsize{13} Start Cond 2, x1',...
               '\fontsize{13} Start Cond 2, x2',...
               '\fontsize{13} Start Cond 3, x1',...
               '\fontsize{13} Start Cond 3, x2',...
               '\fontsize{13} Start Cond 4, x1',...
               '\fontsize{13} Start Cond 4, x2',...
                'Location','NE');
        hold off;
        
        case 2
            figure;
            hold on;
            for jj = 1:4
                [~,t,x] = lsim(sys1,ue*ones(size(t_int)),t_int,x_start(:,jj));
                subplot(2,2,jj); 
                plot(t,x(:,1), color{2*jj-1},...
                     t,x(:,2), color{2*jj});
                title(['\fontsize{13} System With Feedback, Initial Condition ' num2str(jj) ' ']);
                xlabel('\fontsize{13} Time');
                ylabel('\fontsize{13} x trajectories');
                legend('\fontsize{13} x1',...
                       '\fontsize{13} x2',...
                       'Location','NE');
            end
            hold off;
    end