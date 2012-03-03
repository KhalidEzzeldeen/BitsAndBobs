function [Best Grad] = GlobalMultiFind(Function)
% Best = GlobalMultiFind(4,1)
% fprintf('\n');
%Select the function you want to find the minimum for from the three
%assigned.
switch Function
    case 1
        fprintf('Trying to find a global minimum of the 1st function.\n');
        %Setup stuff
        x1_Start = -10;
        x2_Start = -10;
        x1_End = 10;
        x2_End = 10;
        StartPoint = [10,10];
        func01 = inline('(sin(2*x(:,1)+1)+2*sin(3*x(:,1)+2)+3*sin(4*x(:,1)+3)+4*sin(5*x(:,1)+4)+5*sin(6*x(:,1)+5)).*(sin(2*x(:,2)+1)+2*sin(3*x(:,2)+2)+3*sin(4*x(:,2)+3)+4*sin(5*x(:,2)+4)+5*sin(6*x(:,2)+5)) + (x(:,1)+1.42513).^2 + (x(:,1)+0.80032).^2','x');
        delfunc01 = inline('(2*cos(2*x(:,1)+1)+6*cos(3*x(:,1)+2)+12*cos(4*x(:,1)+3)+20*cos(5*x(:,1)+4)+30*cos(6*x(:,1)+5)).*(sin(2*x(:,2)+1)+2*sin(3*x(:,2)+2)+3*sin(4*x(:,2)+3)+4*sin(5*x(:,2)+4)+5*sin(6*x(:,2)+5)) + 2*(x(:,1)+1.42513)','x');
        delfunc02 = inline('(sin(2*x(:,1)+1)+2*sin(3*x(:,1)+2)+3*sin(4*x(:,1)+3)+4*sin(5*x(:,1)+4)+5*sin(6*x(:,1)+5)).*(2*cos(2*x(:,2)+1)+6*cos(3*x(:,2)+2)+12*cos(4*x(:,2)+3)+20*cos(5*x(:,2)+4)+30*cos(6*x(:,2)+5)) + 2*(x(:,2)+0.80032)','x');
            
        delFunc11 = inline('-(4*sin(2*x(:,1)+1)+18*sin(3*x(:,1)+2)+48*sin(4*x(:,1)+3)+100*sin(5*x(:,1)+4)+180*sin(6*x(:,1)+5)).*(sin(2*x(:,2)+1)+2*sin(3*x(:,2)+2)+3*sin(4*x(:,2)+3)+4*sin(5*x(:,2)+4)+5*sin(6*x(:,2)+5)) + 2*(x(:,1))','x');
        delFunc22 = inline('-(sin(2*x(:,1)+1)+2*sin(3*x(:,1)+2)+3*sin(4*x(:,1)+3)+4*sin(5*x(:,1)+4)+5*sin(6*x(:,1)+5)).*(4*sin(2*x(:,2)+1)+18*sin(3*x(:,2)+2)+48*sin(4*x(:,2)+3)+100*sin(5*x(:,2)+4)+480*sin(6*x(:,2)+5)) + 2*(x(:,2))','x');
        delFunc12 = inline('(2*cos(2*x(:,1)+1)+6*cos(3*x(:,1)+2)+12*cos(4*x(:,1)+3)+20*cos(5*x(:,1)+4)+30*cos(6*x(:,1)+5)).*(2*cos(2*x(:,2)+1)+6*cos(3*x(:,2)+2)+12*cos(4*x(:,2)+3)+20*cos(5*x(:,2)+4)+30*cos(6*x(:,2)+5))','x');
    case 2
        fprintf('Trying to find a global minimum of the 2nd function.\n');
        %Setup stuff
        x1_Start = -10;
        x2_Start = -10;
        x1_End = 10;
        x2_End = 10;
        StartPoint = [10,10];
        func01 = inline('(sin(2*x(:,1)+1)+2*sin(3*x(:,1)+2)+3*sin(4*x(:,1)+3)+4*sin(5*x(:,1)+4)+5*sin(6*x(:,1)+5)).*(sin(2*x(:,2)+1)+2*sin(3*x(:,2)+2)+3*sin(4*x(:,2)+3)+4*sin(5*x(:,2)+4)+5*sin(6*x(:,2)+5))','x');
        delfunc01 = inline('(2*cos(2*x(:,1)+1)+6*cos(3*x(:,1)+2)+12*cos(4*x(:,1)+3)+20*cos(5*x(:,1)+4)+30*cos(6*x(:,1)+5)).*(sin(2*x(:,2)+1)+2*sin(3*x(:,2)+2)+3*sin(4*x(:,2)+3)+4*sin(5*x(:,2)+4)+5*sin(6*x(:,2)+5))','x');
        delfunc02 = inline('(sin(2*x(:,1)+1)+2*sin(3*x(:,1)+2)+3*sin(4*x(:,1)+3)+4*sin(5*x(:,1)+4)+5*sin(6*x(:,1)+5)).*(2*cos(2*x(:,2)+1)+6*cos(3*x(:,2)+2)+12*cos(4*x(:,2)+3)+20*cos(5*x(:,2)+4)+30*cos(6*x(:,2)+5))','x');
        
        delFunc11 = inline('-(4*sin(2*x(:,1)+1)+18*sin(3*x(:,1)+2)+48*sin(4*x(:,1)+3)+100*sin(5*x(:,1)+4)+180*sin(6*x(:,1)+5)).*(sin(2*x(:,2)+1)+2*sin(3*x(:,2)+2)+3*sin(4*x(:,2)+3)+4*sin(5*x(:,2)+4)+5*sin(6*x(:,2)+5))','x');
        delFunc22 = inline('-(sin(2*x(:,1)+1)+2*sin(3*x(:,1)+2)+3*sin(4*x(:,1)+3)+4*sin(5*x(:,1)+4)+5*sin(6*x(:,1)+5)).*(4*sin(2*x(:,2)+1)+18*sin(3*x(:,2)+2)+48*sin(4*x(:,2)+3)+100*sin(5*x(:,2)+4)+480*sin(6*x(:,2)+5))','x');
        delFunc12 = inline('(2*cos(2*x(:,1)+1)+6*cos(3*x(:,1)+2)+12*cos(4*x(:,1)+3)+20*cos(5*x(:,1)+4)+30*cos(6*x(:,1)+5)).*(2*cos(2*x(:,2)+1)+6*cos(3*x(:,2)+2)+12*cos(4*x(:,2)+3)+20*cos(5*x(:,2)+4)+30*cos(6*x(:,2)+5))','x');
    
    case 3
        fprintf('Trying to find a global minimum of the 3rd function.\n');
        %Setup stuff
        x1_Start = -100;
        x2_Start = -100;
        x1_End = 100;
        x2_End = 100;
        StartPoint = [100,100];
        Pfunc01 = inline('-cos(x(:,1)).*cos(x(:,2)).*exp(-(x(:,1)-k).^2/100 - (x(:,2)-k).^2/100)','x','k');
        Pdelfunc01 = inline('sin(x(:,1)).*cos(x(:,2)).*exp(-(x(:,1)-k).^2/100 - (x(:,2)-k).^2/100)  - (1/50)*(x(:,1)-k).*cos(x(:,1)).*cos(x(:,2)).*exp(-(x(:,1)-k).^2/100 - (x(:,2)-k).^2/100)','x','k');
        Pdelfunc02 = inline('cos(x(:,1)).*sin(x(:,2)).*exp(-(x(:,1)-k).^2/100 - (x(:,2)-k).^2/100)  - (1/50)*(x(:,2)-k).*cos(x(:,1)).*cos(x(:,2)).*exp(-(x(:,1)-k).^2/100 - (x(:,2)-k).^2/100)','x','k');
        func01 = @(x)Pfunc01(x,pi);
        delfunc01 = @(x)Pdelfunc01(x,pi);
        delfunc02 = @(x)Pdelfunc02(x,pi);
        delFunc11 = [];
        delFunc22 = [];
        delFunc12 = [];

