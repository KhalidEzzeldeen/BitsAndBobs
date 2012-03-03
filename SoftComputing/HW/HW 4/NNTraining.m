function output = NNTraining(input)

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

TrainingSet = input.TrainingSet;
T = size(TrainingSet); % [numTrainingSets numInputs]
I = T(2); % numInputs
J = input.HiddenNodes;
K = 1; % numOutPutNodes
Lam = input.Lam;
tol = input.tol;
% Initialize weights.  a's around 0, b's [-1,0,1]
HiddenWeights = (rand(J,I+1)-.5)/2; % make J by I+1; a0 + aK for each input node; a's
OutPutWeights = round(rand(K,J+1)); % make K by J+1; b's
OutPutWeights(OutPutWeights==0)=-1;
if mod(J,2)==1, OutPutWeights(:,1) = 0; end
% E = 999;
dE = 999;
t = 1;

while t <= T(1) && dE > tol
    % Calculate ANN output for given test case
    
    % 1) Calc values of hidden nodes
    TempTrain = ones(J,1)*TrainingSet(t,:);
    % Temp is the output value for each hidden node
    Temp = HiddenWeights(:,1) + sum(TempTrain.*HiddenWeights(:,2:end),2);
    Temp = Func(Temp); % this is an J by 1 vector of values for each hid node
    if size(Temp,1) ~= J, Temp=Temp';end
%     size(Temp),size(OutPutWeights),pause
    
    % 2) Calc values of output nodes
    % zTemp is the output value for each output node
    zTemp = OutPutWeights(:,1) + sum((ones(K,1)*Temp').*OutPutWeights(:,2:end));
    zTemp = Func(zTemp); % this is K by 1 vector of ANN outputs
    if size(zTemp,1) ~= K, zTemp=zTemp';end
    
    % 3) Update weights on nodes based on output for this test case
    ETemp = zTemp - TestFunc(TrainingSet(t,1),TrainingSet(t,2));
    if input.Func == 1
        pk = (ETemp).*zTemp.*(1-zTemp); % size K by 1
    elseif input.Func == 2
        pk = ETemp.*(zTemp+1).^2;
    else
        pk = (ETemp).*zTemp.*(1-zTemp); % size K by 1
    end
    % create vector that is sum(p sub k times b sub jk), size J by 1
    pbj = sum((pk*ones(1,J)).*OutPutWeights(:,2:J+1),1)';
    if input.Func == 1
        qj = pbj.*(Temp).*(1-Temp); % J by 1
    elseif input.Func == 2
        qj = pbj.*(Temp+1).^2;
    else
        qj = pbj.*(Temp).*(1-Temp); % J by 1   
    end
    
    % Find partial dir. of E with respect to weights
    dEdb = (pk*ones(1,J+1)).*[ones(K,1),(ones(K,1)*Temp')]; % K by J+1 matrix
    dEda = (qj*ones(1,I+1)).*[ones(J,1),(ones(J,1)*TrainingSet(t,:))]; % J by I+1 matrix
    % Do weight update using delta method
    HiddenWeights = HiddenWeights - Lam*dEda;
    OutPutWeights = OutPutWeights - Lam*dEdb;
    
    % 4) Update stopping conditions
    t = t + 1;
%     ETemp = .5*(ETemp)^2;
%     dE = abs(E-ETemp);
%     E = ETemp;
end

output.HiddenWeights = HiddenWeights;
output.OutPutWeights = OutPutWeights;