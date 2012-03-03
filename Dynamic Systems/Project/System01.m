function TotCost = System01(UpdateThresh,NumSec,TempThresh,PeakTime,Type,input)
    %Optimization parameters from outer optimizer:  UpdateThresh, NumSec,
    %TempThresh(,Type)
    %UpdateThresh = largest error allowed before updating the control
    %NumSec = number of different control sections 
    %TempThresh = allowed dev. in temp from desired final temp during day
    %Type = type of control (const piecewise or cont spline, 0 or 1)
    
    %Let these be global so you don't need to keep feeeding them into
    %functions and they can be more easily updated.
    global CurrTemps CurrTimes A uGoal uStart Params S R NumRooms T AllCT Extra TFunc uSolCon CNow LastUpdate
    CurrTemps = input.Temps;    %ext. temp readings for +/-30min cont. period.
    CurrTimes = input.Times;    %normalized times, in mins. (i.e., start @ 0)
    A = input.A;                %adj matrix for rooms
    uGoal = input.uf;           %desired final room temps
    Params = input.Params;      %any additional params. for us in state changes.
    uStart = uGoal;             %assign desired final temps
    S = input.S;                %weightings on cost for missing final temps
    R = input.R;                %cost for using control
    NumRooms = input.NumRooms;
    LeadTime = input.LeadTime;
    TTime = input.TrailTime;
    Extra = input.Extra;        %any other various variables that need to be assigned
    T = input.T;                %final time for temp to be at targer temp.
    AllCT = [];                 %[t;C_of_t]'; matrix of all used controls, each starting at time t
    uSolCon = [];

    
%     %Set costs associated with updating control and reading conditions.
%     if ~isempty(Extra)
%         CostPerUpdate = Extra(1);
%         CostPerReading = Extra(2);
%     else
%         CostPerUpdate = 0;
%         CostPerReading = 0;
%     end
    %Run system simulator;  Start at first time + 30 min (allows to guess
    %initial TFunc from data); end at last time - 30 min (allows for
    %anything extra I want to throw in).
    %Create initial control based on the info in the lead time
    %Calculate a new guess for the temperature function.
    TFunc = TempFunc(LeadTime,PeakTime);
    [InitialCT,Constraints] = GuessInitialControl(NumSec,Type,NumRooms);
%     InitialCT = [0.7407;0.0002;0.0002;45.0197;1.6156;...
%                  0.0005;0.0006;0.0009;45.0014;0.0006;...
%                  0.2984;0.4719;0.2294;45.0003;0.0002;...
%                  0.1177;0.2848;0.5975;77.7744;9.9994];
    InitialCT = [0.0000;0.0000;0;60.0000;0;...
                 1/3;1/3;1/3;68.0000;0;...
                 0.0284;0.3546;0.6170;90;10.0000];
%     Constraints.A     
%     Constraints.b 
%     Constraints.lb 
%     Constraints.ub
    options=optimset('Algorithm','interior-point','MaxIter', 500,'TolFun',1e-5,'TolCon',1e-3,'TolX',1e-8);
%     InitialCT'
    tic;
%     @(C)mycon(C,NumSec)
    [CNew,~,~] = fmincon(@(C)ControlCostCalc(C,LeadTime,uStart,NumSec,Type),...
                                InitialCT, Constraints.A,Constraints.b,...
                                [],[],Constraints.lb,Constraints.ub,@(C)mycon(C,NumSec),options);
    fprintf('Time for first soln in System01 fmincon is %g', toc);
    AllCT(:,1) = [30;CNew]
    LastUpdate = 30;
    CNow = CNew;
%     figure
%     plot(0:1:T,TFunc(0:1:T),'r*',...
%          (LeadTime+1):1:T,deval(uSolCon,(LeadTime+1):1:T,2),'k.',...
%          CurrTimes,CurrTemps,'b-');

    %Start simulation of day, given initial control.
