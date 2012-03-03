function output = CreateAdjMatrix(input)

N = input;
A = zeros(N);

for ii = 1:N-1
    for jj = ii+1:N
        A(ii,jj) = (ii^2+jj^2)/(ii+jj);
    end
end
A=A+A';
output = A;