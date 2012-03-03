%input.A = A;
%input.Solutions = x;
%input.SolO = 1; %Column solutions
%input.b = b;
%input.FitType = 1;
%input.ScoreType = [1 or 2, 1, 0];

% output.Fitness = FitHolder;
% output.Score = ScoreHolder;
% output.Rank = Rank;




function output = FitnessRank(input)


%Integer determing which fitness calculation to use, specific to problem.
FitType = input.FitType;
if FitType==1
%     A = input.A;
%     b = input.b;
    FitFunc = @(x)MinMaxSqOp(input.A,x,input.b);
end
%Vector determing which score calculation to use.  Note that this
%doesn't affect the relative ranks of each solution.  Also indicates
%whether [+/- (larger/smaller magnitude)] (1/0 for both) scores are better.
%Default is large positive.
ScoreType = input.ScoreType;
if length(ScoreType)==1
    ScoreType = [ScoreType,1,1];
elseif length(ScoreType)==2
    ScoreType = [ScoreType,1];
end
if ScoreType(1)==1
    %Corresponds to exponential score
    ScoreFunc = @(x)ExpScore(x,ScoreType(2:3));
elseif ScoreType(1)==2
    %Corresponds to shifted linear score (i.e., shift lowest score to 0)
    ScoreFunc = @(x)LinScore(x,ScoreType(2:3));
end
%Assume that input solutions are in the form of a vector / matrix
Solutions = input.Solutions;
if isempty(input.SolO), input.SolO=1; end
%Set orientation; if 1, then solutions are columns, if 2 rows
if input.SolO==1
    [~,n] = size(Solutions);
else
    [n,~] = size(Solutions);
    Solutions = Solutions';
end
%Set FitHolder, find fitness of each solution as determined by particular
%problem.
FitHolder = zeros(n,1);
for ii = 1:n
    FitHolder(ii) = sum(FitFunc(Solutions(:,ii)));
end
%Set ScoreHolder, find score of each solution based on fitness function
%selected.
ScoreHolder = ScoreFunc(FitHolder);
%Find Rank vector.
[~,Rank] = sort(ScoreHolder);

output.Fitness = FitHolder;
output.Score = ScoreHolder;
output.Rank = Rank;



%-------------------------------------
%outputs a vector of least square values corresponding to each parameter
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


function output = ExpScore(FitHolder,ScoreType)
if ScoreType(2)==1
    Temp = exp(-FitHolder);
else
    Temp = exp(0-FitHolder);
end
output = Temp/sum(Temp);


function output = LinScore(FitHolder,ScoreType)
if ScoreType(2)==1
   Temp = FitHolder-min(FitHolder);
else
   Temp = max(FitHolder)-FitHolder;
end
output = Temp/sum(Temp);
