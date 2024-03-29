%Creates an initial, psudo-random population of chromosomes for a given GA
%problem.  Inputs are information about the various parameters that the
%genes correspond to in each chromosome.  Can create initial pop for two
%types of GA problems:  those with fixed-length chromosomes for which each
%gene corresponds to a different parameter with various values for the 
%parameter, and fixed- or variable-length chromosomes for which each gene 
%corrsponsds to selecting a particular element or not selecting it


function output = InitPop(input)

if input.Type == 1
    % Fixed size chromosomes with multiple parameters
    %See info in PrelimProcess
    ParamInfo = input.Info;
    %Dims = [E,P], where E is the number of samples in the input data, and P is
    %the number of parameters corresponding to each sample.
    Dims = input.Size;
    %Estimate on size of search space based on number of allowed values for
    %each parameter.
    SearchSpace = input.SS;
    %Minimum number of desired chromosomes based on
    %http://lipas.uwasa.fi/cs/publications/2NWGA/node13.html
    MinChrom = log(SearchSpace)/log(2);
    %Factor to multiply MinChrom by to set a initial pop size; 1<=k<=2.
    k = input.k;
    %Matrix containing all chromosomes.  Easy to store in matrix structure,
    %easy to manipulate, update, read, etc.  Initilize to [].
    ChromoStorage = [];

    for jj = 1:Dims(2)
        tempInfo = ParamInfo{jj};
        tempCount = tempInfo{3};
        %Do boundary setting based on number of potential values, entries in
        %dataset having each value
        tempBound = zeros(tempInfo{2},1);
        for kk = 2:tempInfo{2}-1
            tempBound(kk) = tempBound(kk-1)+tempCount(kk-1,1)/Dims(1);
        end
        tempBound(end)=1;
        %Set all values for one parameter.  Leave as integers between and
        %including 1 and the cardinality of the particular parameter values.
        tempVec = rand(1,k*MinChrom);
        for kk = 2:tempInfo{2}
            tempVec(tempVec>=tempBound(kk-1) & tempVec<tempBound(kk)) = kk-1;
        end
        %Assign tempVec values to corresponding row in ChromoStorage.
        ChromoStorage(jj,:) = tempVec;
    end
    output.CS = ChromoStorage;

elseif input.Type == 2
    % Fixed or Variable size chromosomes corresponding to selection of n
    % elements from a set of similar items.
    Info = input.Info;
    MinSize = Info(1);
    MaxSize = Info(2);
    MaxValu = Info(3);
    %Make sure values for these parameters are reasonable (we don't allow
    %for multiple selection of the same element, which may be reasonable
    %for some problems, but not for this one.)
    if MaxValu < MaxSize
        MaxSize = MaxValu;
    end
    if MinSize > MaxValu
        MinSize = MaxSize;
    end
    %Determine estimate of search space size so adequate number of initial
    %chromosomes can be generated.  See above.
    SearchSpace = factorial(MaxValu)/(factorial(ceil((MaxSize+MinSize)/2))*...
                  factorial(MaxValu-ceil((MaxSize+MinSize)/2)));
    MinChrom = log(SearchSpace)/log(2);
    %Factor to multiply MinChrom by to set a initial pop size; 1<=k<=2.
    k = input.k;
    %Matrix containing all chromosomes.  Easy to store in matrix structure,
    %easy to manipulate, update, read, etc.  Initilize to [].
    ChromoStorage = [];
    for jj = 1:k*MinChrom
        %Index of potential remaining values to choose from
        tempIndex = 1:MaxValu;
        tempVec = zeros(MinSize+(floor(rand*MaxSize-MinSize)),1);
        for kk = 1:length(tempVec)
            Select = tempIndex(ceil(rand*length(tempIndx)));
            %tempIndex(tempIndx==Select)=[];
            tempVec(kk) = Select;
        end
        %Chromosomes oriented vertically.
        ChromoStorage(1:length(tempVec),jj) = tempVec;
    end
    output.CS = ChromoStorage;

elseif input.Type == 3
    %Creates chromosomes with binary values corrseponding to selection of a
    %particular element or not from a set of elements.
    Info = input.Info;
    k = input.k;
    density = input.d;
    ChromoStorage = rand(Info,k*Info);
    ChromoStorage(ChromoStorage>1-density)=1;
    ChromoStorage(ChromoStorage<1)=0;
    output.CS = ChromoStorage;
else
    print('Chromosome type not specified or specified to a non-existent value.');
    return
end