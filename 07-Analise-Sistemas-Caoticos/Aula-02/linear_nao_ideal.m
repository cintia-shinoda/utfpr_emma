% Cálculo de Autovalores
clear all
clc 
format short

%Parâmetros
c=0.01;
x=0.05;
k=0.5;
l=0.05;
m=0.2;
q=0.3;
a=5.0;
b=1.5;

%Jabobiano (Linearização)
syms y1 y2 y3 y4 y5;
f1= y2;
f2= ((-1/2)*y1-2*c*y2+x*y5+m*y4^2*cos(y3)+m*sin(y3)*(a-b*y4))/(1-m*q*((sin(y3))^2));
f3= y4;
f4= (q*sin(y3))*((-1/2)*y1-2*c*y2+x*y5)+m*q*(y4^2)*cos(y3)*sin(y3)+a-b*y4/(1-m*q*((sin(y3))^2));
f5= -l*y5-k*y2;
J = jacobian([f1; f2; f3; f4; f5], [y1 y2 y3 y4 y5]);

%Valores para linearização
y1=1;
y2=0;
y3=0;
y4=0;
y5=0;

%Autovalores
A=subs (J); A=double(A)
autovalor=eig(A)