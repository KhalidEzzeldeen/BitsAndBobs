function [GlobalMins Grad] = ProblemForm2(Function)
Grad = 0;
%Get something like the global min to the function
Best = GlobalMultiFind(Function);
Global = Best(3);

%Set up functions, boundaries for algorithm
switch Function
    case 1
        fprintf('Trying to find all global mins of the 1st function.\n');
        %Setup stuff
        x1_Start = -10;
        x2_Start = -10;
        x1_End = 10;
        x2_End = 10;
        func01 = inline('(sin(2*x(:,1)+1)+2*sin(3*x(:,1)+2)+3*sin(4*x(:,1)+3)+4*sin(5*x(:,1)+4)+5*sin(6*x(:,1)+5)).*(sin(2*x(:,2)+1)+2*sin(3*x(:,2)+2)+3*sin(4*x(:,2)+3)+4*sin(5*x(:,2)+4)+5*sin(6*x(:,2)+5)) + (x(:,1)+1.42513).^2 + (x(:,1)+0.80032).^2','x');
        delfunc01 = inline('(2*cos(2*x(:,1)+1)+6*cos(3*x(:,1)+2)+12*cos(4*x(:,1)+3)+20*cos(5*x(:,1)+4)+30*cos(6*x(:,1)+5)).*(sin(2*x(:,2)+1)+2*sin(3*x(:,2)+2)+3*sin(4*x(:,2)+3)+4*sin(5*x(:,2)+4)+5*sin(6*x(:,2)+5)) + 2*(x(:,1)+1.42513)','x');
        delfunc02 = inline('(sin(2*x(:,1)+1)+2*sin(3*x(:,1)+2)+3*sin(4*x(:,1)+3)+4*sin(5*x(:,1)+4)+5*sin(6*x(:,1)+5)).*(2*cos(2*x(:,2)+1)+6*cos(3*x(:,2)+2)+12*cos(4*x(:,2)+3)+20*cos(5*x(:,2)+4)+30*cos(6*x(:,2)+5)) + 2*(x(:,2)+0.80032)','x');
    case 2
        fprintf('Trying to find all global mins of the 2nd function.\n');
        %Setup stuff
        x1_Start = -10;
        x2_Start = -10;
        x1_End = 10;
        x2_End = 10;
        func01 = inline('(sin(2*x(:,1)+1)+2*sin(3*x(:,1)+2)+3*sin(4*x(:,1)+3)+4*sin(5*x(:,1)+4)+5*sin(6*x(:,1)+5)).*(sin(2*x(:,2)+1)+2*sin(3*x(:,2)+2)+3*sin(4*x(:,2)+3)+4*sin(5*x(:,2)+4)+5*sin(6*x(:,2)+5))','x');
        delfunc01 = inline('(2*cos(2*x(:,1)+1)+6*cos(3*x(:,1)+2)+12*cos(4*x(:,1)+3)+20*cos(5*x(:,1)+4)+30*cos(6*x(:,1)+5)).*(sin(2*x(:,2)+1)+2*sin(3*x(:,2)+2)+3*sin(4*x(:,2)+3)+4*sin(5*x(:,2)+4)+5*sin(6*x(:,2)+5))','x');
        delfunc02 = inline('(sin(2*x(:,1)+1)+2*sin(3*x(:,1)+2)+3*sin(4*x(:,1)+3)+4*sin(5*x(:,1)+4)+5*sin(6*x(:,1)+5)).*(2*cos(2*x(:,2)+1)+6*cos(3*x(:,2)+2)+12*cos(4*x(:,2)+3)+20*cos(5*x(:,2)+4)+30*cos(6*x(:,2)+5))','x');
        
    case 3
        fprintf('Trying to find all global mins of the 3rd function.\n');
        %Setup stuff
        x1_Start = -100;
        x2_Start = -100;
        x1_End = 100;
        x2_End = 100;
        Pfunc01 = inline('-cos(x(:,1)).*cos(x(:,2)).*exp(-(x(:,1)-k).^2/100 - (x(:,2)-k).^2/100)','x','k');
        Pdelfunc01 = inline('sin(x(:,1)).*cos(x(:,2)).*exp(-(x(:,1)-k).^2/100 - (x(:,2)-k).^2/100)  - (1/50)*(x(:,1)-k).*cos(x(:,1)).*cos(x(:,2)).*exp(-(x(:,1)-k).^2/100 - (x(:,2)-k).^2/100)','x','k');
        Pdelfunc02 = inline('cos(x(:,1)).*sin(x(:,2)).*exp(-(x(:,1)-k).^2/100 - (x(:,2)-k).^2/100)  - (1/50)*(x(:,2)-k).*cos(x(:,1)).*cos(x(:,2)).*exp(-(x(:,1)-k).^2/100 - (x(:,2)-k).^2/100)','x','k');
        func01 = @(x)Pfunc01(x,pi);
        delfunc01 = @(x)Pdelfunc01(x,pi);
        delfunc02 = @(x)Pdelfunc02(x,pi);
       
