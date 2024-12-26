function yprime = system_linear_nao_ideal (t,z)
yprime=zeros(5,1);
% ========================== Parâmetros Realimentados ===================
c=  0.01;
x=  0.05;
k=  0.5;
l=  0.05;
m=  0.2;
q=  0.3;
b=  1.5;
a=  0.8; %0.5 a 5.0 (Parâmetro de Controle)

% ============================= State Space =============================
yprime(1)= z(2);
yprime(2)= ((-1/2)*z(1)-2*c*z(2)+x*z(5)+m*z(4)^2*cos(z(3))+m*sin(z(3))*(a-b*z(4)))/(1-m*q*((sin(z(3)))^2));
yprime(3)= z(4);
yprime(4)= (q*sin(z(3)))*((-1/2)*z(1)-2*c*z(2)+x*z(5))+m*q*(z(4)^2)*cos(z(3))*sin(z(3))+a-b*z(4)/(1-m*q*((sin(z(3)))^2));
yprime(5)= -l*z(5)-k*z(2);
% =======================================================================