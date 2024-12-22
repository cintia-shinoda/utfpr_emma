# Aula 01 - Introdução, O Caos, Modelagem Matemática, MATLAB

---

## Vídeo da Aula
[Vídeo da Aula 1](https://drive.google.com/file/d/14ypGwx7wNAB_eVl_uA3QIJynI3fYP0cI/view)

---

- sistemas de captação de energia


# Sistemas Caóticos
- Matemática/Física: 
    - sistemas dinâmicos extremamente sensíveis às condições iniciais (popularmente: "efeito borboleta")
    - pequenas variações nas condições iniciais de um sistema caótico podem levar a resultados drasticamente diferentes, tornando a previsão a longo prazo praticamente impossível
- nomeado por Lorenz


## Aplicações do Caos na Engenharia
1. Controle de Sistemas Não-Lineares
2. Previsão e Modelagem
    - Meteorologia
    - Economia e Finanças
3. Comunicações
    - Criptografia
4. Biologia e Medicina
    - Modelagem de Sistemas Biológicos
5. Engenharia Civil e Arquitetura
    - Previsão de Desastres Naturais
    - Dinâmica Estrutural


## História
- Lyapunov
- Henri Poincaré
- Edward Lorenz
- Benoit Mandelbrot: fractais
- Wolf
<br>


## Cálculo dos Expoentes de Lyapunov
1. Método de Wolf (para séries temporais)
2. Método das Coordenadas Atrasadas

- expoente de Lyapunov positivo -> comportamento caótico


## Fontes de Captação de Energia Elétrica
- transdutor piezoelétrico: vibração mecânica
- quartzo: pressão mecânica
- controle = atuação de modificação do estado inicial do sistema
- ressonância < caos (máxima geração de energia)

## Modelos Dinânicos para Estudo
### Modelo Linear com Excitação Periódica
$\ddot{x} = -\frac{1}{2}x - 2\zeta \dot{x} + \chi v + f \cos\Omega t$

$\dot{v} = -\kappa\dot{x} - \Lambda v$

<!--Constantes:

 - $x$ = deslocamento
- $\dot{x}$ = velocidade
- $\ddot{x}$ = aceleração
- $\dot{v}$ = tensão

- $v$ =  potência
- $\chi \rightarrow \zeta$
- $\Lambda$ = perda elétrica? -->


1. Estabilidade do Sistema
autovalores da matriz associada ao sistema dinâmico
- **estável**: autovalores com parte real negativa
- **instável**: autovalores com parte real positiva
- **marginalmente estável**: autovalores com parte real nula

```matlab
% Cálculo de Autovalores
clear;
clc;
format short

% Parâmetros:
c = 0.01; % amortecimento
x = 0.05;
k = 0.5;
l = 0.05;
f = 0.08;
w = 0.8;
t = 1;

% Jacobiano (Linearização)
syms y1 y2 y3; % considera y1, y2 e y3 como variáveis simbólicas
f1 = y2;
f2 = (-1/2)*y1-2*c*y2+x*y3+f*cos(w*t);
f3 = -k*y2-l*y3;
J = jacobian([f1; f2; f3], [y1 y2 y3]);

%Valores para linearização
y1 = 1;
y2 = 0;
y3 = 0;

% Autovalores
A=subs (J);
A=double(A)
autovalor=eig(A)
```

<br>

```matlab
autovalor =

  -0.0112 + 0.7244i
  -0.0112 - 0.7244i
  -0.0476 + 0.0000i
```

**Sistema Estável**

#### Espaço de Estados
Nomeando: $x = x_1, \dot{x_1} = x_2, v = x_3$

$\dot{x_1} = x_2$

$\dot{x_2} = -\frac{1}{2}x_1 - 2\zeta x_2 + \chi x_3 + f \cos\Omega t$

$\dot{x_3} = - \kappa x_2 - \Lambda x_3$

#### Runge-Kutta
$
\zeta = 0,01 \\
\Omega = 0,8 \\
\chi = 0,05 \\
\kappa = 0,5 \\
\Lambda = 0,05 \\
f = 0,08
$

#### Condições iniciais
$
x(0) = 1 \\
\dot{x}(0) = 0 \\
v(0) = 0
$

<br>

```matlab

% arquivo: system_linear_periodico.m

function yprime = system_linear_periodico (t,y)
yprime = zeros(3,1);

% ========Parâmetros Realimentados ============== %
c = 0.01; %amortecimento
x = 0.05; % acoplamento piezoelétrico na equação mecânica
k = 0.5; %acoplamento piezoelétrico na eq. elétrica
l = 0.05; %recíproco da constante de tempo de carga
f = 0.083; %força de aceleração
w = 0.8; %0.4 a 0.9 (parâmetro controle)

% =============== State Space =================== %
yprime(1) = y(2);
yprime(2) = (-1/2) * y(1) - 2*c*y(2) + x*y(3) + f*cos(w*t);
yprime(3) = -k*y(2) - l*y(3);
% ================================================
```

<br>

```matlab
% arquivo: system_linear_periodico_plot.m

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
```


```matlab
>> system_linear_periodico_plot

Pot_linear_periodico =

    0.7038
```

<!-- - estabilização rápida = amortecimento alto -->