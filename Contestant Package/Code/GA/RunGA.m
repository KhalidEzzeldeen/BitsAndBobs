function output = RunGA(input)

% A = rand(25,20);
% b = rand(25,1);

% input.A = A;
% input.b = b;
% input.SolO = 1; %Column solutions
% input.FitType = 1;
% input.ScoreType = [1, 1, 0];
% input.k = 1.5;
tic;
input = InitilizeGA(input);

% %Set output values.
% output.A = A;
% output.b = b;
% output.SolO = 1; %Column solutions
% output.FitType = 1;
% output.ScoreType = [1, 1, 0];
% output.k = 1.5;
% output.SSSize=SSSize;
% output.XValues = XValues;
% output.NumX = NumXValues;
% output.BestC = BestC;
% output.BestFit = BestFit;
% output.Chromos = Chromos;
% output.count = 0;
% output.PopSize = PopSize;


%------------------------------
%General input parameters
% input.A = A;
% input.b = b;
% input.SolO = 1; %Column solutions
% input.FitType = 1; %default fitness function type
% input.ScoreType = [1, 1, 0]; 
% output.k = 1.5;
% input.SSSize=SSSize; %solution space size based on NumX
% input.XValues = XValues; %domains of each x_i, each column corresponds to
% a different x
% input.NumX = NumXValues; %number of values for each X parameter
% input.PopType = 'fixed'; %fixed or variable sized population
% input.BestC = BestC; %current best chromosome(s) found thus far
% input.BestFit = BestFit; %current best fitness value for BestC.
% input.Chromos = Chromos; %current solution Chromosomes
% input.count = 0;
% input.PopSize = PopSize;
% input.Fitness %current fitness scores for chromosomes
% input.Score
% input.Rank %current ranks for chromosomes
%-----------------------------
%UpdateGA specific parameters
input.Parent = [2,4,5,8;.25,.25,.25,.25];
% input.StopCriteria = [inf, iteWOImprov, FracSingSoln];
input.Tenure = .15;
input.count = 0;

while input.count < input.PopSize*.5
    input = GABody(input);
end

XValues = input.XValues;
temp = XValues(input.BestC);

input.BestFit = MinMaxSqOp(input.A,temp,input.b);
time=toc;
output = input;
output.time=time;



%----------------------------------

%Starting input
% input.A = A;
% input.b = b;
% input.SolO = 1; %Column solutions
% input.FitType = 1;
% input.ScoreType = [1, 1, 0];
% input.k = 1.5;

%Add-ons
% input.Fitness = FitHolder;
% input.Score = ScoreHolder;
% input.Rank = Rank;

%Resulting Output
% output = input;
% output.SSSize=SSSize;
% output.XValues = XValues;
% output.NumX = NumXValues;
% output.BestC = BestC;
% output.BestFit = BestFit;
% output.Chromos = Chromos;
% output.count = 0;
% output.PopSize = PopSize;



function output = InitilizeGA(input)

A = input.A;
b = input.b;
[m,n] = size(A);
minB = min(b);
% maxB = max(b);
%Multiplier for etermining size of population.  Default == 1.5.
k = input.k;
if isempty(k), k = 1.5; end