end


%Get mesh of function values for finding local mins
switch Function
    case 1
        res = 0.05;
        [X1,X2] = meshgrid(x1_Start:res:x1_End, x2_Start:res:x2_End);
        funcValues = (sin(2*X1+1)+2*sin(3*X1+2)+3*sin(4*X1+3)+4*sin(5*X1+4)+5*sin(6*X1+5)).*...
                     (sin(2*X2+1)+2*sin(3*X2+2)+3*sin(4*X2+3)+4*sin(5*X2+4)+5*sin(6*X2+5)) +...
                     (X1+1.42513).^2 + (X2+0.80032).^2;
%         [FX,FY] = gradient(funcValues,res);
%         Grad = Grad+numel(X1);
    case 2
        res = 0.05;
        [X1,X2] = meshgrid(x1_Start:res:x1_End, x2_Start:res:x2_End);
        funcValues = (sin(2*X1+1)+2*sin(3*X1+2)+3*sin(4*X1+3)+4*sin(5*X1+4)+5*sin(6*X1+5)).*...
                             (sin(2*X2+1)+2*sin(3*X2+2)+3*sin(4*X2+3)+4*sin(5*X2+4)+5*sin(6*X2+5));
%         [FX,FY] = gradient(funcValues,res);
%         Grad = Grad+numel(X1);
    case 3
        res = 0.1;
        [X1,X2] = meshgrid(x1_Start:res:x1_End, x2_Start:res:x2_End);
        funcValues = -cos(X1).*cos(X2).*exp(-(X1-pi).^2/100 -(X2-pi).^2/100);
%         [FX,FY] = gradient(funcValues,res);
%         Grad = Grad+numel(X1);
end
[x,y] = size(X1);
SX = sparse(length(X1),length(X2));
for index_y = 1:y
    for index_x = 1:x
        if funcValues(index_y,index_x) <= max(0.95*Global,1.05*Global)
            SX(index_y,index_x)=1;
        end
    end
end
% Locations(1,:) = [];
% Locations,pause

% SX = sparse(length(X1),length(X2));
SY = sparse(length(X1),length(X2));
% %Get desired switching locations in x direction.
% [x,y] = size(FX);
% for index_y = 1:y
%     %Check to see what initial slope is, where we are, yo.
%     switch FX(index_y,1)>0
%         case 0 %first value is less then 0
%             if func01([X1(index_y,1),X2(index_y,1)])...
%                         <= max(0.95*Global,1.05*Global)
%                 SX(index_y,1) = 1; %#ok<*SPRIX>
%             end
%             Sign = 1;
%         case 1 %1st value is >0
%             Sign = 2;
%     end
%     for index_x = 2:x
%         switch Sign
%             case 1
%                 if FX(index_y,index_x) > 0
%                     if func01([X1(index_y,index_x),X2(index_y,index_x)])...
%                         <= max(0.95*Global,1.05*Global)
%                         SX(index_y,index_x)=1;
%                         SX(index_y,index_x-1)=1;
%                     end
%                     Sign = 3;
%                 end
%             case 2
%                 if FX(index_y,index_x) < 0
%                     Sign = 1;
%                 end
%             case 3
%                 if FX(index_y,index_x) < 0
%                     Sign = 2;
%                 end
%         end 
%     end
% end
% 
% %Get desired switching locations in y direction.
% [x,y] = size(FY);
% for index_x = 1:x
%     %Check to see what initial slope is, where we are, yo.
%     switch FY(1,index_x)>0
%         case 0 %first value is less then 0
%             if func01([X1(1,index_x),X2(1,index_x)])...
%                         <= max(0.95*Global,1.1*Global)
%                 SY(1,index_x) = 1; %#ok<*SPRIX>
%             end
%             Sign = 1;
%         case 1 %1st value is >0
%             Sign = 2;
%     end
%     for index_y = 1:y
%         switch Sign
%             case 1
%                 if FY(index_y,index_x) > 0
%                     if func01([X1(index_y,index_x),X2(index_y,index_x)])...
%                         <= max(0.95*Global,1.05*Global)
%                         SY(index_y,index_x)=1;
%                         SY(index_y-1,index_x)=1;
%                     end
%                     Sign = 3;
%                 end
%             case 2
%                 if FY(index_y,index_x) < 0
%                     Sign = 1;
%                 end
%             case 3
%                 if FY(index_y,index_x) < 0
%                     Sign = 2;
%                 end
%         end 
%     end
% end
% %Create matric that shows where approximate location of mins are
SS = full(SX)+full(SY);
% %Stuff for plots
% set(gcf,'Renderer','zbuffer')
% surf(SS,'DisplayName','SS');figure(gcf)
% figure;
% set(gcf,'Renderer','zbuffer')
% mesh(X1,X2,funcValues)