end
Exit = 0;
Best = [0,0,999];
CurrentLoc = StartPoint;
MaxAxis=4;
AxisList = 1:MaxAxis;
while Exit <= 8
    
    if Exit==0
        %Select best direction to start with, the alternate.
        %x-axis points
        Points_x = (x1_Start:0.01:x1_End)';
        Points_x = {Points_x, CurrentLoc(2)};
        %y-axis points
        Points_y = (x2_Start:0.01:x2_End)';
        Points_y = {CurrentLoc(1),Points_y};
        %Get min points on these lines
        New_x = LineSearch(Points_x,1,Function);
        New_y = LineSearch(Points_y,2,Function);
        %Need diagonals too
        x1 = StartPoint(1) - x1_End;
        x2 = StartPoint(1) - x1_Start;
        y1 = StartPoint(2) - x2_End;
        y2 = StartPoint(2) - x2_Start;
        %x=y diagonal
        D1P1 = [CurrentLoc(1)-min(x2,y2),CurrentLoc(2)-min(x2,y2)];
        D1P2 = [CurrentLoc(1)-min(x1,y1),CurrentLoc(2)-min(x1,y1)];
        D1X = (D1P1(1):0.01:D1P2(1))';
        D1Y = (D1P1(2):0.01:D1P2(2))';
        Points_D1 = {D1X,D1Y};
        %x=-y diagonal
        D2P1 = [CurrentLoc(1)-min(x1,y2),CurrentLoc(2)+min(x1,y2)];
        D2P2 = [CurrentLoc(1)+min(x2,y1),CurrentLoc(2)-min(x2,y1)];
        D2X = (D2P1(1):0.01:D2P2(1))';
        D2Y = (D2P1(2):0.01:D2P2(2))';
        Points_D2 = {D2X,D2Y};
        %Get min points on these lines
        New_D1 = LineSearch(Points_D1,3,Function);
        New_D2 = LineSearch(Points_D2,4,Function);
        %Determine which one obtains the minimum function value and select
        %as the new point to search from.
        Values = [New_x(3),New_y(3),New_D1(3),New_D2(3)];
        Axis = find(Values==min(Values));
        Axis = Axis(ceil(rand*length(Axis)));
        switch Axis
            case 1; New = New_x;
            case 2; New = New_y;
            case 3; New = New_D1;
            case 4; New = New_D2;
        end
        
    else
        %Alternating portion for when no improvement found last time;
        %prevents stepping backwards.
        
        switch Axis
            case 1
                Points = (x1_Start:0.1:x1_End)';
                Points = {Points, CurrentLoc(2)};
            case 2
                Points = (x2_Start:0.1:x2_End)';
                Points = {CurrentLoc(1),Points};
            case 3
                x1 = StartPoint(1) - x1_End;
                x2 = StartPoint(1) - x1_Start;
                y1 = StartPoint(2) - x2_End;
                y2 = StartPoint(2) - x2_Start;
                P1 = [CurrentLoc(1)-min(x2,y2),CurrentLoc(2)-min(x2,y2)];
                P2 = [CurrentLoc(1)-min(x1,y1),CurrentLoc(2)-min(x1,y1)];
                X = (P1(1):0.1:P2(1))';
                Y = (P1(2):0.1:P2(2))';
                Points = {X,Y};
            case 4
                x1 = StartPoint(1) - x1_End;
                x2 = StartPoint(1) - x1_Start;
                y1 = StartPoint(2) - x2_End;
                y2 = StartPoint(2) - x2_Start;
                P1 = [CurrentLoc(1)-min(x1,y2),CurrentLoc(2)+min(x1,y2)];
                P2 = [CurrentLoc(1)+min(x2,y1),CurrentLoc(2)-min(x2,y1)];
                X = (P1(1):0.1:P2(1))';
                Y = (P1(2):0.1:P2(2))';
                Points = {X,Y};
        end
        New = LineSearch(Points,Axis,Function);
    end
    CurrentLoc = New(1:2);
    %Force location update, regardless of improvement or not.  This is an
    %attempt to remove algorithm from local min.
    %Check for best, record new minimum location if obtained
    if New(3) < Best(3)
        Best = New;
        Exit=0;
        AxisList = 1:MaxAxis;
    else
        Exit = Exit+1;
        AxisList(AxisList==Axis)=[];
        if ~isempty(AxisList)
            Axis = AxisList(ceil(rand*length(AxisList)));
        else
            AxisList = 1:MaxAxis;
            Axis = AxisList(ceil(rand*MaxAxis));
        end
    end
