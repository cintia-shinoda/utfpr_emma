function x_ponto=naolinear_2(t,x)
k=1.5;
x_ponto=[0;0;0];
x_ponto(1) = x(2);
x_ponto(2) = x(3);
x_ponto(3) = (-x(3)*x(2) + 5*x(2) + k)/2;
