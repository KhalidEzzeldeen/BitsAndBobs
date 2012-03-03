function output = Test(y)

temp = inline('2*x+3*y','x','y');
output = @(x)temp(x,y);