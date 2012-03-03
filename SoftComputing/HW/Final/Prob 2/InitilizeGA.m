
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
