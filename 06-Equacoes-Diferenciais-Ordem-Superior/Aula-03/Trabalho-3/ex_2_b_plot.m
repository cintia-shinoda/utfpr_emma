clear;
clc;

[t,x] = ode45(@ex_2_b, [0:0.1:30], [1 0 0]);

tempo = t;
coluna1 = x(:,1);
coluna2 = x(:,2);
coluna3 = x(:,3);


figure()
plot(tempo, coluna1);
xlabel('Tempo [amostra]', 'Fontsize',24);
ylabel('Variável X no tempo', 'FontSize',24);

figure()
plot(tempo, coluna2);
xlabel('Tempo [amostra]','FontSize',24);
ylabel('1ª Derivada no Tempo', 'FontSize',24);

figure()
plot(tempo, coluna3);
xlabel('Tempo [amostra]','FontSize',24);
ylabel('Variável Z no Tempo', 'FontSize',24);