%     options = odeset('MaxStep', 5);
    options = odeset('RelTol',1e-3,'AbsTol',1e-6 );
    uSolAct = ode45(@(t,u)SysChangeAct(t,u,UpdateThresh,NumSec,PeakTime,Type,Constraints),...
                    [CurrTimes(1+LeadTime),...
                     CurrTimes(1+LeadTime)+25:25:CurrTimes(end-TTime)-25,...
                     CurrTimes(end-TTime)],uStart,options);
    %Calculate total cost incurred from found otp. solution
    [~,JTmp] = ode45(@(t,j)CostCalc(t,j,[],[],NumSec,Type,1),...
                    [CurrTimes(1+LeadTime),...
                     CurrTimes(1+LeadTime)+25:25:CurrTimes(end-TTime)-25,...
                     CurrTimes(end-TTime)],0);
    %Get total cost w/ update expenditures added
    TotCost = 0.5*JTmp(end) + 0.5*(deval(uSolAct,T)-uGoal)'*S*(deval(uSolAct,T)-uGoal);
    % +...
%               CostPerUpdate*NumUpdates + CostPerReading*NumReadings;

end

function du = SysChangeAct(t,u,UpdateThresh,NumSec,PeakTime,Type,Constraints)
    %fmincon acts on SysChangeCont in here, optimizes...
    %Define how actual system changes
    %Define error term denoting difference between actualy system and the
    %system that the control predicts.
    %Update control as needed.
    %Calculate costs.
    %u = [u1, u2,..., uN];
    %C = [c11, c21,..., cN1, uC1, CMag1,...,u1Sec,u2Sec,...,cNSec,uCSec,CMagSec];
    %Note:  sum(c_i) <= 1. Opt. should force to equality.
    global CurrTemps CurrTimes A Params NumRooms uSolCon TFunc AllCT CNow T LastUpdate uStart
    
    %Here is where the control for the given system is calculated, when
    %needed.
    %Get the current temperature by lin extrapolation
    Ind = find(CurrTimes(:) >= t-1 & CurrTimes(:) <= t+1);
    if length(Ind)<2
       CurrTemp = CurrTemps(Ind);
    else
       CurrTemp = (CurrTemps(Ind(2))-CurrTemps(Ind(1)))*(t-CurrTimes(Ind(1)));
    end
    %Update error term, check, update control if needed.
    t
    error = ([u(:);CurrTemp/10]-[deval(uSolCon,t);TFunc(t)/10])'*...
            ([u(:);CurrTemp/10]-[deval(uSolCon,t);TFunc(t)/10])/(length(A)+0.1);
    %May be useful to campartmentalize for now; allows us to set initial
    %guesses for optimal control easier, perhaps.
    
    if error > UpdateThresh && t-LastUpdate >= 15
        %Set update time for later reference
        LastUpdate = t;
        %Calculate a new guess for the temperature function.
        TFunc = TempFunc(t,PeakTime);
        %Optimize the given control structure, find cost, and get any problems
        options=optimset('Algorithm','interior-point','MaxIter',500,'TolFun',1e-5,'TolCon',1e-3,'TolX',1e-8);
        exitflag = 0;
        while exitflag ~= 1
            tic;
%             @(C)mycon(C,NumSec)
            fprintf('Start fmincon for correction.  Current time is %g',t);
            [CNew,~,exitflag] = fmincon(@(C)ControlCostCalc(C,t,u,NumSec,Type),...
                            CNow,Constraints.A,Constraints.b,...
                            [],[],Constraints.lb,Constraints.ub,@(C)mycon(C,NumSec),options);
            fprintf('Time for correction run in System01 fmincon is %g \n', toc);
            if exitflag == 0
                fprintf('Exit flag for correction fmincon was 0.  Rerun with output as starting conditions. \n');
                CNow = CNew;
            elseif exitflag == 2 || abs(exitflag) == 3 || exitflag == 4 ||exitflag == 5
                fprintf('Exit flag for corrections fmincon was %i.  Accept soln.',exitflag);
                exitflag = 1;
            elseif exitflag == -2
                fprintf('Exit flag for corrections fmincon was -2. \nModifying output, accepting.\n');
                exitflag = 1;
                for Sec = 1:NumSec
                    CNew(1+(Sec-1)*(NumRooms+2):Sec*(NumRooms+2)-2) = ...
                    CNew(1+(Sec-1)*(NumRooms+2):Sec*(NumRooms+2)-2)/...
                    sum(CNew(1+(Sec-1)*(NumRooms+2):Sec*(NumRooms+2)-2));
                end
