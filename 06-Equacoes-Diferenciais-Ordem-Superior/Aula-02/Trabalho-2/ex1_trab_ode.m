clear;
clc;



[t,x] = ode45(@ex1_trab,[0:0.1:30], [1 0]);
tempo = t;
coluna1 = x(:,1);
coluna2 = x(:,2);


% Plotar os gráficos
figure()
plot(tempo,coluna1,'k');
xlabel('Tempo [amostra]','FontSize',24);
ylabel('Deslocamento [taxa]','FontSize',24);

figure()
plot(tempo,coluna2,'k');
xlabel('Tempo [amostra]','FontSize',24);
ylabel('Deslocamento [taxa]','FontSize',24);