%     fprintf('The current (x,y) coordinates are: (%d,%d).\n',CurrentLoc(1),CurrentLoc(2));
end
% fprintf('\n');
fprintf('Best value obtained from iterative line search  %d.\n',func01(Best(1:2)));
fprintf('Starting local minimization at coordinates (%d, %d).\n',Best(1),Best(2));
[Best Grad] = LocalOptSearch(Best(1:2),func01,delfunc01,delfunc02,delFunc11,delFunc22,delFunc12);
% fprintf('\n');
fprintf('Best location found after steepest descent from optimal point found by iterative line search is:\n'); 
fprintf('(%d,%d).\n',Best(1),Best(2));
fprintf('The function value here is %d, and the Euclid. norm of the gradient here is %d.\n\n',Best(3),Best(4));




%Does line search along desired axis from current location.
function New = LineSearch(Points,Axis,Function)
% New = LineSearch(Points,Coords,Function);

    X1 = Points{1};
    X2 = Points{2};
    %Get desired values for whichever function is being used
    switch Function
            case 1
                funcValues = (sin(2*X1+1)+2*sin(3*X1+2)+3*sin(4*X1+3)+4*sin(5*X1+4)+5*sin(6*X1+5)).*...
                             (sin(2*X2+1)+2*sin(3*X2+2)+3*sin(4*X2+3)+4*sin(5*X2+4)+5*sin(6*X2+5)) +...
                             (X1+1.42513).^2 + (X2+0.80032).^2;
            case 2
                funcValues = (sin(2*X1+1)+2*sin(3*X1+2)+3*sin(4*X1+3)+4*sin(5*X1+4)+5*sin(6*X1+5)).*...
                             (sin(2*X2+1)+2*sin(3*X2+2)+3*sin(4*X2+3)+4*sin(5*X2+4)+5*sin(6*X2+5));
            case 3
                funcValues = -cos(X1).*cos(X2).*exp(-(X1-pi).^2/100 -(X2-pi).^2/100);
    end
    funcValues = funcValues(:);
    
    %Check that search direction has more than 1 point, else diff screws up.   
    if length(X1)==1 && length(X2)==1
        New = [X1 X2 funcValues];
    else
        
        switch Axis
            case 1
                Points = [X1,X2*ones(size(X1))];
            case 2
                Points = [X1*ones(size(X2)),X2];
            case {3,4}
                Points = [X1,X2];
        end
        Changes = diff(funcValues);
        Index = [];
        Current = 1;
        %Check to see what initial slope is, where we are, yo.
        switch Changes(1)>0
            case 0 %first value is less then 0
                Index(1,1) = 1;
                Sign = 1;
            case 1 %1st value is >0
                Sign = 2;
        end
        %Find all the unimodal sections containing local mins
        for index = 2:length(Changes)
           switch Sign
               case 1
                   if Changes(index) > 0
                       Index(Current,3) = index-2; %#ok<*AGROW>
                       Sign = 3;
                   end
               case 2
                   if Changes(index) < 0
                       Index(Current,1) = index;
                       Sign = 1;
                   end
               case 3
                   if Changes(index) < 0
                      Index(Current,2) = index-2;
                      Sign = 2;
                      Current = Current+1;
                   end
            end
        end
        if Index(end,2)==0
            Index(end,:) = [];
        end
        if prod(Index(1,:))==0
            Index(1,:) = [];
        end