%                 CNow = GuessInitialControl(NumSec,Type,NumRooms);
            elseif exitflag ~=1
                exitflag
                return
            end
        end
        %optimizer came to complete stop; disembark.                       
        CNow=CNew;
        if t <= AllCT(1,end)
            AllCT(:,end) = [t;CNow(:)];
        else
            AllCT(:,end+1) = [t;CNow(:)];
        end
        %Create uSolCon for new system
        options = odeset('RelTol',1e-3,'AbsTol',1e-6 );
        uSolCon = ode45(@(t,u)SysChangeCont(t,u,[],[],NumSec,Type),...
                        [30,T],uStart,options);
        
        AllCT
        %figure
        %plot(30:1:T,TFunc((floor(t)+1):1:T),'r*',...
        %     30:1:floor(t),deval(uSolCon,30:1:floor(t),2),'k-',...
        %     (1+floor(t)):1:T,deval(uSolCon,(1+floor(t)):1:T,2),'k.',...
        %     30:1:floor(t),CurrTemps(31:1:floor(t)+1),'b-',...
        %     (1+floor(t)):1:T,CurrTemps((2+floor(t)):1:T+1),'b.');
    end
    
    %Down here is where du is actually calculated...
    du = zeros(NumRooms,1);
    kIn = Params.kIn;
    kEx = Params.kEx;
    CNow = AllCT(2:end,end);
    %Calc effect of control on system
    CFunc = ControlEffect(t,u,[],[],NumSec,Type);
    %Construct du based on system assumptions.
    for R = 1:NumRooms
       du(R) = sum(kIn(:,R).*A(:,R).*(u-u(R))) +...      %Internal heat flow
               kEx(R)*(CurrTemp-u(R)) +...          %External heat flow
               CFunc(R);                            %Effect of control
    end
end

% This function is for calculating the total cost given the control
% selected and the state evo. predicted by the control.
function J = ControlCostCalc(CNow,tCur,uCur,NumSec,Type)
    global uGoal S T uSolCon
%     CNow',pause
    %Determine what trajectory looks like from tCur to T.
    %Simulate system in controller world for tCur to T.
%     options = odeset('MaxStep', 5);
%     if tCur == T
%         tCur = tCur - 1000*eps;
%     end
    tCur = tCur-5;
    options = odeset('RelTol',2e-3,'AbsTol',5e-6 );
    uSolCon = ode45(@(t,u)SysChangeCont(t,u,CNow,tCur,NumSec,Type),...
                        [tCur,T],uCur,options);
    
    %Need to calc cost to go for using control the above control.
    [~,JTmp] = ode45(@(t,j)CostCalc(t,j,CNow,tCur,NumSec,Type,0),...
                     [tCur,T],0,options);
    
    %Get total cost
    J = 0.5*JTmp(end,1) + 0.5*(deval(uSolCon,T)-uGoal)'*S*(deval(uSolCon,T)-uGoal);
