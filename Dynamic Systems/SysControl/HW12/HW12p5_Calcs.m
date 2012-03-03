function out = HW12p5_Calcs(CharPoly)

A1 = [3,1;1,3];
C1 = [2,1];
OO = [C1;C1*A1];
%Calculate value for K in "e(t) = exp[(A-KC)t]e(0)"
Ko = CharPoly(A1)/OO*[0;1];
out = [Ko A1-Ko*C1];