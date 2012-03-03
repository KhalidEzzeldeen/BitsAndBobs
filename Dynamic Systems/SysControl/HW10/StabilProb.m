function StabilProb()

%Declare variables
A = [0,11,0,0;1,0,0,0;0,-1,0,0;0,0,1,0];
B = [-1,0,1,0]';
C = [0,0,0,0];
D = 0;
Fc = [-15,-51.5,-61,-14.5];
CC = [B,A*B,A^2*B,A^3*B];
CCinv = CC^-1;
q = CCinv(end,:);
P = [q;q*A;q*A^2;q*A^3];
F = Fc*P;

%Define the systems
sys1 = ss(A,[],[],[]);
sys2 = ss(A,B,C,D);
sys3 = ss(A+B*F,[],[],[]);
%DEfine initial conditions
x01 = [0.01,0,0,0]';
x03 = [0.5,0,0,0]';
%Calculate system behaviors
[~,t1,x1] = initial(sys1,x01,10);
[~,t2,x2] = step(sys2,10);
[~,t3,x3] = initial(sys3,x03,10);

figure;
    title('\fontsize{16} State Plot for Basic System');    
    xlabel('\fontsize{13} Time');
    ylabel('\fontsize{13} x Trajectories');
    hold on;
    plot(t1,x1(:,1),'-r*',...
         t1,x1(:,2),'--bs',...
         t1,x1(:,3),':mo',...
         t1,x1(:,4),'-.kv');
    legend('\fontsize{13} x1',...
           '\fontsize{13} x2',...
           '\fontsize{13} x3',...
           '\fontsize{13} x4','Location','Best');
    hold off;


figure;
    title('\fontsize{16} State Plot for u = Unit Step Function');    
    xlabel('\fontsize{13} Time');
    ylabel('\fontsize{13} x Trajectories');
    hold on;
    plot(t2,x2(:,1),'-r*',...
         t2,x2(:,2),'--bs',...
         t2,x2(:,3),':mo',...
         t2,x2(:,4),'-.kv');
    legend('\fontsize{13} x1',...
           '\fontsize{13} x2',...
           '\fontsize{13} x3',...
           '\fontsize{13} x4','Location','Best');
    hold off;
    
figure;
    title('\fontsize{16} State Plot for Closed-Loop System');    
    xlabel('\fontsize{13} Time');
    ylabel('\fontsize{13} x Trajectories');
    hold on;
    plot(t3,x3(:,1),'-r*',...
         t3,x3(:,2),'--bs',...
         t3,x3(:,3),':mo',...
         t3,x3(:,4),'-.kv');
    legend('\fontsize{13} x1',...
           '\fontsize{13} x2',...
           '\fontsize{13} x3',...
           '\fontsize{13} x4','Location','Best');
    hold off;
