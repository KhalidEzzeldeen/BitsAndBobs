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