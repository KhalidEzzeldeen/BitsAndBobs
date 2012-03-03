Index = [100,200,500];

for ii = 1:length(Index)
    temp = Index(ii);
    SAOutput = RunSA(temp,20);
    TabuOutput = RunTabu(temp,20);
    display(sprintf('For N = %d the two algorithms had the following outputs:' , temp));
    SAOutput
    TabuOutput
end