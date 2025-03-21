function yprime = system_linear_periodico (t,y)
yprime = zeros(3,1);

% ========Parâmetros Realimentados ============== %
c = -0.2; %amortecimento
x = 0.05;
k = 0.5;
l = 0.05;
f = 0.083;
w = 0.8; %0.4 a 0.9 (parâmetro controle)

% =============== State Space =================== %
yprime(1) = y(2);
yprime(2) = (-1/2) * y(1) - 2*c*y(2) + x*y(3) + f*cos(w*t);
yprime(3) = -k*y(2) - l*y(3);
% ================================================