input.tol = 1;
input.InputNodes = [];
input.Lam = [];
Lam = [.025 .05 .75 1 1.5];
input.TrainSize=100;
input.TestSize=100;
input.HiddenNodes=[];
HiddenNodes = [2 3 4 5 10];
input.Func=1;
Store = {};
diary on
for ii = 1:2
    input.Func=ii;
    for jj = 1:length(Lam)
        input.Lam = Lam(jj);
        for kk = 1:length(HiddenNodes)
            input.HiddenNodes = HiddenNodes(kk);
            Temp=0;
            for hh=1:10
                output = NNProblem(input);
                Temp = Temp + output.E;
            end
            Store{end+1} = [input.Func,input.Lam,input.HiddenNodes Temp/10];
        end
    end
end
save 'Store_003.mat' Store
diary off

% % find(Temp==min(Temp))
% Temp = [];
% for ii=1:50
% Temp(ii)=Store{ii}(4);
% end
% find(Temp==min(Temp))