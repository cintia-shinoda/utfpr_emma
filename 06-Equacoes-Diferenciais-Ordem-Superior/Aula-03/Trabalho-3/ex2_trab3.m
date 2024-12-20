function x_ponto = ex2_trab3(t,x)

theta = 1;
k = 1.5;
x_ponto=[0;0];
x_ponto(1) = x(2);
x_ponto(2) = (-6*(x(2)^2) + k) / cos(theta);

