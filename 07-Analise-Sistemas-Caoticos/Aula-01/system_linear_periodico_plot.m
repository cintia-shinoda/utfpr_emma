[t,y] = ode45(@system_linear_periodico,[0:0.1:2500], [1 0 0]);

h1 = t;
h2 = y(:,1); %deslocamento
h3 = y(:,2); %velocidade
h4 = y(:,3); %tensão

% Cálculo da Potência
% P = (Vrms)^2/R

Pot_linear_periodico = ((rms(h4))^2)/0.1

figure() % Deslocamento
plot(h1, h2, 'k');
xlabel('Tempo [amostra]', 'FontSize',24);
ylabel('Deslocamento [taxa]', 'FontSize',24);

figure() % Velocidade
plot(h1, h3, 'k');
xlabel('Tempo [amostra]', 'FontSize',24);
ylabel('Velocidade [taxa]', 'FontSize',24);

figure() % Tensão
plot(h1, h4, 'k');
xlabel('Tempo [amostra]', 'FontSize',24);
ylabel('Tensão [taxa]', 'FontSize',24);

figure() % 3D Retrato de Fase
plot3(h1,h2,h3, 'k');
grid on;
xlabel('Tempo [amostra]', 'FontSize',18);
ylabel('Deslocamento [taxa]', 'FontSize',18);
zlabel('Velocidade [taxa]','FontSize',18);

figure() % Retrato de Fase
plot(h2(20000:25000,:), h3(20000:25000,:),'k');
xlabel('Deslocamento [taxa]', 'FontSize',24);
ylabel('Velocidade [taxa]', 'FontSize',24);