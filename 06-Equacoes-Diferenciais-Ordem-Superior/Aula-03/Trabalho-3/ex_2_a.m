function x_ponto = ex_2_a(t,x)

k = 5;
gamma = 3;

x_ponto = [0;0;0;0];
x_ponto(1) = x(2);
x_ponto(2) = x(3);
x_ponto(3) = -x(3) + 5*(x(2)^2) - x(1) + k;
x_ponto(4) = -6*x(1) + 21*x(4) + 3*gamma;

