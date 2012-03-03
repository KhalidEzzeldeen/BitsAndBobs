%read file
data1=zeros(51111,10);
data1=csvread('bankruptcy.csv');
y=zeros(51111,1);
y=data1(:,2);
x1=zeros(51111,1);
x2=zeros(51111,1);
x3=zeros(51111,1);
x4=zeros(51111,1);
x5=zeros(51111,1);

x1=data1(:,5);
x2=data1(:,6);
x3=data1(:,7);
x4=data1(:,8);
x5=data1(:,9);

x=zeros(5,51111);
x=[x1'; x2';x3';x4';x5'];
y=y';

%creat and traint neural network
net=newff(x,y,5,{'tansig','tansig'},'trainlm');
net.trainParam.epochs = 2000;
net.trainParam.goal=0.0001;
net=train(net,x,y);
Y=zeros(1,51111);
Y=sim(net,x);

%data manipulation
FailData = x(:,y==1);
NonFailData = x(:,y==0);

%creat and train new neural network
net1=newff(NewData,YNewData,{5,5,5},{'tansig','tansig','tansig','tansig'},'trainlm');
net1.trainParam.epochs = 2000;
net1.trainParam.goal=0.0001;
net1=train(net1,NewData,YNewData);
YPredict=sim(net1,NewData);



%-------------------------------------------
% April 8th
% 1. cluster analysis on input X;
%    check if average value of Y is around 0.5 for each cluster
% 2. read help documentation on 'newff' see how to change some of the
% default parameters, for example 'validate checks'
% 3. read the bankruptcy neural network paper
% 4. look genetic programming algorithm
% 5. ask Dr.Fang about the neural network problems.







%plot(y','r');
%hold on
%plot(Y,'b');

%data2=fopen('testing.txt','wt');
%fprintf(data1,'%s %s %s\n','T1','T2','f');
%T1=2*rand(100,1)-1;
%T2=2*rand(100,1)-1;
%for i=1:100
%    fT(i)=(T1(i)^2+T2(i)^2-1)^2;
%    fprintf(data2,'%f %f %f\n',T1(i),T2(i),fT(i));
%end
%fclose(data2);
%T=[T1,T2]';
%FY=sim(net,T);
%plot(fT,'r');
%hold on
%plot(FY,'b');
%data3=fopen('result.xls','wt');
%fprintf(data3,'%s\t%s\t%s\t%s','X1','X2','Target','Approximation');
%fclose(data3);
%XLSWRITE('C:\Users\Yuan\Documents\TeX Files\ISE790 Soft Computing\results.xls',T1,'A2:A101');
%XLSWRITE('C:\Users\Yuan\Documents\TeX Files\ISE790 Soft Computing\results.xls',T2,'B2:B101');
%XLSWRITE('C:\Users\Yuan\Documents\TeX Files\ISE790 Soft Computing\results.xls',fT','C2:C101');
%XLSWRITE('C:\Users\Yuan\Documents\TeX Files\ISE790 Soft Computing\results.xls',FY','D2:D101');

