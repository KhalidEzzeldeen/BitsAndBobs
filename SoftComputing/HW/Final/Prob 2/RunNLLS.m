function output = RunNLLS(input)

%define A,x0,b
%A
if isempty(input.A)
    m = input.N;
    n=max(ceil(rand*m),ceil(m/3));
    %Create A
    A = rand(m,n);
else
    A = input.A;
    [m,n] = size(A);
end
%x0
if isempty(input.x0)
    x0 = rand(n,1);
else
    x0 = input.x0;
end
%b
if isempty(input.b)
    b = rand(m,1);
else
    b = input.b;
end
tic;
%define handle for MinMaxOp function
MMO = @(x)MinMaxSqOp(A,x,b);
X_out = zeros(5,1);
for ii = 1:5
    %run non-linear least squares algorithm
    x = lsqnonlin(MMO,x0,zeros(n,1),ones(n,1));
    X_out(ii) = sum(MMO(x));
    x0 = x;
end
time=toc;
output.X = x;
output.MLS = min(X_out);
output.XO = X_out;
output.time = time;


%----------------------------------------------------

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