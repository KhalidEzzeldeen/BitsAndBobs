function output = SimAnn(input)

%Parameters for various features; default as .5,1 respectively.
Alpha = input.Alpha;
Beta = input.Beta;
Delta = input.Delta;
%Parse Input and Define Variables
A = input.A;
N = length(A);
T = linspace(0,ceil(sum(sum(A))/(2*Delta)),N);


%Initilize Solution
BestSolVec = find(rand(N,1)>Alpha)';
NotSol = setdiff(1:N,BestSolVec);
BestH = sum(sum(A(BestSolVec,NotSol)));
CurSolVec = BestSolVec;
CurH = BestH;

%Run Until Stop
for t = 1:length(T)
    %Update current T
    CurrT = T(end-t+1);
    %Iterate at each T for some predetermined number of iterations
    for  k = 1:round(N*Beta)
        %Select vertex to check
        z = randi(N);
        if isempty(find(CurSolVec==z,1))
            Loc = 0;
            dH = sum(A(z,setdiff(1:N,CurSolVec))) - sum(A(z,CurSolVec));
        else
            Loc = 1;
            dH =  sum(A(z,CurSolVec)) - sum(A(z,setdiff(1:N,CurSolVec)));
        end
        %Metropolis formation of SA
        Gamma = exp(-dH/CurrT);
        %Check to see if solution is updated
        if Gamma > 1 || (Gamma < 1 && rand < Gamma)
            if Loc == 0
%                 CurSolVec,pause
                CurSolVec = [CurSolVec z];
                CurH = CurH + dH;
            else
                CurSolVec((CurSolVec==z))=[];
                CurH = CurH + dH;
            end
            %Update Best Found Sol if necessary
            if CurH > BestH
                BestSolVec = CurSolVec;
                BestH = CurH;
            end
        end
            
    end
    
end

%Form Output
output.SolVec = sort(BestSolVec);
output.MaxCut = BestH;