%Determine domains for elements of 'x'
NumXValues = zeros(n,1);
%Max number of x values for a given x_i is 2m+1 via method below
XValues = zeros(2*m+1,n);
for ii = 1:n
    Temp = unique(A(:,ii));
    %Allow the minimum b value to be an option for x_i if no values in
    %A(:,ii) are less than minB
    if minB<min(Temp)
        Temp = [minB, Temp']';
    end
    %reduce number of sig figs being carried around
    Temp = round(Temp*10000)/10000;
    Temp2 = diff(Temp)'/2;
    XValues(1,ii)=Temp(1);
    for jj = 1:length(Temp)-1
        XValues(2*jj,ii) = Temp(jj)+Temp2(jj);
        XValues(2*jj+1,ii) = Temp(jj+1);
    end
    NumXValues(ii) = 2*jj-1;
    
end

% output.XValues = XValues;
% output.NumX = NumXValues;

%---------------------------------------------
%Set initial population of solutions.
%Size of solution space given potential x values.
SSSize = prod(NumXValues);
Chromos = zeros(n,round(k*log(SSSize)/log(2)));
PopSize = size(Chromos,2);
for ii = 1:n
    Chromos(ii,:) = randi(NumXValues(ii),1,PopSize);
end

%---------------------------------------------
%Find fitness and scores of initial population
%Convert Chromosomes to matrix of corresponding x values..
Solutions = zeros(n,PopSize);
for ii = 1:n
    Solutions(ii,:)= XValues(Chromos(ii,:),ii)';
end
%Set Solutions matrix to input structure.
input.Solutions = Solutions;
%Get fitness, scores.
output = FitnessRank(input);
% output.Fitness = FitHolder;
% output.Score = ScoreHolder;
% output.Rank = Rank;

%Find chromosome(s) corresponding to best fitness function value and record
%them from Chromos and their corresponding fitness values.
BestC = find(output.Rank==1);
BestFit = (output.Fitness(BestC(1)));
%CAUTION: does not account for possibility of row solutions..
BestC = Chromos(:,BestC);

%Set output values.
input.Fitness = output.Fitness;
input.Score = output.Score;
input.Rank = output.Rank;
output = input;
output.SSSize=SSSize;
output.XValues = XValues;
output.NumX = NumXValues;
output.BestC = BestC;
output.BestFit = BestFit;
output.Chromos = Chromos;
output.PopSize = PopSize;
output.count = 0;

%------------------------------------------------


%------------------------------
%General input parameters
% input.A = A;
% input.b = b;
% input.SolO = 1; %Column solutions
% input.FitType = 1; %default fitness function type
% input.ScoreType = [1, 1, 0]; 
% input.SSSize=SSSize; %solution space size based on NumX
% input.XValues = XValues; %domains of each x_i, each column corresponds to
% a different x
% input.NumX = NumXValues; %number of values for each X parameter
% input.PopType = 'fixed'; %fixed or variable sized population
% input.BestC = BestC; %current best chromosome(s) found thus far
% input.BestFit = BestFit; %current best fitness value for BestC.
% input.Chromos = Chromos; %current solution Chromosomes 
% input.Fitness %current fitness scores for chromosomes
% input.Score
% input.Rank %current ranks for chromosomes
%-----------------------------
%UpdateGA specific parameters
% input.Parent = [2,4,5,8;.25,.25,.25,.25];
% input.StopCriteria = [iteTot, iteWOImprov, FracSingSoln];
% input.Tenure = .15;
% input.count = 0;


function output = GABody(input)

CurrentChromos = input.Chromos;
PopSize = input.PopSize;
Score = input.Score;
XValues = input.XValues; %Values corresponding to each x_i
NumX = input.NumX; %Number of values available for each x_i
ParentSelect = input.Parent; %2 by k matrix of [parent values; probability of selecting]
[~,n] = size(input.A);

%Create PopSize new chromosomes
PopMeanFit = mean(Score);
NewChromos = [];
TabuList = [];
Tenure = ceil(input.Tenure)*PopSize+1;
for jj = 1:PopSize
    
    %Remove expired Tabued elements from TabuList
    if ~isempty(TabuList)
        TabuList(:,TabuList(2,:)==0)=[];
    end
    
    
    %Create new chromosome
    %Select number of parents to use in crossover
    ptemp = rand;
    for ii = 1:size(ParentSelect,2)
        if ptemp<sum(ParentSelect(2,1:ii))
            ptemp = ParentSelect(1,ii);
        end
    end
    %Select parents from population
%     PopSize, size(Score),pause
    TempScores = rand(PopSize,1).*Score;
    if ~isempty(TabuList)
        TempScores(TabuList(1,:))=-999;
    end
    pIndex = [];
    for ii = 1:ptemp
        %Max scores are alweays best soln, even though max fitness may not
        %be
        select = find(max(TempScores),1);
        pIndex = [pIndex,select];
        TabuList = [TabuList,[select;Tenure]];
    end
    %Do p parent crossover
    Temp = rand(n,ptemp);
%     size(Temp),size(pIndex),size(ones(n,1)*Score(pIndex)'),pause
    Temp = Temp.*(ones(n,1)*Score(pIndex)');
%     size(Temp),pause
    Temp(Temp==(max(Temp,[],2)*ones(1,ptemp)))=1;
    Temp(Temp<1)=0;
    NewChromo = zeros(n,1);
    for p = 1:ptemp
       NewChromo = NewChromo + Temp(:,p).*CurrentChromos(:,pIndex(p));
    end
%     size(NewChromo), size(Temp),pause
    NewChromo = NewChromo./sum(Temp,2);
    
    
    %Check to see if you do Mutation
    if mean(Score(pIndex))<PopMeanFit
        %Do mutation
        temp = (rand(1,2).*[n,1]);
        temp(2) = ceil(NumX(ceil(temp(1)))*temp(2));
        NewChromo(ceil(temp(1))) = temp(2);
    elseif rand<=exp(-mean(Score(pIndex))/PopMeanFit)
        %Do mutation with some probability, above
        temp = (rand(1,2).*[n,1]);
        temp(2) = ceil(NumX(ceil(temp(1)))*temp(2));
        NewChromo(ceil(temp(1))) = temp(2);
    end
    NewChromos = [NewChromos, NewChromo];
    
    
    %Reduce Tabu value
    if ~isempty(TabuList)
        TabuList(2,:) = TabuList(2,:)-1;
    end

end


%Calculate scores for new chromosomes...
%Convert Chromosomes to matrix of corresponding x values..
NewSolutions = zeros(n,PopSize);
for ii = 1:n
    NewSolutions(ii,:)= XValues(NewChromos(ii,:),ii);
end
%Set Solutions matrix to input structure.
input.Solutions = NewSolutions;
%Get fitness, scores.
output = FitnessRank(input);


%Remove worst solutions from solution set, update current population
LeaveIndex = zeros(1,PopSize);
FitHolder = [input.Fitness' output.Fitness']';
%CAUTION: Method does not work in general, only with smaller==better
for ii = 1:PopSize
    select = find(FitHolder==max(FitHolder),1);
    FitHolder(select) = -999;
    LeaveIndex(ii) = select;
end
%Fitness Measures
FitHolder(LeaveIndex)=[];
input.Fitness = FitHolder;
%Chromosomes
Chromos = [CurrentChromos, NewChromos];
Chromos(:,LeaveIndex)=[];
input.Chromos = Chromos;
%Scores
Score = [Score, output.Score];
Score(LeaveIndex) = [];
input.Score = Score';
%Find Rank vector.
[~,Rank] = sort(Score);
input.Rank = Rank;


%See if new best Solution found
if min(FitHolder)<input.BestFit
    Best = find(min(FitHolder));
    input.BestFit = FitHolder(Best(1));
    input.BestC = Chromos(:,Best);
    input.count = 0;
else
    input.count = input.count+1;
end


%Set output to input.
output = input;


%-------------------------------------------------


function output = MinMaxSqOp(A,x,b)
%A is m-by-n matrix
%x is n-by-1 vector
%b is m-by-1 vector
%determine dimensions of A
[m,n] = size(A);
%declare temp matrix for storing values
Temp = -1*ones(m,n);

%calculate A -o- x, the max-min fuzzy composition function
for j = 1:n
    Temp(:,j) = min(A(:,j),x(j));
end
Temp = max(Temp,[],2);
%calculate squared deviation from b vector (m-by-1)
Temp = (Temp-b).^2;

output = Temp;


