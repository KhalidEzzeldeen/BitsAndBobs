function output = PrelimProcess(input)

%Determine dimensions of input data
[E,P] = size(input.data);
%Stores revelant information about the various parameters. Cell structure.
%Each entry in cell is also a cell.  First entry of cell is binary,
%indicating whether parameter is binned (1) or not (0).  Second entry is
%the number of distinct values / bins for the parameter.  For binned, data,
%third entry is matrix of [Count,Centers], and last entry is the bin width.
% For non-binned, the third entry is the matrix of [count for each
% parameter value, unique parameter values].
ParamInfo = cell(P,1);
%This is the number of suggested bins as outlined by Sturges
SturgesBins = ceil(log(E)/log(2) + 1);
%Multiplier for SturgesBins for determining threshold of unique values
%allowable before binning data
k = input.k;
%Track the size of the parameter space based on how many potential values
%there are for each parameter
SearchSpace = 1;

%Do for all parameters
for jj = 1:P
    %Look at jj-th parameter data
    TempData = input.data(:,jj);
    %Find number of unique values for jj-th parameter
    tempUni=unique(TempData);
    %If more than thresh unique eliments, bin; else, don't bin
    if length(tempUni) > k*SturgesBins
        %Hist function 'bins' data into 'SturgesBins' number of bins,
        %outputs number of entries in each bin (Count) and the center of
        %each bin (Center).
        [Count,Centers] = hist(TempData,SturgesBins);
        %Half-width of each bin
        BinWidth = Centers(1)-min(TempData);
        %Explained above
        ParamInfo{jj} = {1, length(Count), [Count,Centers], BinWidth};
        SearchSpace = SearchSpace*SturgesBins;
    else
        %Determine number of 
        Count = hist(TempData,tempUni);
        %Ditto
        ParamInfo{jj} = {0, length(tempUni), [Count' tempUni]};
        SearchSpace = SearchSpace*length(tempUni);
    end
    
end

output.Info = ParamInfo;
output.Size = [E,P];
output.SS = SearchSpace;