function output = MaxCutExact(input)

A = input.A;
n = length(A);
Best_X = [];
Best_Cut = -999;
tic;
%Only need to iterate over 1/2 of the solution space, since it is a
%symmetric space.  That is, for an integer i, the corresponding x produces
%the same solution as the corresponding x for 2^n - i.
for index = 1:2^(n-1)
    %dec2bin coverts a decimal value to a binary string.  Subtracting 48,
    %the encoding for '0', turns the bin string into a binary vector.  This
    %is one of the 2^n possible solutions.
    Current_X = dec2bin(index-1,n) - 48;
    T = A(Current_X==1,:);
    T = T(:,-1*(Current_X-1)==1);
    Current_Cut = sum(sum(T));
    if Current_Cut > Best_Cut
        Best_Cut = Current_Cut;
        Best_X = Current_X;
    end
end
time = toc;
output.SolVec = Best_X;
output.MaxCut = Best_Cut;
output.RunTime = time;