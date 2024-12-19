function x_ponto=ex1_trab(t,x)
x_ponto=[0;0];
x_ponto(1)=x(2);
x_ponto(2)=(4*x(2) + x(1))./3;