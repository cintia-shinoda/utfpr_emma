function x_ponto = ex4_trab3(t,x)

tau = 2;
k = 1.5;

x_ponto=[0;0;0];
x_ponto(1) = x(2);
x_ponto(2) = x(3);
x_ponto(3) = (-21*x(3) + tau*x(2) - 3*x(1) + 3*k) ^ (1/2);

