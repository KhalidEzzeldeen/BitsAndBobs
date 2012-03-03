function HW13_EllipsePlots(zoom)

ABCSolve = [-2,14,0;-5,-3,7;0,-10,-4];
Pmake = eye(3)/ABCSolve*[-1,0,-1]';
P = [Pmake(1),Pmake(3);Pmake(3),Pmake(2)];
A = [-1,-5;7,-2];
B = [0;0];
I = -eye(2);

%First Ellipse, x'Px=1.
a1 = max((1/Pmake(1))^.5,(1/Pmake(3))^.5);
b1 = min((1/Pmake(1))^.5,(1/Pmake(3))^.5);
e1 = ((a1^2-b1^2)/a1^2)^.5;
[lat1, lon1] = ellipse1(0,0,[b1,e1]);

%Second Ellipse, x'Px=2.
a2 = max((2/Pmake(1))^.5,(2/Pmake(3))^.5);
b2 = min((2/Pmake(1))^.5,(2/Pmake(3))^.5);
e2 = ((a2^2-b2^2)/a2^2)^.5;
[lat2, lon2] = ellipse1(0,0,[b2,e2]);

%Create system, get points from several initial conditions
sys = ss(A,[],[],[]);
x_start = [1,-.5,3,1;1,1.5,2,-2];
color = {'-b*','-ko','--gd','--rs',':c^','-.mv'};
figure;
switch zoom
    case 0
        
        title('\fontsize{16} Ellipses and Unforced Response from Several Initial Conditions');
        xlabel('\fontsize{13} x1 Trajectory');
        ylabel('\fontsize{13} x2 Trajectory');
        axis square
        axis([-3,3,-3,3]);
        hold on;
        plot(lat1,lon1,color{5},lat2,lon2,color{6});
        t_span = 0:.05:10;

        for jj = 1:4
            [~,~,x] = initial(sys,x_start(:,jj),t_span);
            plot(x(:,1),x(:,2),color{jj});
        end

        legend('\fontsize{13} Ellipse 1',...
               '\fontsize{13} Ellipse 2',...
               '\fontsize{13} Start Cond 1',...
               '\fontsize{13} Start Cond 2',...
               '\fontsize{13} Start Cond 3',...
               '\fontsize{13} Start Cond 4',...
                'Location','Best');
        hold off;

    case 1

        title('\fontsize{16} Zoom of Unforced Response from Several Initial Conditions');
        xlabel('\fontsize{13} x1 Trajectory');
        ylabel('\fontsize{13} x2 Trajectory');
        axis square
        axis([-.0003,.0003,-.0003,.0003]);
        hold on;

        t_span = 0:.05:10;

        for jj = 1:4
            [~,~,x] = initial(sys,x_start(:,jj),t_span);
            plot(x(:,1),x(:,2),color{jj});
        end

        legend('\fontsize{13} Start Cond 1',...
               '\fontsize{13} Start Cond 2',...
               '\fontsize{13} Start Cond 3',...
               '\fontsize{13} Start Cond 4',...
                'Location','Best');
        hold off;
        
end