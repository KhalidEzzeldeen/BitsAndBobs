function [BestU, BestV, BestZ,Z] = ModifiedClustering(X, m, MaxItt)
    n = length(X);
    BestZ = 999999;
    Z = zeros(n-2,1);
    for c = 2:4
        [U, V, z] = Find_U_V(X, c, m, .01, MaxItt);
        Z(c-1)=z;
        if z < BestZ
            BestU = U;
            BestV = V;
            BestZ = z;
        end
    end

%% Find_U_V was the main function I used in Solving part 3 of the HW

function [U, V, z] = Find_U_V(X, c, m, tol, MaxItt)

    [p,n] = size(X);
    % create initial U randomly
    U = zeros(c,n);
    U(1,:) = rand(1,n);
    for ii = 2:c-1
        U(ii,:) = (ones(1,n)-sum(U(1:ii-1,:),1)).*rand(1,n);
    end
    U(end,:) = ones(1,n)-sum(U(1:end-1,:),1);
    % create initial V from U
    V = ones(p,1)*(1./ sum(U.^m,2))';
    for ii = 1:p
        V(ii,:) = V(ii,:).* sum(U.^m.*(ones(c,1)*X(ii,:)),2)';
    end
    %U, V, pause
    
    
    RefChange = 999;
    itt=0;
    %while RefChange > tol && itt < MaxItt
    while itt < MaxItt
        % Save old values for RefChange
        OldU=U; OldV=V;
        % Create New Values
        % New U from V
        temp = 0;
        for jj = 1:c
            XV = X - V(:,jj)*ones(1,n);
            % for G == I
            XV = sum(XV.^2,1);
            XV = 1./(XV.^(1/(m-1)));
            U(jj,:) = XV;
            temp = temp + XV;
        end
        U = U./(ones(c,1)*temp);
        % New V from U
        V = ones(p,1)*(1./ sum(U.^m,2))';
        for ii = 1:p
            V(ii,:) = V(ii,:).* sum(U.^m.*(ones(c,1)*X(ii,:)),2)';
        end
        % Compute Ref Change
        RefChange = mean(mean(abs((V-OldV)./OldV),2));
        itt=itt+1;
    end
    % Calculate variance of method
    z = 0;
    for jj = 1:c
        XV = X - V(:,jj)*ones(1,n);
        % for G == I
        XV = sum(XV.^2,1);
        XV = sum(XV.*(U(jj,:).^m));
        z = z + XV;
    end
    
        
        