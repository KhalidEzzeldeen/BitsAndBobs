

func = inline('sin(2*x+1)+2*sin(3*x+2)+3*sin(4*x+3)+4*sin(5*x+4)+5*sin(6*x+5)','x');
delfunc = inline('2*cos(2*x+1)+6*cos(3*x+2)+12*cos(4*x+3)+20*cos(5*x+4)+30*cos(6*x+5)','x');
FUNC = inline('-(4*sin(2*x+1)+18*sin(3*x+2)+48*sin(4*x+3)+100*sin(5*x+4)+180*sin(6*x+5))','x');
% X = -10:.01:10;
% 
% plot(6:.01:6.8,func(6:.01:6.8),6:.01:6.8,delfunc(6:.01:6.8),6:.01:6.8,FUNC(6:.01:6.8)/10)
plot(-10:.05:10,func(-10:.05:10),-10:.05:10,delfunc(-10:.05:10),-10:.05:10,FUNC(-10:.05:10)/10)
legend('\fontsize{13} func',...
       '\fontsize{13} delfunc',...
       '\fontsize{13} FUNC',...
       'Location','Best');

%All local min setup
Range = [-10,10];
Points = Range(1):0.1:Range(2);
Changes = diff(func(Points));
Index = [];
Sign = 2;
Current = 1;
for index = 1:length(Changes)
   switch Sign
       case 1
           if Changes(index) > 0
               Sign = 3;
           end
       case 2
           if Changes(index) < 0
               Index(Current,1) = index;
               Sign = 1;
           end
       case 3
           if Changes(index) < 0
              Index(Current,2) = index-1;
              Sign = 2;
              Current = Current+1;
           end
           
   end
end
if Index(end,2)==0
    Index(end,:) = [];
end
Index01 = Index;
% size(Index),pause
% Index(:,1)=Index(:,1)+1;
% Index(:,2)=Index(:,2)-1;

tol = 1e-3;
% x_Start = 6;
% xEnd=6.8;
FoundMins = zeros(size(Index));

for Mins = 1:length(Index01)
    x_Start = Points(Index01(Mins,1));
    x_End = Points(Index01(Mins,2));
    
    %Steepest decent method

    x=x_Start;
    error = delfunc(x);
    fprintf('Starting steepest decent with tol = %d\n',tol);
    fprintf('on range %d to %d.\n', x_Start, x_End)

    while abs(error)>tol
        Alps = (0:1e-4:abs((x-x_End)/delfunc(x)))';
        Vals = func(x-Alps*delfunc(x));
        Index = find(Vals==min(Vals));
        x_new = x-Alps(Index)*delfunc(x);
        error = delfunc(x_new);
        fprintf('The new gradient at %d is %d.\n', x_new,error);
        x = x_new;
%         pause
    end

    fprintf('The minimum obtained with SD for the given tolerence is: %d.\n', x);
    fprintf('The value of the function here is: %d.\n\n', func(x));
    FoundMins(Mins,:) = [x,func(x)];


%     %Newton's method
% 
%     x=x_Start;
%     error = delfunc(x);
%     fprintf('Starting Newtons with tol = %d.\n',tol);
% 
%     while abs(error)>tol
%        x_new = x - (1/FUNC(x))*delfunc(x);
%        if x_new < x_Start
%           fprintf('New x value left region.  Moving in opposite direction.\n');
%           x_new =  x + (1/FUNC(x))*delfunc(x);
%        end
%        error = delfunc(x_new);
%        fprintf('The new gradient at %d is %d.\n', x_new,error);
%        x = x_new;
%     %    pause
%     end
% 
%     fprintf('The minimum obtained with Newtons for the given tolerence is: %d.\n', x);
%     fprintf('The value of the function here is: %d.\n\n', func(x));

end