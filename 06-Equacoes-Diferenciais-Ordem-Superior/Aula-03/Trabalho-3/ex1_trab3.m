function x_ponto = ex1_trab3(t,x)

theta = 1;
x_ponto = [0;0];
x_ponto(1) = x(2);
x_ponto(2) = -9*x(1) + cos(theta);

