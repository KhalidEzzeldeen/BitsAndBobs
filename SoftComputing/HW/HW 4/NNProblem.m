function output = NNProblem(input)

% Input should include:
% -test cases (TrainingSet)
% -num of hidden nodes (H)
% -something about step size (Lam)


TestFunc = inline('(x1^2+x2^2-1)^2','x1','x2');
% gFunc = inline('1/(1+exp(-u))', 'u');
% hFunc = inline('2/(1+exp(-u))-1','u');
if input.Func == 2
    Func=inline('2/(1+exp(-u))-1','u');
else
    Func=inline('1/(1+exp(-u))', 'u');
end

TestSet = (rand(input.TestSize,2)*2)-1;
input.TrainingSet = (rand(input.TrainSize,2)*2)-1;

T = size(TestSet); % [numTrainingSets numInputs]
% I = T(2); % numInputs
J = input.HiddenNodes;
K = 1; % numOutPutNodes

% Error term to ouput for evaluation of method
E = 0;

output = NNTraining(input);
HiddenWeights = output.HiddenWeights;
OutPutWeights = output.OutPutWeights;

% Calculate ANN output for each test case
for t = 1:T(1)
    
    % 1) Calc values of hidden nodes
    TempTest = ones(J,1)*TestSet(t,:);
    % Temp is the output value for each hidden node
    Temp = HiddenWeights(:,1) + sum(TempTest.*HiddenWeights(:,2:end),2);
    Temp = Func(Temp); % this is an J by 1 vector of values for each hid node
    if size(Temp,1) ~= J, Temp=Temp';end
    
    % 2) Calc values of output nodes
    % zTemp is the output value for each output node
    zTemp = OutPutWeights(:,1) + sum((ones(K,1)*Temp').*OutPutWeights(:,2:end));
    zTemp = Func(zTemp); % this is K by 1 vector of ANN outputs
    if size(zTemp,1) ~= K, zTemp=zTemp';end
    
    E = E + .5*sum((zTemp - TestFunc(TestSet(t,1),TestSet(t,2)))^2);
    
end

E = E/(T(1)*K);

output.E = E;
    