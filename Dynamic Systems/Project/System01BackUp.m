function TotCost = System01(UpdateThresh,NumSec,TempThresh,PeakTime,Type,input)
    %Optimization parameters from outer optimizer:  UpdateThresh, NumSec,
    %TempThresh(,Type)
    %UpdateThresh = largest error allowed before updating the control
    %NumSec = number of different control sections 
    %TempThresh = allowed dev. in temp from desired final temp during day
    %Type = type of control (const piecewise or cont spline, 0 or 1)
    
    %Let these be global so you don't need to keep feeeding them into
    %functions and they can be more easily updated.
    global CurrTemps CurrTimes A uGoal Params S R  NumRooms T AllCT Extra
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
    [InitialCT,Constraints] = GuessInitialControl(NumSec,Type,NumRooms);
    [CNew,~,~] = fmincon(@(C)ControlCostCalc(C,LeadTime,uStart,NumSec,PeakTime,Type),...
                                InitialCT, Constraints.A,Constraints.b,...
                                [],[],Constraints.lb,Constraints.ub,[],[]);
    %Start simulation of day, given initial control.
    [~,uSolAct] = ode45(@(t,u)SysChangeAct(t,u,UpdateThresh,NumSec,PeakTime,Type,CNew),...
                    [Times(1+LeadTime),Times(end-TTime)],uStart);
    %Calculate total cost incurred from found otp. solution
    [~,JTmp] = ode45(@(t,j)CostCalc(t,j,uSolAct,NumSec,PeakTime,Type,1),...
                    [Times(1+LeadTime),Times(end-TTime)],[0,uStart(:)']);
    %Get total cost w/ update expenditures added
    TotCost = 0.5*JTmp(end) + 0.5*(uSolAct(end)-uGoal)'*S*(uSolAct(end)-uGoal);% +...
%               CostPerUpdate*NumUpdates + CostPerReading*NumReadings;

end

function du = SysChangeAct(t,u,UpdateThresh,NumSec,PeakTime,Type,InitialCT) %#ok<INUSD>
    %fmincon acts on SysChangeCont in here, optimizes...
    %Define how actual system changes
    %Define error term denoting difference between actualy system and the
    %system that the control predicts.
    %Update control as needed.
    %Calculate costs.
    %u = [u1, u2,..., uN];
    %C = [c11, c21,..., cN1, uC1, CMag1,...,u1Sec,u2Sec,...,cNSec,uCSec,CMagSec];
    %Note:  sum(c_i) <= 1. Opt. should force to equality.
    global CurrTemps CurrTimes A Params NumRooms uSolCon TFunc AllCT CNow
    
    %Here is where the control for the given system is calculated, when
    %needed.
    %Get the current temperature by lin extrapolation
    Ind = find(CurrTimes >= t-1 && CurrTimes <= t+1);
    if length(Ind)<2
       CurrTemp = CurrTemps(Ind);
    else
       CurrTemp = (CurrTemps(Ind(2))-CurrTemps(Ind(1)))*(t-CurrTimes(Ind(1)));
    end
    %Update error term, check, update control if needed.
    if isempty(uSolCon) || isempty(u)
        error = 0;
    else
        error = ([u(:);CurrTemp]-[deval(uSolCon,t);TFunc(t)])'*...
                ([u(:);CurrTemp]-[deval(uSolCon,t);TFunc(t)])/(length(A)+1);
    end
    %May be useful to campartmentalize for now; allows us to set initial
    %guesses for optimal control easier, perhaps.
    if isempty(AllCT) 
        CNow=InitalCT;
        AllCT(:,1) = [t;CNow(:)];
    end
    if error > UpdateThresh
        %Optimize the given control structure, find cost, and get any problems
        [CNew,~,exitflag] = fmincon(@(C)ControlCostCalc(C,t,u,NumSec,PeakTime,Type),...
                                    CNow, Constraints);
        if exitflag~=1              %Figure out WTF is wrong, fix.
            return
        else                        %fmincon gave no errors
            CNow=CNew;
            if t <= AllCT(1,end)
                AllCT(:,end) = [t;CNow(:)];
            else
                AllCT(:,end+1) = [t;CNow(:)];
            end
        end
        AllCT
    end
    
    %Down here is where du is actually calculated...
    du = zeros(NumRooms,1);
    kIn = Params.kIn;
    kEx = Params.kEx;
    CNow = AllCT(2:end,end);
    %Calc effect of control on system
    CFunc = ControlEffect(u,t,CurrTemp,Type);
    %Construct du based on system assumptions.
    for R = 1:NumRooms
       du(R) = sum(kIn.*A(:,R).*(u-u(R))) +...      %Internal heat flow
               kEx(R)*(CurrTemp-u(R)) +...          %External heat flow
               CFunc(R);                            %Effect of control
    end
end

% This function is for calculating the total cost given the control
% selected and the state evo. predicted by the control.
function J = ControlCostCalc(tCur,uCur,NumSec,PeakTime,Type)
    global uGoal S uSolCon T
    %Determine what trajectory looks like from tCur to T.
    %Simulate system in controller world for tCur to T.
    [~,uSolCon] = ode45(@(t,u)SysChangeCont(t,u,NumSec,PeakTime,Type),...
                        [tCur,T],uCur);
    %Need to calc cost to go for using control the above control.
    [~,JTmp] = ode45(@(t,j)CostCalc(t,j,uSolCon,NumSec,PeakTime,Type,0),...
                     [tCur,T],[0,uCur(:)']);
    %Get total cost
    J = 0.5*JTmp(end,1) + 0.5*(uSolCon(end)-uGoal)'*S*(uSolCon(end)-uGoal);
end

% This function is for calculating the predicted state evo. by the control.
function du = SysChangeCont(t,uNow,NumSec,PeakTime,Type)
    global A TFunc
    %Calculate a new guess for the temperature function.
    TFunc = TempFunc(t,PeakTime);
    CFunc = ControlEffect(t,uNow,TFunc(t),NumSec,PeakTime,Type);
%     kEx = Need to set these values different from the actual system, eh?
%     kIn = 
    du = zeros(N,1);
    for R = 1:N
       du(R) = sum(kIn.*A(:,R).*(u-u(R))) +...      %Internal heat flow
               kEx(R)*(TFunc(t)-u(R)) +...          %External heat flow
               CFunc(R);                            %Effect of control
    end
end

% This function is for predicting the temperatures throughout the day.
function TGuess = TempFunc(tNow,PeakTime)
    global CurrTemps
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
       m = (uMax-CurrTemps(1))/tMax;
       %Defines final slope based on initial temp and max temp experienced
       TGuess = @(t)TFunc(tMax,uMax,m,t);
    end
end
    

% This function is for calculating the effect of the control on the room
% temperatures.
function CFunc = ControlEffect(t,uNow,SimCurrTemp,NumSec,Type)
    %t is the current time of the ode solver
    %uNow is the current temperature state of the system
    %Function describing how control influences temp of rooms given u and C.
    %Need to get est. params. on how control changes internal temps.
    %CNow = [c11, c21,..., cN1, uC1,CMag1,...,u1Sec,u2Sec,...,cNSec,uCSec,CMagSec];
    global T AllCT
    CurrControlStrategy = find(AllCT(1,:)<=t,'last');
    tStart = AllCT(1,CurrControlStrategy);
    CNow = AllCT(2:end,CurrControlStrategy);
    del_t = (T-tstart)/NumSec;
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
            NumControls = length(CNow)/NumSec;
            C = CNow(1+(Sec-1)*NumControls:(Sec)*NumControls);
            %ideal heat pump efficiency
            eff = C(end-1)/abs(C(end-1)-SimCurrTemp);
            CFunc = eff*(C(end-1)-uNow).*C(end).*C(1:end-2);
        case 1          %Continuous spline control
            %Recall splines have one more section to the control to
            %denote the final value of the control
            NumControls = length(CNow)/(NumSec+1);
            C = CNow(1+(Sec-1)*NumControls:(Sec)*NumControls)+...
                (CNow(1+(Sec)*NumControls:(Sec+1)*NumControls) - ...
                 CNow(1+(Sec-1)*NumControls:(Sec)*NumControls))*...
                (t-tStart-del_t*(Sec-1))/((T-tStart)/NumSec);
            %Ideal heat pump efficiency
            eff = C(end-1)/abs(C(end-1)-SimCurrTemp);
            CFunc = eff*(C(end-1)-uNow).*C(end).*C(1:end-2);
    end
end

% This function is for feeding into the integrator for the cost
% calculation.
function dJ = CostCalc(t,~,uSol,NumSec,Type,Where)
    %Use for both control est. cost, and actual cost, including cost for
    %running a control update and cost for temperature sampling.
    %uSol is the temperature output from ode45
    global R TFunc CurrTemps
    %Decide whether this is being called at the end when calculating the
    %actual. total cost, or somewhere in the middle for calculating the
    %cost to go for the proposed control.
    uNow = deval(uSol,t);
    switch Where
        case 0 
            CFunc = ControlEffect(t,uNow,TFunc(t),NumSec,Type);
        case 1 
            %Get the current temperature by lin extrapolation
            Ind = find(CurrTimes >= t-1 && CurrTimes <= t+1);
            if length(Ind)<2
               CurrTemp = CurrTemps(Ind);
            else
               CurrTemp = (CurrTemps(Ind(2))-CurrTemps(Ind(1)))*...
                          (t-CurrTimes(Ind(1)));
            end
            CFunc = ControlEffect(t,uNow,CurrTemp,NumSec,Type);
    end
    dJ = CFunc(end-1:end)'*diag(R)*CFunc(end-1:end);
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
                InitialCT(1+(k-1)*(NumRooms+2):(k)*(NumRooms+2),1) = ...
                         (k>floor(2*NumSec/3))*[ones(NumRooms,1)/NumRooms;...
                          mean(uGoal);floor(2*NumSec/3)/k];
                A(k,:) = [zeros(1,(k-1)*(NumRooms+2)),...
                         ones(1,NumRooms),zeros(1,2),...
                         zeros(1,(NumSec-k-1)*(NumRooms+2))];
                lb(1+(k-1)*(NumRooms+2):(k)*(NumRooms+2),1) =...
                  [zeros(NumRooms,1);45;0];
                ub(1+(k-1)*(NumRooms+2):(k)*(NumRooms+2),1) =...
                  [ones(NumRooms,1);95;10];
            end
        case 1              %Spline, continuous control
            for k = 1:NumSec+1
                InitialCT(1+(k-1)*(NumRooms+2):(k)*(NumRooms+2),1) = ...
                         (k>floor(2*NumSec/3))*[ones(NumRooms,1)/NumRooms;...
                          mean(uGoal);1-floor(2*NumSec/3)/k];
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
    size(A)
    Constraints.A = A;
    Constraints.b = b;
    Constraints.lb = lb;
    Constraints.ub = ub;
end
