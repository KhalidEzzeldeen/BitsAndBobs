

N = [10,15,20,25,30,35,40,45];
times = zeros(2,length(N));
scores = zeros(2,length(N));

input.SolO = 1; %Column solutions
input.FitType = 1;
input.ScoreType = [1, 1, 0];
input.k = 1.5;
input.x0 = [];


for ii = 1:length(N)
    A = rand(N(ii),ceil(rand*N(ii)));
    b = rand(N(ii),1);
    input.A = A;
    input.b = b;
    
    output01 = RunGA(input);
    
    output02 = RunNLLS(input);
    
    times(:,ii) = [output01.time; output02.time];
    scores(:,ii) = [sum(output01.BestFit); output02.MLS];
end

scoresdiff = scores(1,:)-scores(2,:);

subplot(2,1,1), plot(N,times(1,:),N,times(2,:))
subplot(2,1,2), plot(N,scores(1,:),N,scores(2,:),N,scoresdiff)