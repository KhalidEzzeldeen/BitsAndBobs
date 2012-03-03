function W = WCalc(TX,X,B)


W = [];
for jk = 1:length(TX)
    index = 2*(jk-1);
    Xjk = [X(1+index:2+index)',X(3+index:4+index)'];
    Wtemp = Xjk*B(TX(jk))*B(TX(jk))'*Xjk';
    W(jk,:) = [Wtemp(:,1)',Wtemp(:,2)'];
end
