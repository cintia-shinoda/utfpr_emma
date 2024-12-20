function x_ponto = ex_2_b(t,x)

k = 2;
gamma = 1.5;

x_ponto = [0;0;0];
x_ponto(1) = x(2);
x_ponto(2) = -x(2) + x(1) + k;
x_ponto(3) = -28*x(1) + 7*gamma;

