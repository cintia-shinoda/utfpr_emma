clear; %limpa a memória
clc;  % limpa a tela

% Resolução da EDO
[t,x] = ode45(@naolinear_3, [0:0.1:30], [1 0 0 0]);
%chama a ODE45 e dá os parâmetros:
    %(nome da função, variação do tempo, valores iniciais)

tempo = t;
coluna1 = x(:,1);  %todas as linhas da primeira coluna: Variável (x)
coluna2 = x(:,2);  %todas as linhas da segunda coluna: 1a Derivada (x_ponto)
coluna3 = x(:,3);  %todas as linhas da terceira coluna: 2a Derivada (x_dois_pontos)
coluna4 = x(:,4);  %todas as linhas da quarta coluna: Variável (z)


% Plotar as figuras
figure() %Variável (x)
plot(tempo, coluna1, 'k'); %"k"é a cor preta)
xlabel('Tempo [amostra]', 'Fontsize',24);
ylabel('Variável X no tempo', 'FontSize',24);

figure() %1a Derivada (x_ponto)
plot(tempo, coluna2, 'k');
xlabel('Tempo [amostra]','FontSize',24);
ylabel('1a Derivada no Tempo', 'FontSize',24);

figure() %2a Derivada (x_dois_pontos)
plot(tempo, coluna3, 'k');
xlabel('Tempo [amostra]','FontSize',24);
ylabel('2a Derivada no Tempo', 'FontSize',24);

figure() %2a Derivada (x_dois_pontos)
plot(tempo, coluna3, 'k');
xlabel('Tempo [amostra]','FontSize',24);
ylabel('Variável Z no Tempo', 'FontSize',24);