# Aula 02 - Funções com Matlab, Resolução de EDO de Ordem Superior Lineares

---

## Vídeo da Aula
[Vídeo da Aula 2](https://drive.google.com/file/d/1-QwDUxAKedfevi8RmOwfSIyyyQb_f5FA/view)

---

## Escrever Funções no Matlab
$f(x) = \frac{1}{(x-0,5)^2 + 0,1}$

```matlab
% arquivo: licao1.m

function y = licao1(x)
y = 1./((x-0.5).^2 + 0.1);
```
<br>

- plotar a função $y$ dentro de um certo domínio (-10 a 10) (domínio da variável $x$, variando de 0,1 em 0,1)

```matlab
% no Command Window:

x = -10:0.1:10;
plot(x, licao1(x))
```
<br>

- determinar a integral definida da função  para um certo domínio.
Está sendo utilizada o comando da integral por quadratura ```quad```

```matlab
% no Command Window:

integral = quad('licao1', -10, 10)
```

### Exercícios
slide 9
$f(x) = \frac{5x}{(x+1)^3 + 0.2}$

$g(x) = \frac{2x + 3}{5x - 1}$

$h(x) = 4x^3 - \frac{1}{x^2 + 1}$


## Resolução de EDOs de Ordem Superior Lineares com Matlab
EDO linear de 2ª ordem: $\ddot{x} + 2\dot{x} + x = 0$
- isolando o membro de ordem superior: $\ddot{x} = -2\dot{x} - x$
- fazendo: $x_1 = x;   x_2 = \dot{x}$
- então: $\begin{cases}\dot{x_1} = x_2 \\ \dot{x_2} = -2x_2 - x_1\end{cases}$

```matlab
% arquivo: exercicio04.m

function x_ponto=exercicio04(t,x)
x_ponto[0;0]; % valores iniciais para solução numérica
x_ponto(1) = x(2);
x_ponto(2) = -2*x(2) - x(1);
```
<br>

- métodos numéricos: MATLAB
- métodos algébricos: Maple ou Mathematica
- ODE45, resolve equações até 4ª e 5ª ordens


```matlab
% arquivo: licao3.m

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
```