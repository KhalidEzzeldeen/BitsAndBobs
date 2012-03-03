tic;
Grad = 0;
fprintf('This program attempts to find all global mins for the three functions assigned.\n\n');
fprintf('First function:\n\n');
[GlobalMins Temp] = ProblemForm2(1); %#ok<*NOPTS,*NASGU>
GlobalMins
Grad = Grad+Temp;
fprintf('\n\n')
fprintf('Second function:\n\n');
[GlobalMins Temp] = ProblemForm2(2);
GlobalMins
Grad = Grad+Temp;
fprintf('\n\n')
fprintf('Third function:\n\n');
[GlobalMins Temp] = ProblemForm2(3);
GlobalMins
Grad = Grad+Temp;
fprintf('\n')
fprintf('The total number of gradient vectors computed in this process was %i.\n',Grad);
fprintf('No Hessians were harmed in the computation of these minima.\n')
toc