%Get points where all conditions are met, search for global mins.
[Mins_y,Mins_x] = find(SS==1);
% [Mins_y, Mins_x, X1(Mins_y,Mins_x),X2(Mins_y,Mins_x)],pause

% Get rid of duplicates
Locations = zeros(length(Mins_x),2);
[KK,~] = size(Locations);
for Mins = 1:KK
    Temps = [X1(Mins_y(Mins),Mins_x(Mins)),X2(Mins_y(Mins),Mins_x(Mins))];
%     Temps = Locations(Mins,:);
    Order = 1*10^(-floor(log10(abs(Temps(1))))+1);
    Locations(Mins,1) = (round(Temps(1)*Order))/Order;
    Order = 1*10^(-floor(log10(abs(Temps(2))))+1);
    Locations(Mins,2) = (round(Temps(2)*Order))/Order;
%     Locations(Mins,:),pause
end
Locations = unique(Locations,'rows');
%Do local search stuff using modded Steepest Decent
fprintf('Found all candidates, now searching locally.\n');
tol = abs(Global/100);
GlobalMins = ones(length(Locations),4)*Inf;
for Mins = 1:length(Locations)
    CurrentLoc = Locations(Mins,:);
    [New Temp] = LocalOptSearch(CurrentLoc,func01,delfunc01,delfunc02,[],[],[]);
    Grad = Grad + Temp;
    if abs(New(3)-Global)<tol
       GlobalMins(Mins,:) = New;
    end
end
GlobalMins(GlobalMins(:,1)==Inf,:)=[];
%Try and weed out same coordinate solutions
Locations = zeros(length(GlobalMins),2);
[KK,~] = size(GlobalMins);
for k = 1:KK
    Temps = [GlobalMins(k,1),GlobalMins(k,2)];
    Order = 1*10^(-floor(log10(abs(Temps(1))))+2);
    Locations(k,1) = (round(Temps(1)*Order))/Order;
    Order = 1*10^(-floor(log10(abs(Temps(2))))+2);
    Locations(k,2) = (round(Temps(2)*Order))/Order;
end
[Locations,I,~] = unique(Locations,'rows');
% Locations,pause
GlobalMins = GlobalMins(I,:);
GlobalMins(:,1:2) = Locations;
fprintf('The candidates for the global mins are shown below (possibly repeats): [x,y,funcVal,Grad].\n\n');

%Search for minimum using steepest descent once you get something close
%to global min.
function [New Grad] = LocalOptSearch(Start,func01,delfunc01,delfunc02,~,~,~)
    Grad = 0;
    x = Start;
    tol = 1e-3;
    Error = (delfunc01(x)^2+delfunc02(x)^2)^.5;
        
    %This is a modified Steepest Decent method...
    Exit = 0;
    while abs(Error) > tol && Exit == 0
        fdel = [delfunc01(x),delfunc02(x)];
        Grad = Grad+1;
        CurVal = func01(x);
        NewVal = 9999;
        Alpha = 0.05;
        Atol = 1e-10;
        while NewVal > CurVal && Alpha > Atol
            x_New = x - Alpha*fdel;
            NewVal = func01(x_New);
            Alpha = Alpha/2;
        end
%         fprintf('At (%d, %d) with FuncVal %d and Eculid. norm of the gradient %d.\n',...
%                  x(1),x(2),NewVal,(delfunc01(x_New)^2+delfunc02(x_New)^2)^.5);
        if NewVal < CurVal
           x = x_New;
        end
        if Alpha <= Atol
            Exit=1;
%             fprintf('Function stopped because alpha reduced below allowed value and no improvement found.\n')
        end
        Error = (delfunc01(x)^2+delfunc02(x)^2)^.5;
    end
    New = [x func01(x) (delfunc01(x)^2+delfunc02(x)^2)^.5];
    
    