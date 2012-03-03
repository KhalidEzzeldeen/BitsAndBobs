function [TimeStore11to16 TempStore11to16 IndexStore] = GetTimes(TimeStore11to16,TempStore11to16)

%  TimeStore = zeros(length(TimeData)-1,5);
%  for index = 2:length(TimeData)
%     k = datevec((TimeData{index})); 
%     TimeStore(index-1,:) = k(1:5);
%  end
% 
%  %Get desired 11-5 times
%  %Top of every Hour recorded twice
%  Start = find(TimeStore(:,4)==8 & TimeStore(:,5)==00);
%  Stop = find(TimeStore(:,4)==18 & TimeStore(:,5)==00);
%  TimeStore11to16 = [];
%  TempStore11to16 = [];
%  Index=1;
%  IndexStore = 1;
%  for k = 1:length(Start)/2
%      Interval = Stop(2*k)-Start(2*k-1);
%      TimeStore11to16(Index:Index+Interval,1:5) =...
%          TimeStore(Start(2*k-1):Stop(2*k),:);
%      TempStore11to16(Index:Index+Interval,1) =...
%          TempStore(Start(2*k-1):Stop(2*k));
%      Index = Index + Interval + 1;
%      IndexStore = [IndexStore;Index];
%  end
%  IndexStore(end) = IndexStore(end)-1;

%Need to clean data, remove 'top of hour' readings
% Index = find(TimeStore11to16(:,5)==0);
% Offset = 0;
% for k = 1:length(Index)/2
%     CI = Index(2*k)-Offset;
%     TimeStore11to16(CI,:) = [];
%     TempStore11to16(CI,:) = [];
%     Offset=Offset+1;
% end
IndexStore = find(TimeStore11to16(:,5)==0 & TimeStore11to16(:,4)==8 );

% figure
% hold on
% for ii = 1:length(IndexStore)-1
% CIStart = IndexStore(ii);
% CIEnd = IndexStore(ii+1);
% plot((TimeStore11to16(CIStart:CIEnd,5)+TimeStore11to16(CIStart:CIEnd,4)*60),...
%       TempStore11to16(CIStart:CIEnd),'r*');
% end

NumDays = length(IndexStore)-1;
TempMaxTime = zeros(NumDays,3);
for k = 1:NumDays
    CIStart = IndexStore(k);
    CIEnd = IndexStore(k+1);
    [Value,MAX] = max(TempStore11to16(CIStart:CIEnd));
    TempMaxTime(k,:) = [Value,TimeStore11to16(CIStart+MAX(1),4:5)];
end

figure
title('\fontsize{16}  Selected Day Temps and Peak Temps for Jan ');
xlabel('\fontsize{13} Time in Minutes from 8AM to 6PM');
ylabel('\fontsize{13} Temperature in Degrees F');
axis([8*60 18*60 15 70])
hold on
for ii = 1:3:length(IndexStore)-1
CIStart = IndexStore(ii);
CIEnd = IndexStore(ii+1);
plot((TimeStore11to16(CIStart:CIEnd,5)+TimeStore11to16(CIStart:CIEnd,4)*60),...
      TempStore11to16(CIStart:CIEnd),'r.','MarkerSize',4);
end
plot((TempMaxTime(:,3)+TempMaxTime(:,2)*60),TempMaxTime(:,1),'b*','MarkerSize',8)
size(TempMaxTime);

% Delta = inline('4*(t>2).*((3-2)/2-abs(t-2.5)).*(t<3)', 't');


