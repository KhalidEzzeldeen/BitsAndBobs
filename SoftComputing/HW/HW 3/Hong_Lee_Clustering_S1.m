function [MemberMat, FuzzyMemFunc, Training] = Hong_Lee_Clustering_S1(Training, alpha, C)

%sort input training values by output values
[B, IX] = sort(Training(:,end));
ManyTrain = length(B);
Training = Training(IX,:);
%find differences between adjacent, sorted training values
Diff = diff(Training(:,end));
%find STD of differences
DiffSTD = std(Diff);
%find similarity between adjacent values
S = Diff <= C*DiffSTD*ones(size(Diff));
S = (1-(Diff/(C*DiffSTD))).*S;
%create membership matrix == [fuzzy member value, fuzzy group asigned to]
MemberMat = zeros(ManyTrain,2);
MemberMat(1,2) = 1;
%find initial groups each training value placed in
for ii=2:ManyTrain
    if S(ii-1)<alpha
        MemberMat(ii,2)=max(MemberMat(:,2))+1;
    else
        MemberMat(ii,2)=MemberMat(ii-1,2);
    end
end
FuzzyGroupNum = max(MemberMat(:,2));
FuzzyMemFunc = zeros(FuzzyGroupNum,3);
for ii = 1:FuzzyGroupNum
    iiMembers = find(MemberMat(:,2)==ii);
    tempYs = Training(iiMembers, end);
    tempSs = S(iiMembers(1:end-1));
    if isempty(tempSs)
        tempSs=[1,1];
    else
        tempSs = [tempSs(1), tempSs(1:end)', tempSs(end)]';
    end
    %find central vertex of triangle membership func
    b_j_n = 0; b_j_d = 0;
    for jj = 1:length(iiMembers)
        sweight = (tempSs(jj)+tempSs(jj+1))/2;
        b_j_n = b_j_n + tempYs(jj)*sweight;
        b_j_d = b_j_d + sweight;
    end
    %set b
    FuzzyMemFunc(ii,2) = b_j_n / b_j_d;
    mintempSs = min(tempSs);
    MemberMat(iiMembers(1),1) = mintempSs;
    MemberMat(iiMembers(end),1) = mintempSs;
    %set a
    FuzzyMemFunc(ii,1) = FuzzyMemFunc(ii,2) -...
        (FuzzyMemFunc(ii,2) - tempYs(1))/(1-mintempSs);
    %set c
    FuzzyMemFunc(ii,3) = FuzzyMemFunc(ii,2) +...
        (tempYs(end) - FuzzyMemFunc(ii,2))/(1-mintempSs);
end
MemberMat(MemberMat(:,1)==0,1)=1;
    
    