%     [uSolCon(end,:),uGoal']
end

% This function is for calculating the predicted state evo. by the control.
function du = SysChangeCont(t,uNow,CNow,tCur,NumSec,Type)
    global A TFunc NumRooms Params
    CFunc = ControlEffect(t,uNow,CNow,tCur,NumSec,Type);
    kEx = Params.kEx;
    kIn = Params.kIn;
    du = zeros(NumRooms,1);
    for R = 1:NumRooms
       du(R) = sum(kIn(:,R).*A(:,R).*(uNow-uNow(R))) +...        %Internal heat flow
               kEx(R)*(TFunc(t)-uNow(R)) +...               %External heat flow
               CFunc(R);                                    %Effect of control
    end
end

% This function is for predicting the temperatures throughout the day.
function TGuess = TempFunc(tNow,PeakTime)
    global CurrTemps
%     size(CurrTemps),pause
    %t is the current time of the ode solver
    %TempHist is the actual temperatures up to time t
    %Thresh is the expected time for temp peaking (do in ref to T1==0)
    TFunc = inline('uMax - slope*abs(tMax-t)','tMax','uMax','slope','t');
    if tNow < PeakTime
       m = mean(diff(CurrTemps(1:floor(tNow))));
       uMax = CurrTemps(floor(tNow))+m*(PeakTime-tNow);
       tMax = PeakTime;
       %Have access to temps before tNow, so only need to predict future
       %ones.  Uses previously recorded temps to predict temp slopes.
       TGuess = @(t)TFunc(tMax,uMax,m,t);
    else
       [uMax,tMax] = max(CurrTemps(1:floor(tNow)));
       if tMax < 4*60
           m1 = mean(diff(CurrTemps(1:floor(tMax))));
           m2 = mean(diff(CurrTemps(ceil(tMax):floor(tNow))));
           m = (abs(m1)*(floor(tMax))+abs(m2)*(tNow-ceil(tMax))) / tNow;
       else
           m = (uMax-CurrTemps(1))/tMax;
       end
       %Defines final slope based on initial temp and max temp experienced
       TGuess = @(t)TFunc(tMax,uMax,m,t);
    end
end
    
% This function is for calculating the effect of the control on the room
% temperatures.
function CFunc = ControlEffect(t,uNow,CNow,tCur,NumSec,Type)
    %t is the current time of the ode solver
    %uNow is the current temperature state of the system
    %Function describing how control influences temp of rooms given u and C.
    %Need to get est. params. on how control changes internal temps.
    %CNow = [c11, c21,..., cN1, uC1,CMag1,...,u1Sec,u2Sec,...,cNSec,uCSec,CMagSec];
    global T AllCT NumRooms
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
            CFunc = (C(NumRooms+1)-uNow).*(C(NumRooms+2)*C(1:NumRooms))/300;
        case 1          %Continuous spline control
            %Recall splines have one more section to the control to
            %denote the final value of the control
            NumControls = NumRooms+2;
            C = CNow(1+(Sec-1)*NumControls:(Sec)*NumControls)+...
                (CNow(1+(Sec)*NumControls:(Sec+1)*NumControls) - ...
                 CNow(1+(Sec-1)*NumControls:(Sec)*NumControls))*...
                (t-tStart-del_t*(Sec-1))/((T-tStart)/NumSec);
            CFunc = (C(NumRooms+1)-uNow).*(C(NumRooms+2)*C(1:NumRooms))/300;
    end
end

% This function is for feeding into the integrator for the cost
% calculation.
function dJ = CostCalc(t,~,CNow,tCur,NumSec,Type,Where)
    %Use for both control est. cost, and actual cost, including cost for
    %running a control update and cost for temperature sampling.
    %uSol is the temperature output from ode45
    global R TFunc CurrTemps CurrTimes AllCT T
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
    
    %Decide whether this is being called at the end when calculating the
    %actual. total cost, or somewhere in the middle for calculating the
    %cost to go for the proposed control.
    switch Where
        case 0 
            CurrTemp = TFunc(t);
        case 1 
            %Get the current temperature by lin extrapolation
            Ind = find(CurrTimes >= t-1 & CurrTimes <= t+1);
            if length(Ind)<2
               CurrTemp = CurrTemps(Ind);
            else
               CurrTemp = (CurrTemps(Ind(2))-CurrTemps(Ind(1)))*...
                          (t-CurrTimes(Ind(1)));
            end
    end
    %Determine current value of control given the portion of the
    %control strategy we are in the the type of control we're using.
    switch Type
        case 0          %Constant peicewise control
            NumControls = length(CNow)/NumSec;
            C = CNow(1+(Sec-1)*NumControls:(Sec)*NumControls);
        case 1          %Continuous spline control
            %Recall splines have one more section to the control to
            %denote the final value of the control
            NumControls = length(CNow)/(NumSec+1);
            C = CNow(1+(Sec-1)*NumControls:(Sec)*NumControls)+...
                (CNow(1+(Sec)*NumControls:(Sec+1)*NumControls) - ...
                 CNow(1+(Sec-1)*NumControls:(Sec)*NumControls))*...
                (t-tStart-del_t*(Sec-1))/((T-tStart)/NumSec);
    end
%     eff = C(end-1)/abs(C(end-1)-CurrTemp+eps*1000);
%     size(diag([eff,1])),size(C),size(diag(R)),pause
    dJ = abs(C(end-1)-CurrTemp)*C(end)*R(1)/300;
end

% This function determine the initial guess for the control for the innter
% optimization.  Initial guess is off for the first (rounded down) 2/3's of
% the control time, followed by full on for the last third (or gradual
% decrease for spline).
function [InitialCT Constraints] = GuessInitialControl(NumSec,Type,NumRooms)
    global uGoal
    InitialCT = zeros((NumRooms+2)*(NumSec+Type),1);
    A = zeros((NumSec+Type),(NumRooms+2)*(NumSec+Type));
    b = ones((NumSec+Type),1);
    lb = InitialCT;
    ub = InitialCT;
    switch Type
        case 0              %Constant peicewise control
            for k = 1:NumSec
                InitialCT(1+(k-1)*(NumRooms+2):(k)*(NumRooms+2)-2,1) = ...
                         (k>floor(2*NumSec/3))*ones(NumRooms,1)/NumRooms;
                InitialCT(k*(NumRooms+2)-1:(k)*(NumRooms+2),1) = ...
                          [mean(uGoal);(k>floor(2*NumSec/3))*(floor(2*NumSec/3)/k)];
                lb(1+(k-1)*(NumRooms+2):(k)*(NumRooms+2),1) =...
                  [zeros(NumRooms,1);45;0];
                ub(1+(k-1)*(NumRooms+2):(k)*(NumRooms+2),1) =...
                  [ones(NumRooms,1);95;10];
            end
            A(1,:) = [ones(1,NumRooms),zeros(1,2),...
                         zeros(1,(NumSec-1)*(NumRooms+2))];
            for k = 2:NumSec-1
                A(k,:) = [zeros(1,(k-1)*(NumRooms+2)),...
                         ones(1,NumRooms),zeros(1,2),...
                         zeros(1,(NumSec-k)*(NumRooms+2))];
            end
            A(NumSec,:) = [zeros(1,(NumSec-1)*(NumRooms+2)),...
                             ones(1,NumRooms),zeros(1,2)];
%                          A,pause
        case 1              %Spline, continuous control
            for k = 1:NumSec+1
                InitialCT(1+(k-1)*(NumRooms+2):(k)*(NumRooms+2)-2,1) = ...
                         (k>floor(2*NumSec/3))*ones(NumRooms,1)/NumRooms;
                InitialCT((k*(NumRooms+2)-1):(k)*(NumRooms+2),1) = ...
                         [mean(uGoal);(k>floor(2*NumSec/3))*(1-floor(2*NumSec/3)/k)];
                lb(1+(k-1)*(NumRooms+2):(k)*(NumRooms+2),1) =...
                  [zeros(NumRooms,1);45;0];
                ub(1+(k-1)*(NumRooms+2):(k)*(NumRooms+2),1) =...
                  [ones(NumRooms,1);95;10];
            end
            A(1,:) = [ones(1,NumRooms),zeros(1,2),...
                         zeros(1,(NumSec)*(NumRooms+2))];
            for k = 2:NumSec
                A(k,:) = [zeros(1,(k-1)*(NumRooms+2)),...
                         ones(1,NumRooms),zeros(1,2),...
                         zeros(1,(NumSec+1-k)*(NumRooms+2))];
            end
            A(NumSec+1,:) = [zeros(1,(NumSec)*(NumRooms+2)),...
                             ones(1,NumRooms),zeros(1,2)];
    end
%     size(A)
    Constraints.A = A;
    Constraints.b = b;
    Constraints.lb = lb;
    Constraints.ub = ub;
end

function [c,ceq] = mycon(CNow,NumSec)
global NumRooms
c = 0;                  % Compute nonlinear inequalities at x.
ceq = zeros(3,1);       % Compute nonlinear equalities at x.
    for k = 1:NumSec
        ceq(k) = (CNow((NumRooms+2)*k)==0)*...
                 (sum(CNow(1+(k-1)*(NumRooms+2):(k)*(NumRooms+2)-2)));
    end
end
