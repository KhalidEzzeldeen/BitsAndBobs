function MakePlots(Temps,Times,Type,Index,NumSec,input)

DayNum=11;
global CurrTimes CurrTemps AllCT
CurrTemps = Temps(Index(DayNum):Index(DayNum+1)-1);
CurrTimes = Times(Index(DayNum):Index(DayNum+1)-1,4:5);
CurrTimes = 60*CurrTimes(:,1)+CurrTimes(:,2);
CurrTimes = CurrTimes - CurrTimes(1);
T = CurrTimes(end);

% CurrTimes
% %Create uSolCon for new system
% options = odeset('RelTol',2e-3,'AbsTol',5e-6 );
% uSolCon = ode45(@(t,u)SysChangeCont(t,u,[],[],NumSec,Type),...
%                 [30,T],uStart,options);
            
uStart = input.uf;            
%Start simulation of day, given initial control.
%     options = odeset('MaxStep', 5);
options = odeset('RelTol',2e-3,'AbsTol',1e-5 );
uSolAct = ode45(@(t,u)SysChangeAct(t,u,NumSec,Type,T,input),...
                [30,T],uStart,options);
     
FinalTemp = deval(uSolAct,T);
figure
title('\fontsize{16}  Room Temps and External Temps During Day');
%        ['\fontsize{16} First ten controls generated, up to '...
%          ,num2str(AllCT(1,end), '%3.0f') ' min']});
xlabel('\fontsize{13} Time in Minutes from 8AM to 6PM');
ylabel('\fontsize{13} Temperature in Degrees F');
hold on
plot((31):1:T,deval(uSolAct,(31):1:T,1),'k.',...
     (31):1:T,deval(uSolAct,(31):1:T,2),'r.',...
     (31):1:T,deval(uSolAct,(31):1:T,3),'g.',...
     CurrTimes(31:end),CurrTemps(31:end),'b-');
plot(T,FinalTemp(1),'k.',...
     T,FinalTemp(2),'r.',...
     T,FinalTemp(3),'g.');
legend('\fontsize{13} Temp in RM1',...
       '\fontsize{13} Temp in RM2',...
       '\fontsize{13} Temp in RM3',...
       '\fontsize{13} Outside Temperature',...
       ['\fontsize{13} Final Temp in RM1 = ', num2str(FinalTemp(1),'%2.1f')],...
       ['\fontsize{13} Final Temp in RM2 = ', num2str(FinalTemp(2),'%2.1f')],...
       ['\fontsize{13} Final Temp in RM3 = ', num2str(FinalTemp(3),'%2.1f')],...
       'Location','Best');
hold off
     
     
end     
     
     
% This function is for calculating the predicted state evo. by the control.
function du = SysChangeAct(t,uNow,NumSec,Type,T,input)
    global CurrTemps CurrTimes
    A = input.A;
    Params = input.Params;
    NumRooms=3;
    %Here is where the control for the given system is calculated, when
    %needed.
    %Get the current temperature by lin extrapolation
    Ind = find(CurrTimes >= t-1 & CurrTimes <= t+1);
    if length(Ind)<2
       CurrTemp = CurrTemps(Ind);
    else
       CurrTemp = (CurrTemps(Ind(2))-CurrTemps(Ind(1)))*(t-CurrTimes(Ind(1)));
    end
    %Calc effect of control on system
    CFunc = ControlEffect(t,uNow,[],[],NumSec,Type,T);
    kEx = Params.kEx;
    kIn = Params.kIn;
    du = zeros(NumRooms,1);
    for R = 1:NumRooms
       du(R) = sum(kIn(:,R).*A(:,R).*(uNow-uNow(R))) +...        %Internal heat flow
               kEx(R)*(CurrTemp-uNow(R)) +...               %External heat flow
               CFunc(R);                                    %Effect of control
    end
end    
     
% This function is for calculating the effect of the control on the room
% temperatures.
function CFunc = ControlEffect(t,uNow,CNow,tCur,NumSec,Type,T)
    %t is the current time of the ode solver
    %uNow is the current temperature state of the system
    %Function describing how control influences temp of rooms given u and C.
    %Need to get est. params. on how control changes internal temps.
    %CNow = [c11, c21,..., cN1, uC1,CMag1,...,u1Sec,u2Sec,...,cNSec,uCSec,CMagSec];
    global AllCT
    NumRooms=3;
    if isempty(CNow) || t < tCur
        CurrControlStrategy = find(AllCT(1,:)<=t,1,'last');
        tStart = AllCT(1,CurrControlStrategy);
        CNow = AllCT(2:end,CurrControlStrategy);
    else
        tStart = tCur;
    end
    del_t = (T-tStart)/NumSec;
    Sec = []; count = 1;
    %Need to determine how far into the current control strategy we are
    while isempty(Sec)
        if t >= tStart+(count-1)*del_t && t <= tStart+(count)*del_t
            Sec = count;
        else
            count=count+1;
        end
    end
    %Determine current value of control given the portion of the
    %control strategy we are in the the type of control we're using.
    switch Type
        case 0          %Constant peicewise control
            NumControls = NumRooms+2;
            C = CNow(1+(Sec-1)*NumControls:(Sec)*NumControls);
            CFunc = (C(end-1)-uNow).*(C(end)*C(1:end-2))/300;
        case 1          %Continuous spline control
            %Recall splines have one more section to the control to
            %denote the final value of the control
            NumControls = NumRooms+2;
            C = CNow(1+(Sec-1)*NumControls:(Sec)*NumControls)+...
                (CNow(1+(Sec)*NumControls:(Sec+1)*NumControls) - ...
                 CNow(1+(Sec-1)*NumControls:(Sec)*NumControls))*...
                (t-tStart-del_t*(Sec-1))/((T-tStart)/NumSec);
            CFunc = (C(end-1)-uNow).*(C(end)*C(1:end-2))/300;
    end
end