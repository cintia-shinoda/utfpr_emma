function x_ponto = ex_2_c(t,x)

k = 5;
theta = 1;

x_ponto = [0;0;0];
x_ponto(1) = x(2);
x(2) = (-x(1) + 3*k)^(1/2);
x_ponto(3) = (-x(2) + x(3) + cos(theta))/6;

