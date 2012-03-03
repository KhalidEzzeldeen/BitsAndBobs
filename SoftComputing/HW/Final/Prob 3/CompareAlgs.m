
N = [5,7,10,12,15,16,17,18];
times = zeros(2,length(N));
scores = zeros(2,length(N));

for ii = 1:length(N)
    A = CreateAdjMatrix(N(ii));
    A = A.A;
    input.A = A;
    output01 = MaxCutExact(input);
    output02 = RunTabu(input);
    times(:,ii) = [output01.RunTime; output02.RunTime];
    scores(:,ii) = [output01.MaxCut; output02.MaxCut];
end

scoresdiff = scores(1,:)-scores(2,:);

subplot(2,1,1), plot(N,times(1,:),N,times(2,:))
subplot(2,1,2), plot(N,scores(1,:),N,scores(2,:),N,scoresdiff)
