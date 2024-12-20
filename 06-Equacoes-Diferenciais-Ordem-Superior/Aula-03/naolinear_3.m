function x_ponto=naolinear_3(t,x)

k=1.5;
g=0.3;
x_ponto=[0;0;0];
x_ponto(1) = x(2);
x_ponto(2) = x(3);
x_ponto(3) = (-x(3) + 5*x(2)*x(1)+k)/3;
x_ponto(4) = -2*x(1) + g;