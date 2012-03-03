function output = Tabu(input)

A = input.A;
N = length(A);
%Number of iterations a move is banned
k = round(N*input.k)+1;
%Determines size of initial solution
Alpha = input.Alpha;
%Determines number of neighbors to look at
Beta = input.Beta;
Gamma = input.Gamma;
% %Number of iterations to run loop
% ite=input.ite;


%Initilize Solution
BestSolVec = find(rand(N,1)>Alpha)';
NotSol = setdiff(1:N,BestSolVec);
BestH = sum(sum(A(BestSolVec,NotSol)));
CurSolVec = BestSolVec;
CurH = BestH;
TabuList = [];


%Run until stop
Count=0;
while Count<N
% for ii = 1:ite
    %Remove expired Tabued elements from TabuList
    if ~isempty(TabuList)
        TabuList(:,TabuList(2,:)==0)=[];
    end
    %Find Beta*N neighbors
    tempIndex = randperm(N);
    tempIndex = tempIndex(1:ceil(N*(1-max(Beta-length(TabuList)/N,Gamma))));
    %Calculate dH for each move
    dH = zeros(length(tempIndex),1);
    Loc = zeros(length(tempIndex),1);
    for jj = 1:length(tempIndex)
        tempz=tempIndex(jj);
        if isempty(find(CurSolVec==tempz,1))
            Loc(jj) = 0;
            dH(jj) = sum(A(tempz,setdiff(1:N,CurSolVec))) - sum(A(tempz,CurSolVec));
        else
            Loc(jj) = 1;
            dH(jj) =  sum(A(tempz,CurSolVec)) - sum(A(tempz,setdiff(1:N,CurSolVec)));
        end
    end
    %Update with best, remove Tabued, etc
    z = tempIndex(dH==max(dH));
    if isempty(TabuList) || ~ismember(z,TabuList(1,:))
        %Best tried neighbor not Tabued, do update
        CurH = CurH + dH(tempIndex==z);
        if Loc(tempIndex==z) == 0
            CurSolVec = [CurSolVec z];
        else
            CurSolVec((CurSolVec==z))=[];
        end
        TabuList = [TabuList, [z;k]];
    else
        %Aspiration criteria move; check to see if Tabued move creates Best
        %Ever Solution.  If so, do move.  else, remove all Tabued, find
        %remaining dH Max.
        if CurH + dH > BestH
            CurH = CurH + dH(tempIndex==z);
            if Loc(tempIndex==z) == 0
                CurSolVec = [CurSolVec z];
            else
                CurSolVec((CurSolVec==z))=[];
            end
            TabuList(TabuList(1,:)==z,2)=k;
        else
            %Remove all Tabued from tempIndex, find remaining Max dH
            temp = find(ismember(tempIndex,TabuList(1,:)));
            tempIndex(temp)=[];
            dH(temp)=[];
            Loc(temp)=[];
            %Find new Max dH, update CurH, CurSolVec, and TabuList
            %Check to see if tempIndex has elements left; if not, make a
            %new one with all elements not in TabuList.
            if ~isempty(tempIndex)
                z = tempIndex(dH==max(dH));
            else
                tempIndex = setdiff(1:N,TabuList(1,:));
                if ~isempty(tempIndex)
                    z = tempIndex(1);
                    if isempty(find(CurSolVec==z,1))
                        Loc = 0;
                        dH = sum(A(z,setdiff(1:N,CurSolVec))) - sum(A(z,CurSolVec));
                    else
                        Loc = 1;
                        dH =  sum(A(z,CurSolVec)) - sum(A(z,setdiff(1:N,CurSolVec)));
                    end
                end
            end
            %Update Current Solution
            CurH = CurH + dH(tempIndex==z);
            if Loc(tempIndex==z) == 0
                CurSolVec = [CurSolVec z];
            else
                CurSolVec((CurSolVec==z))=[];
            end
            TabuList = [TabuList, [z;k]];
         
        end
        
    end
    %Update Best Found Sol if necessary and update Count
    if CurH > BestH
        BestSolVec = CurSolVec;
        BestH = CurH;
        Count=0;
    else
        Count=Count+1;
    end
    if ~isempty(TabuList)
        TabuList(2,:) = TabuList(2,:)-1;
    end
    
end

%Form Output
output.SolVec = sort(BestSolVec);
output.MaxCut = BestH;