%         Index,pause
        FoundMins = [Points(Index(:,3),:),funcValues(Index(:,3))];
        FoundMins = FoundMins(FoundMins(:,3) == min(FoundMins(:,3)),:);
        New = FoundMins(ceil(rand)*size(FoundMins,1),:);

    end
    
    
%Search for minimum using steepest descent once you get something close
%to global min.
function [New,Grad] = LocalOptSearch(Start,func01,delfunc01,delfunc02,delFunc11,delFunc22,delFunc12) %#ok<*INUSD>
    Grad = 0;
    x = Start;
    tol = 1e-3;
    Error = (delfunc01(x)^2+delfunc02(x)^2)^.5;
        
    %This is a modified Steepest Descent method...
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
            fprintf('Function stopped because alpha reduced below allowed value and no improvement found.\n')
        end
        Error = (delfunc01(x)^2+delfunc02(x)^2)^.5;
    end
    New = [x func01(x) (delfunc01(x)^2+delfunc02(x)^2)^.5];
        

%%-----------------------------------------------------------------------%%
% %Portion of Function 1 near the minimum point.     
% kk = -10:.1:10;
% [X1,X2] = meshgrid(kk);
% funcValues = (sin(2*X1+1)+2*sin(3*X1+2)+3*sin(4*X1+3)+4*sin(5*X1+4)+5*sin(6*X1+5)).*...
%                              (sin(2*X2+1)+2*sin(3*X2+2)+3*sin(4*X2+3)+4*sin(5*X2+4)+5*sin(6*X2+5)) +...
%                              (X1+1.42513).^2 + (X2+0.80032).^2;
% mesh(X1,X2,funcValues)

% %Function 2   
% kk = -10:.1:10;
% [X1,X2] = meshgrid(kk);
% funcValues = (sin(2*X1+1)+2*sin(3*X1+2)+3*sin(4*X1+3)+4*sin(5*X1+4)+5*sin(6*X1+5)).*...
%                              (sin(2*X2+1)+2*sin(3*X2+2)+3*sin(4*X2+3)+4*sin(5*X2+4)+5*sin(6*X2+5));
% mesh(X1,X2,funcValues)

% %Portion of Function 3 around origin.
%  kk = -100:.5:100;
% [X1,X2] = meshgrid(kk);
% funcValues = -cos(X1).*cos(X2).*exp(-(X1-pi).^2/100 -(X2-pi).^2/100);
% set(gcf,'Renderer','zbuffer')
% mesh(X1,X2,funcValues)
%%-----------------------------------------------------------------------%%