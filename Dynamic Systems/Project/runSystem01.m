function [OptParams Cost] = runSystem01(Temps,Times,Type,Index,Input)

% UpdateThresh
% NumSec
% TempThresh
% Type
% options = optimset('Algorithm','interior-point');
Params00 = [Input.UpdateThresh;Input.NumSec;Input.PeakTime];
input = Input.input;
NumRooms = length(input.A);
LeadTime = 30;
input.NumRooms = NumRooms;
input.LeadTime = LeadTime;
input.TrailTime = 0;

%Run optimizer on runS01 to find optimal set of parameters for all days in
%set; i.e., get "globally" best parameter set.  Cost here depends on what's
%set in the runS01 function.
% options=optimset('Algorithm','interior-point','MaxIter',500);
% tic;
% [OptParams,Cost,~] =...
%     fmincon(@(Params)runS01(Params,Type,...
%               Temps,Times,Index,input),...
%               Params00,[],[],[],[],[3;1;300],[25,5,531],[],options);
% fprintf('Time for runSys01 fmincon is %g', toc);
J = runS01(Params00,Type,Temps,Times,Index,input);
end

%This function feeds the main function each day's data, finds optimal
%solution for that day, and spits out cost as some function of the
%individual cost of all days observed.  
function J = runS01(Params,Type,Temps,Times,Index,input)
    UpdateThresh = Params(1)
    NumSec = round(Params(2))
%     TempThresh = Params(3);
    PeakTime = Params(3)
    J = 0;
    for DayNum = 11:length(Index)-1
        %Assign current day info to the input for System01
        input.Temps = Temps(Index(DayNum):Index(DayNum+1)-1);
        CurrTimes = Times(Index(DayNum):Index(DayNum+1)-1,4:5);
        CurrTimes = 60*CurrTimes(:,1)+CurrTimes(:,2);
        input.Times = CurrTimes - CurrTimes(1);
        input.T = input.Times(end);
        %Find best cost for these parameters and current day.
%         temp = System01(UpdateThresh,NumSec,TempThresh,PeakTime,Type,input)
        J = J + System01(UpdateThresh,NumSec,0,PeakTime,Type,input)
        global uSolCon AllCT
        temp = {uSolCon, AllCT};
        Name = ['DayRuns/Day' num2str(DayNum) '_Sec' num2str(NumSec)...
                '_Peak' num2str(PeakTime) '.mat'];
        save(Name, 'temp')
        clear global

    end
    %At this point, just output avg cost.  May want to do minimize the max,
    %or something else later.
    J = J / length(Index);
end