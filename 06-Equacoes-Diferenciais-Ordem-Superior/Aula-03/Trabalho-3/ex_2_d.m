function x_ponto = ex_2_d(t,x)

theta = 1;
beta = 1;
gamma = 3;

x_ponto = [0;0;0;0];
x_ponto(1) = x(2);
x_ponto(2) = x(3);
x_ponto(3) = (-x(3) + x(2) + 6*x(1) + sin(beta))/cos(theta);
x_ponto(4) = -x(1) + 3*x(4) + gamma;

