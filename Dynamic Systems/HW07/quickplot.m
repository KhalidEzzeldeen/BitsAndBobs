function quickplot(Sol,Tmax)


% color = {'-b+','-ro','--b*','--rx',':bd',':rs','-.bv','-.r^'};
interval = linspace(0,Tmax);
S = deval(interval,Sol);
hold on
plot(interval,S(1,:),'-b+',...
     interval,S(2,:),'-ro',...
     interval,S(3,:),':bd',...
     interval,S(4,:),'-.r^');
legend('\fontsize{13} s1',...
       '\fontsize{13} s2',...
       '\fontsize{13} s3',...
       '\fontsize{13} s4',...
       'Location','Best');
hold off