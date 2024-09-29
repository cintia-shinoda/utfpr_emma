clear; %(limpar a memória)
clc; %(limpar a tela)

%Resolução da EDO

[t,x]=ode45(@licao2,[0:0.1:30],[1 0]); 
%chama a ODE45 e dá os parâmetros: 
%(nome da função, variação do tempo, valores
%iniciais)... para saber como fazer faça "help ODE45"
tempo=t;
coluna1=x(:,1); %todas as linhas da primeira coluna: Descolamento
coluna2=x(:,2); %todas as linhas da segunda coluna: Velocidade

%Plotar as figuras 
figure() %Deslocamento
plot(tempo,coluna1,'k'); %"k" é a cor preta
xlabel('Tempo [amostra]','FontSize',24);
ylabel('Deslocamento [taxa]','FontSize',24);

figure() %Velocidade
plot(tempo,coluna2,'k'); %"k" é a cor preta
xlabel('Tempo [amostra]','FontSize',24);
ylabel('Deslocamento [taxa]','FontSize',24);