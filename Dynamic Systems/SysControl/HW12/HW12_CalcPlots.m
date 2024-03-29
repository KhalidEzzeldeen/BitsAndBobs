function HW12_CalcPlots(GraphMethod)

A1 = [3,1;1,3];
B1 = [1;2];
xe = [-1/4;-5/4];

%Part (2):  Plot original form around xe, u = 2.
    %Declare nec. variables
    
    ue = 2;
    t_int = 0:0.02:1;
    x_start = [-.25, -.2501, -.256, -.1; -1.25, -1.2487, -1.256, -2.7];
    sys1 = ss(A1,B1,[],[]);
    color = {'-b+','-ro','--b*','--rx',':bd',':rs','-.bv','-.r^'};
    switch GraphMethod
        case 1
        figure;
        title('\fontsize{16} Plot for Original System for Various Initial Conditions');
        xlabel('\fontsize{13} Time');
        ylabel('\fontsize{13} x trajectories');
        hold on;
            for jj = 1:4
                [~,t,x] = lsim(sys1,ue*ones(size(t_int)),t_int,x_start(:,jj));
                plot(t,x(:,1), color{2*jj-1},...
                     t,x(:,2), color{2*jj},'MarkerSize',10);
            end
        legend('\fontsize{13} Start Cond 1, x1',...
               '\fontsize{13} Start Cond 1, x2',...
               '\fontsize{13} Start Cond 2, x1',...
               '\fontsize{13} Start Cond 2, x2',...
               '\fontsize{13} Start Cond 3, x1',...
               '\fontsize{13} Start Cond 3, x2',...
               '\fontsize{13} Start Cond 4, x1',...
               '\fontsize{13} Start Cond 4, x2',...
                'Location','Best');
        hold off;
        
        case 2
            figure;
            hold on;
            for jj = 1:4
                [~,t,x] = lsim(sys1,ue*ones(size(t_int)),t_int,x_start(:,jj));
                hold on
                subplot(2,2,jj); 
                plot(t,x(:,1), color{2*jj-1},...
                     t,x(:,2), color{2*jj});
                title(['\fontsize{11} Plot for Original System, Initial Condition ' num2str(jj) ' ']);
                xlabel('\fontsize{13} Time');
                ylabel('\fontsize{13} x trajectories');
                legend('\fontsize{13} x1',...
                       '\fontsize{13} x2',...
                       'Location','Best');
            end
            hold off;
    end
