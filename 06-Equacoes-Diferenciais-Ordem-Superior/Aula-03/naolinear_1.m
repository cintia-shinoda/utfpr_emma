function x_ponto=naolinear_1(t,x)
x_ponto=[0;0];
x_ponto(1) = x(2);
x_ponto(2) = -2*x(2)^2-x(1);