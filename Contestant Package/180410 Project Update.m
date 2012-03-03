%% read the data file
clear;
tic;
data1=zeros(50789,43);
data1=csvread('diabetes.csv');
t1=toc;
%% assigning value to parameters
sex=data1(:,1);
census_region=data1(:,2);
age=data1(:,3);
marital_status=data1(:,4);
years_edu=data1(:,5);
highest_degree=data1(:,6);
served_armed_forces=data1(:,7);
foodstamps_purchase=data1(:,8);
total_income=data1(:,9);
more_than_one_job=data1(:,10);
wears_eyeglasses=data1(:,11);
person_blind=data1(:,12);
wear_hearing_aid=data1(:,13);
is_deaf=data1(:,14);

totalexp=data1(:,15);
amount_paid_medicare=data1(:,16);
amount_paid_medicade=data1(:,17);
numb_visits=data1(:,18);
dental_check_up=data1(:,19);
cholest_lst_check=data1(:,20);
last_checkup=data1(:,21);
last_flushot=data1(:,22);
lost_all_teeth=data1(:,23);
last_psa=data1(:,24);
last_pap_smear=data1(:,25);
last_breast_exam=data1(:,26);
last_mammogram=data1(:,27);
bld_stool_tst=data1(:,28);
sigmoidoscopy_colonoscopy=data1(:,29);

wear_seat_belt=data1(:,30);
high_blood_pressure_diag=data1(:,31);
heart_disease_diag=data1(:,32);
angina_dianosis=data1(:,33);
heart_attach_diag=data1(:,34);
other_heart_disase=data1(:,35);
stoke_diagnosis=data1(:,36);
emphysema_diag=data1(:,37);
joint_pain=data1(:,38);
currently_smoke=data1(:,39);
asthma_diagnosis=data1(:,40);

child_bmi=data1(:,41);
adult_bmi=data1(:,42);
diabetes_diag_binary=data1(:,43);

%% preallocation of parameters
%x=zeros(7,50789);
%x=[sex'; census_region'; age';
%marital_status';years_edu';highest_degree';served_armed_forces';
%foodstamps_purchase'; total_income';more_than_one_job'; wears_eyeglasses';
%person_blind'; wear_hearing_aid';is_deaf'; wear_seat_belt';
%high_blood_pressure_diag';heart_disease_diag';other_heart_disase';stoke_diagnosis';
%    emphysema_diag';joint_pain';currently_smoke';asthma_diagnosis';
%    child_bmi';adult_bmi'];

x=[age';marital_status';total_income';more_than_one_job';highest_degree';high_blood_pressure_diag';adult_bmi';];
y=diabetes_diag_binary';


%% generate training data and validation data

r = rand(1,50789);
x_train=x(:,r>=.3);
y_train=y(r>=.3);
x_valid=x(:,r<0.3);
y_valid=y(:,r<0.3);

%% creat and train neural network
net=newff(x_train,y_train,3,{'tansig','tansig'},'trainlm');
net.trainParam.epochs = 2000;
net.trainParam.goal=exp(-15);
net.trainParam.min_grad=exp(-20);
net.trainParam.max_fail=10;
net=train(net,x_train,y_train);
z_train=sim(net,x_train);
%%


%% data manipulation
%FailData = x(:,y==1);
%NonFailData = x(:,y==0);

%% creat and train new neural network
%net1=newff(NewData,YNewData,{5,5,5},{'tansig','tansig','tansig','tansig'},'trainlm');
%net1.trainParam.epochs = 2000;
%net1.trainParam.goal=0.0001;
%net1=train(net1,NewData,YNewData);
%YPredict=sim(net1,NewData);
%% plot the results
scatter(1:length(y_train),y_train);
hold on;
scatter(1:length(z_train),z_train);

%% 3-D graph on z

%scatter(age,adtBMI);
%set('MarkerFaceColor', z);
%surf(age,adtBMI,y,'EdgeColor','none')
%scatter(age,adult_bmi,6,z');
%colorbar;
%% validate the data
z_valid=sim(net,x_valid);
scatter(1:length(y_valid),y_valid);
hold on;
scatter(1:length(z_valid),z_valid);
%% reduce BMI by 10%

x_reduced=x_valid;
x_reduced(7,:)=x_reduced(7,:)*0.9;
y_reduced=y_valid;

%% compare the difference 
z_reduced=sim(net,x_reduced);
scatter(1:length(y_valid),y_valid);
hold on;
scatter(1:length(z_valid),z_valid);
hold on;
scatter(1:length(z_reduced),z_reduced);
%% plot the difference
scatter(1:length(z_reduced),(z_reduced-z_valid)./z_valid, 6, z_valid);

%% 3-D graph on the absolute difference between z_reduced and z_valid
age=x_valid(1,:);
adult_bmi=x_valid(7,:);
figure1 = figure;
figure1=scatter(age,adult_bmi,6 ,z_valid-z_reduced);
colorbar;
%% 3-D graph on the normalized difference between z_reduced and z_valid
age=x_valid(1,:);
adult_bmi=x_valid(7,:);
figure2 = figure;
figure2=scatter(age,adult_bmi,6,(z_valid-z_reduced)./z_valid);
colorbar;
%% 3-D graph on z_valid
age=x_valid(1,:);
adult_bmi=x_valid(7,:);
figure3 = figure;

figure3=scatter(age,adult_bmi,6,z_valid);
colorbar;
%% 3-D graph on the normalized difference between z_reduced and z_valid
age=x_valid(1,:);
adult_bmi=x_valid(7,:);
figure4 = figure;
figure4=scatter(age,adult_bmi,6,((z_valid-z_reduced)./z_valid+5*(z_valid-z_reduced))/2);
colorbar;
%% 3-D graph on y
scatter(age,total_income,6,y);
colorbar;
%%
scatter(age,more_than_one_job,6,y);
colorbar;
%% 
%% notes
%-------------------------------------------
% April 15th
% +++ primary factor analysis
% +++ select input parameters X based on partially squrared analysis (PLS)
 

% 1. cluster analysis on X.
% 2. partition the whole data set C into subsets C_i according to the clustering results
% 3. generate training data by pulling out 70% of each C_i, which are
% recorded as D_i. Training data set D={D_i}, 
% 4. +++External lidation data set E=C-D.
% 5. +++train NN1 via D.
% 6.  internally validate NN1 via each D_i.
% 7.  +++externally validate NN1 via E.
% 8.  +++reducing BMI by 10% for C_i to generate new data set F_i
% 9.  +++record output of NN1 from  inout F_i by z_i
%10. compare z_i with y_i, which is the output from C_i.








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

