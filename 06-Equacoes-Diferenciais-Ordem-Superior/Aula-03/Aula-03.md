# Aula 03 - Funções com Matlab, Resolução de EDO de Ordem Superior Não-Lineares e Sistemas de EDOs

---

## Vídeo da Aula
[Vídeo da Aula 3](https://drive.google.com/file/d/1FoQeioIICPxVfS0Stmw6N-9C7GDNKbqG/view)

---

## EDO de Ordem Superior Não-Linear de 2ª Ordem

$\ddot{x} + 2\dot{x^2} + x = 0$

$\ddot{x} = -2\dot{x^2} - x$

Fazendo:
$x_1 = x;$
$x_2 = \dot{x}$

Então:
$\begin{cases}\dot{x_1} = x_2 \\ \dot{x_2} = -2x_2^2 - x_1\end{cases}$
<br>

```matlab
% arquivo naolinear_1.m

function x_ponto=naolinear_1(t,x)
x_ponto=[0;0];
x_ponto(1) = x(2);
x_ponto(2) = -2*x(2)^2-x(1);
```

```matlab
% arquivo: naolinear_1_plot.m

clear; %limpa a memória
clc;  % limpa a tela

% Resolução da EDO
[t,x] = ode45(@naolinear_1, [0:0.1:30], [1 0]);
%chama a ODE45 e dá os parâmetros:
    %(nome da função, variação do tempo, valores iniciais)

tempo = t;
coluna1 = x(:,1);  %todas as linhas da primeira coluna: Variável (x)
coluna2 = x(:,2);  %todas as linhas da segunda coluna: 1a Derivada (x_ponto)

% Plotar as figuras
figure() %Variável (x)
plot(tempo, coluna1, 'k'); %"k"é a cor preta)
xlabel('Tempo [amostra]', 'Fontsize',24);
ylabel('Variável X no tempo', 'FontSize',24);

figure() %1a Derivada (x_ponto)
plot(tempo, coluna2, 'k');
xlabel('Tempo [amostra]','FontSize',24);
ylabel('1a Derivada no Tempo', 'FontSize',24);

```

<br><br>

## EDO de Ordem Superior Não-Linear de 3ª Ordem

$2\overset{...}{y} + \ddot{y} \dot{y} - 5\dot{y} = k$

$\overset{...}{y} = \frac{-\ddot{y}\dot{y} + 5\dot{y} + k}{2}$

Fazendo: $x_1 = y; x_2 = \dot{y}; x_3 = \ddot{y}$

Então: $\begin{cases}\dot{x_1} = x_2 \\ \dot{x_2} = x_3 \\ \dot{x_3} = \frac{-x_3x_2 + 5x_2 + k}{2}\end{cases}$

```matlab
% arquivo naolinear_2.m

function x_ponto=naolinear_2(t,x)
k=1.5;
x_ponto=[0;0;0];
x_ponto(1) = x(2);
x_ponto(2) = x(3);
x_ponto(3) = (-x(3)*x(2) + 5*x(2) + k)/2;
```

```matlab
% arquivo naolinear_2_plot.m

clear; %limpa a memória
clc;  % limpa a tela

% Resolução da EDO
[t,x] = ode45(@naolinear_2, [0:0.1:30], [1 0 0]);
%chama a ODE45 e dá os parâmetros:
    %(nome da função, variação do tempo, valores iniciais)

tempo = t;
coluna1 = x(:,1);  %todas as linhas da primeira coluna: Variável (x)
coluna2 = x(:,2);  %todas as linhas da segunda coluna: 1a Derivada (x_ponto)
coluna3 = x(:,3);  %todas as linhas da terceira coluna: 2a Derivada (x_dois_pontos)

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
```

## Sistema de EDOs de 3ª Ordem Não-Linear
Sistema de EDOs, onde $z$ depende de $y$:

$\begin{cases}3\overset{...}{y} + \ddot{y} - 5\dot{y}y = k \\ 2y + \dot{z} = \gamma\end{cases}$

$\begin{cases}\overset{...}{y}=\frac{-\ddot{y} + 5\dot{y}y + k}{3} \\ \dot{z} = -2y + \gamma\end{cases}$

$x_1 = y; x_2 = \dot{y}; x_3 = \ddot{y}; x_4 = z$

$\begin{cases}\dot{x_1} = x_2 \\ \dot{x_2} = x_3 \\ \dot{x_3} = \frac{-x_3 + 5x_2x_1 + k}{3} \\ \dot{x_4} = -2x_1 + \gamma\end{cases}$

```matlab
% arquivo naolinear_3.m

function x_ponto=naolinear_3(t,x)

k=1.5;
g=0.3;
x_ponto=[0;0;0];
x_ponto(1) = x(2);
x_ponto(2) = x(3);
x_ponto(3) = (-x(3) + 5*x(2)*x(1)+k)/3;
x_ponto(4) = -2*x(1) + g;
```

<br>

```matlab
% arquivo naolinear_3_plot.m

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
```