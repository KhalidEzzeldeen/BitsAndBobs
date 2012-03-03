function [DecisionTable] = Hong_Lee_Clustering_S2(Training, MemberMat)

NumAttribute = size(Training,2)-1;
StoreAtt = {};
for ii = 1:NumAttribute
    [Att IX] = sort(Training(:,ii));
    DiffAtt = diff(Att);
    MinDiff = min(DiffAtt);
    AttIndx = ceil((max(Att)-min(Att))/MinDiff);
    AttVec = sparse(AttIndx,1);
    AttVec(floor((Att- min(Att))/MinDiff)+1,1) = Training(IX,ii);
    StoreAtt{ii} = {AttVec,IX,AttIndx+1};
end
DecisionTable = zeros(StoreAtt{1}{3}, StoreAtt{2}{3});
AttVec1 = StoreAtt{1}{1}; AttVec2 = StoreAtt{2}{1};
for ii = 1:size(Training,1)
    DecisionTable(AttVec1 == Training(ii,1),...
                  AttVec2 == Training(ii,2)) = MemberMat(ii,2);
end