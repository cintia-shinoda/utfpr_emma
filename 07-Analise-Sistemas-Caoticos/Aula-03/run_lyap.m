[T,Res]=lyapunov_matds(3,@lorenz_ext,@ode45,0,0.01,7400,[0 1 0],10);
plot(T,Res);
title('Dynamics of Lyapunov exponents');
xlabel('Time'); ylabel('Lyapunov exponents');

