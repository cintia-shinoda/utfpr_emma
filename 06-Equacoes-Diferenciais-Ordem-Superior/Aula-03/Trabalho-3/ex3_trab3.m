function x_ponto = ex3_trab3(t,x)

tau = 2;
theta = 1;
k = 1.5;

x_ponto=[0;0;0];
x_ponto(1) = x(2);
x_ponto(2) = x(3);
x_ponto(3) = (tau*x(2) + 3*k) / sin(theta);

