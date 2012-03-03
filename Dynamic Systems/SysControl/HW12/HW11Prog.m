function out = HW11Prog(A,B)

%  A = [1,2,-1,3;0,4,1,2;-2,1,1,0;0,1,3,1];
%  B = [1,2,0,1;3,1,2,0]';
 n = length(A);
 m = size(B,2);
 C = zeros(n,n*m);
 for index = 0:n-1
     C(:,index*m+1:(index+1)*m) = A^(index)*B;
 end
 Ctemp = []; indexR = 0; index = 1; mutemp = zeros(n,1);
 
 %Get 1st N linearly independent columns
 while indexR < n && index <=size(C,2)
     R = rank([Ctemp,C(:,index)]);
     if R > indexR
         Ctemp = [Ctemp C(:,index)];
         mutemp(indexR+1) = mod(index,m)+m*(mod(index,m)==0);
         indexR = indexR+1;
     end
     index = index+1;
 end
 if rank(Ctemp)<n
     print('System is not controllable.');
     return
 end

 %Rearrange so that terms with same b are together
 Cbar = zeros(n);
 mu = zeros(1,m);
 index=1;
 for muI = 1:m
     temp = find(mutemp==muI);
     mu(muI) = length(temp);
     if ~isempty(temp)
        Cbar(:,sum(mu(1:muI-1))+1:sum(mu(1:muI-1))+mu(muI)) = Ctemp(:,temp);
        index=index+1;
     end
 end
 clear Ctemp;
 CbarInv = eye(n)/(Cbar);
 muIn = find(mu);
 
 %Get P matrix
 P = zeros(n);
 for muI = 1:length(muIn)
     index = sum(mu(1:(muI-1)));
     P(index+1,:) = CbarInv(index+mu(muI),:);
     for inde = 1:mu(muIn(muI))-1
        P(index+inde+1,:) = P(index+1,:)*A^inde;
     end
 end
 
 %Define Control Forms of A, B
 Ac = P*A/(P);
 Bc = P*B;
 
 out = [Ac,Bc,P];