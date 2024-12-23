% Cálculo de Autovalores
clear
clc
format short

% Parâmetros:
c = 0.01;
x = 0.05;
k =	0.5;
l =	0.05;
f =	0.5;
w = 0.083;
t = 1;

% Jacobiano (Linearização)
syms y1 y2 y3;
f1= y2;
f2= (1/2)*y1*(1-y1^2)-2*c*y2+x*y3+f*cos(w*t);
f3= -k*y2-l*y3;
J = jacobian([f1; f2; f3], [y1 y2 y3]);

% Valores para linearização
y1=1;
y2=1;
y3=1;

% Autovalores
A=subs (J); 
A=double(A)
autovalor=eig(A)