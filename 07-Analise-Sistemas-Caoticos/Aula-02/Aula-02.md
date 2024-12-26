# Aula 02 - Modelos Não-Lineares e com Excitação Não-Ideal

---

## Vídeo da Aula
[Vídeo da Aula 2](https://drive.google.com/file/d/1GA5p2ic9qS0woOMMq8SwWnHvDenq0OdQ/view)

---

- continuação: controle do caos
- não-linearidade: maior produção de energia

---

## 2. Modelo Não-Linear com Excitação Periódica
$\ddot{x} = \frac{1}{2}x (1-x^2) - 2\zeta \dot{x} + \chi v + f \cos\Omega t$

$\dot{v} = -\Lambda v - \kappa \dot{x}$

### Componente Não-Linear
$\frac{1}{2}x (1-x^2)$

```matlab
% Cálculo de Autovalores
clear
clc
format short

% Parâmetros:
c = 0.01;
x = 0.05;
k =	0.5;
l =	0.05;
f =	0.5;
w = 0.083;
t = 1;

% Jacobiano (Linearização)
syms y1 y2 y3;
f1= y2;
f2= (1/2)*y1*(1-y1^2)-2*c*y2+x*y3+f*cos(w*t);
f3= -k*y2-l*y3;
J = jacobian([f1; f2; f3], [y1 y2 y3]);

% Valores para linearização
y1=1;
y2=1;
y3=1;

% Autovalores
A=subs (J); 
A=double(A)
autovalor=eig(A)
```

```matlab
% saída:
autovalor =

  -0.0106 + 1.0123i
  -0.0106 - 1.0123i
  -0.0488 + 0.0000i

  % Sistema Estável
```

### Estabilidade do Sistema

- **Estável**: Se todos os autovalores têm partes reais negativas, o sistema retorna ao equilíbrio após uma perturbação.
- **Instável**: Se pelo menos um autovalor tem uma parte real positiva, o sistema tende a divergir do equilíbrio.
- **Marginalmente Estável**: Se os autovalores têm partes reais zero ou negativas, mas não todos são estritamente negativos, o sistema pode oscilar indefinidamente sem convergir ou divergir


### Espaço de Estados
$\dot{x_1} = x_2$
$\dot{x_2} = \frac{1}{2}x_1(1-x_1^2) - 2\zeta x_2 + \chi x_3 + f \cos \Omega t$
$\dot{x_3} = - \Lambda x_3 - \kappa x_2$
<br>

### Aplicando Runge-Kutta de quarta para os parâmetros:
- $\zeta = 0.01$
- $\Omega = 0.8$
- $\chi = 0.05$
- $\kappa = 0.5$
- $\Lambda = 0.05$
- $f = 0.083$

#### Condições iniciais:
- $x(0) = 1$
- $\dot{x}(0) = 0$
- $v(0) = 0$

```matlab
% arquivo: system_nao_linear_periodico

function yprime = system_nao_linear_periodico (t,y)
yprime=zeros(3,1);

% ===================== Parâmetros Realimentados ===================
c=  0.01;
x=  0.05;
k=  0.5;
l=  0.05;
f=  0.083; %Fixo
w = 0.8;  %0.4 a 0.9 (Parâmetro de Controle)

% ============================= State Space ========================
yprime(1)= y(2);
yprime(2)= (1/2)*y(1)*(1-y(1)^2)-2*c*y(2)+x*y(3)+f*cos(w*t);
yprime(3)= -k*y(2)-l*y(3);
```

```matlab
% arquivo: system_nao_linear_periodico_plot.

[t,y]=ode45(@system_nao_linear_periodico,[0:0.1:2500],[1 0 0]);
   h1=t;
   h2=y(:,1); % deslocamento da ponta da viga
   h3=y(:,2); % velocidade da ponta da viga
   h4=y(:,3); % tensão elétrica captada

      figure() %Deslocamento da Ponta da Viga
      plot(h1,h2,'k');
      set(gca,'fontsize',24);
      xlabel('Tempo [amostra]','fontsize',20);
      ylabel('Deslocamento da Ponta da Viga [taxa]','fontsize',20);

      figure() %Velocidade da Ponta da Viga
      plot(h1,h3,'k');
      set(gca,'fontsize',24);
      xlabel('Tempo [amostra]','fontsize',20);
      ylabel('Velocidade da Ponta da Viga [taxa]','fontsize',20);

      figure() %Tensão Elétrica Captada
      plot(h1,h4,'k');
      set(gca,'fontsize',24);
      xlabel('Tempo [amostra]','fontsize',20);
      ylabel('Tensão Elétrica Captada [taxa]','fontsize',20);

      figure() %3D retrato fase da Energia Cinética
      plot3(h1,h2,h3,'k');
      grid on;
      set(gca,'fontsize',24);
      xlabel('Tempo [amostra]','fontsize',18);
      ylabel('Deslocamento da Ponta da Viga [taxa]','fontsize',18); 
      zlabel('Velocidade da Ponta da Viga [taxa]','fontsize',18);

      figure() %Retrato de Fase da Energia Cinética
      plot(h2(20000:25000,:),h3(20000:25000,:),'k');
      set(gca,'fontsize',24);
      xlabel('Deslocamento da Ponta da Viga [taxa]','fontsize',18); 
      ylabel('Velocidade da Ponta da Viga [taxa]','fontsize',18);
      

%Cálculo da Potência
%P= (Vrms)^2/R
Pot_nao_linear_periodico=((rms(h4))^2)/0.1
```

##### Mudança nas condições iniciais no tempo 500:
$x(0) = 1$
$\dot{x}(1.3)=0$
$v(0) = 0$


```matlab
% arquivo: system_nao_linear_periodica_mudanca.m

[t,y]=ode45(@system_nao_linear_periodico,[0:0.1:500],[1 0 0]);
   h1=t;
   h2=y(:,1); %deslocamento da ponta da viga
   h3=y(:,2); %velocidade da ponta da viga
   h4=y(:,3); %tensão elétrica Captada

   [t,y]=ode45(@system_nao_linear_periodico,[500:0.1:2500],[1 1.3 0]);
   n1=t;
   n2=y(:,1); %deslocamento da Ponta da Viga
   n3=y(:,2); %Velocidade da Ponta da Viga
   n4=y(:,3); %Tensão Elétrica Captada

   o1=[h1;n1];
   o2=[h2;n2];
   o3=[h3;n3];
   o4=[h4;n4];
   
      figure() %Deslocamento da Ponta da Viga
      plot(o1,o2,'k');
      xlabel('Tempo [amostra]','fontsize',18);
      ylabel('Deslocamento da Ponta da Viga [taxa]','fontsize',18);
   
      figure() %Velocidade da Ponta da Viga
      plot(o1,o3,'k');
      xlabel('Tempo [amostra]','fontsize',18);
      ylabel('Velocidade da Ponta da Viga [taxa]','fontsize',18);
      
      figure() %Tensão Elétrica Captada
      plot(o1,o4,'k');
      xlabel('Tempo [amostra]','fontsize',18);
      ylabel('Tensão Elétrica Captada [taxa]','fontsize',18);
  
      figure() %Retrato de fase da Energia Cinética
      plot(o2(20000:25000,:),o3(20000:25000,:),'k');
      xlabel('Deslocamento da Ponta da Viga [taxa]','fontsize',18); 
      ylabel('Velocidade da Ponta da Viga [taxa]','fontsize',18);
      
      figure() %3D retrato fase da Energia Cinética
      plot3(o1,o2,o3,'k');
      grid on;
      xlabel('Tempo [amostra]','fontsize',18);
      ylabel('Deslocamento da Ponta da Viga [taxa]','fontsize',18); 
      zlabel('Velocidade da Ponta da Viga [taxa]','fontsize',18);
      
% Cálculo da Potência
%P= (Vrms)^2/R
Pot_nao_linear_periodico_muda=((rms(o4))^2)/0.1
```

---

## 3. Modelo Linear com Excitação Não-Ideal

$(m_1 + m_0)\ddot{\chi } + l\dot{\chi} + k\chi = m_0r(\dot{\varphi^2}\cos\varphi + \ddot{\varphi} \sin \varphi)$

$(I + m_0r^2)\ddot{\varphi} - m_0r\ddot{\chi}\sin\varphi = S(\dot{\varphi})$

$\dot{V} + \tau V + \delta \dot{\chi}=0$


### Equação Adimensionalizada
$\ddot{x} + 2\zeta\dot{x} + \frac{1}{2}x - \chi v = \mu(\dot{x^2} \cos z + \ddot{z} \sin z)$

$\ddot{z} = \xi\ddot{x} \sin z + \alpha - \beta\dot{z}$

$\dot{v} + \Lambda v + \kappa \dot{x} = 0$

### Espaço de Estados
$x = x_1; \dot{x_1} = x_2;  z = x_3, \dot{x_3} = x_4; v = x_5$

$\dot{x_1} = x_2$

$\dot{x_2} = \frac{-\frac{1}{2}x_1 - 2\zeta x_2 + \Chi x_5 + \mu x_4^2 \cos x_3 + (\alpha - \beta x_4) \mu \sin x_3}{1-\mu\xi(\sin x_3)^2}$

$\dot{x_3} = x_4$

$\dot{x_4} = \frac{(\frac{1}{2}x_1 - 2 \xi x_2 + \Chi x_5)\xi \sin x_3 + \mu \xi x_4 ^2 \cos x_3 \sin x_3 + \alpha - \beta x_4}{1 - \mu \xi(\sin x_3)^2}$

$\dot{x_5} = \kappa x_2 - \Lambda x_5$


```matlab
% arquivo: linear_nao_ideal.m

% Cálculo de Autovalores
clear all
clc 
format short

%Par�metros
c=0.01;
x=0.05;
k=0.5;
l=0.05;
m=0.2;
q=0.3;
a=5.0;
b=1.5;

%Jabobiano (Linearização)
syms y1 y2 y3 y4 y5;
f1= y2;
f2= ((-1/2)*y1-2*c*y2+x*y5+m*y4^2*cos(y3)+m*sin(y3)*(a-b*y4))/(1-m*q*((sin(y3))^2));
f3= y4;
f4= (q*sin(y3))*((-1/2)*y1-2*c*y2+x*y5)+m*q*(y4^2)*cos(y3)*sin(y3)+a-b*y4/(1-m*q*((sin(y3))^2));
f5= -l*y5-k*y2;
J = jacobian([f1; f2; f3; f4; f5], [y1 y2 y3 y4 y5]);

%Valores para linearização
y1=1;
y2=0;
y3=0;
y4=0;
y5=0;

%Autovalores
A=subs (J); A=double(A)
autovalor=eig(A)
```

```matlab
% saída:

A =

         0    1.0000         0         0         0
   -0.5000   -0.0200    1.0000         0    0.0500
         0         0         0    1.0000         0
         0         0   -0.1500   -1.5000         0
         0   -0.5000         0         0   -0.0500


autovalor =

  -0.0112 + 0.7244i
  -0.0112 - 0.7244i
  -0.0476 + 0.0000i
  -1.3923 + 0.0000i
  -0.1077 + 0.0000i
```

sistema Estável


```matlab
% arquivo: system_linear_nao_ideal.m

function yprime = system_linear_nao_ideal (t,z)
yprime=zeros(5,1);
% ========================== Parâmetros Realimentados ===================
c=  0.01;
x=  0.05;
k=  0.5;
l=  0.05;
m=  0.2;
q=  0.3;
b=  1.5;
a=  0.8; %0.5 a 5.0 (Par�metro de Controle)
% ============================= State Space ========================
yprime(1)= z(2);
yprime(2)= ((-1/2)*z(1)-2*c*z(2)+x*z(5)+m*z(4)^2*cos(z(3))+m*sin(z(3))*(a-b*z(4)))/(1-m*q*((sin(z(3)))^2));
yprime(3)= z(4);
yprime(4)= (q*sin(z(3)))*((-1/2)*z(1)-2*c*z(2)+x*z(5))+m*q*(z(4)^2)*cos(z(3))*sin(z(3))+a-b*z(4)/(1-m*q*((sin(z(3)))^2));
yprime(5)= -l*z(5)-k*z(2);
% ================================================================
```

```matlab
% arquivo: system_linear_nao_ideal_plot.m

%PLANO DE FASE 

[t,z]=ode45(@system_linear_nao_ideal,[0:0.1:2500],[1 0 0 0 0]);
   k1=t;
   k2=z(:,1); %deslocamento
   k3=z(:,2); %velocidade
   k4=z(:,3); 
   k5=z(:,4);
   k6=z(:,5);%tensão
   
      figure() %Deslocamento
      plot(k1,k2,'k')
      xlabel('Tempo [amostra]','fontsize',24);
      ylabel('Deslocamento [taxa]','fontsize',24);
      
      figure() %Velocidade
      plot(k1,k3,'k');
      xlabel('Tempo [amostra]','fontsize',24);
      ylabel('Velocidade [taxa]','fontsize',24);
      
      figure() %Tens�o
      plot(k1,k6,'k');
      xlabel('Tempo [amostra]','fontsize',24);
      ylabel('Tensão [taxa]','fontsize',24);

      figure() %3D Phase Portrait
      plot3(k1,k2,k3,'k');
      grid on;
      xlabel('Tempo [amostra]','fontsize',18);
      ylabel('Deslocamento [taxa]','fontsize',18); 
      zlabel('Velocidade [taxa]','fontsize',18);     
      
      figure() %Retrato de Fase
      plot(k2(20000:25000,:),k3(20000:25000,:),'k');
      xlabel('Deslocamento [taxa]','fontsize',24); 
      ylabel('Velocidade [taxa]','fontsize',24); 

      %Cálculo da Potência
%P= (Vrms)^2/R
Pot_linear_nao_ideal=((rms(k6))^2)/0.1
```
---


## 4. Modelo Não-Linear com Excitação Não-Ideal

$\ddot{x} + 2\zeta\dot{x} - \frac{1}{2}x(1 - x^2) - \Chi v = \mu (\dot{z^2}  \cos z + \ddot{z} \sin z) $

$\ddot{z} = \xi \ddot{x} \sin z = \alpha - \beta \dot{z}$

$\dot{v} + \Lambda v + k\dot{x} = 0$

### Espaço de Estados
Adotando:
$
x = x_1; \\
\dot{x} = x_2;\\
z = x_3; \\
\dot{x_3} = x_4; \\
v = x_5
$

$\dot{x_1} = x_2$

$\dot{x_2} = \frac{}{1 - \mu \xi(\sin x_3)^2}$

$\dot{x_3} = x_4$

$\dot{x_4} = \frac{}{1 - \mu \xi (\sin x_3)^2}$

$\dot{x_5} = -\kappa x_2 - \Lambda x_5$

```matlab
% arquivo: nao_linear_nao_ideal.m

% Cálculo de Autovalores
clear all
clc 
format short

%Parâmetros
c=0.01;
x=0.05;
k=0.5;
l=0.05;
m=0.2;
q=0.3;
a=5.0;
b=1.5;
  
%Jabobiano (Linearização)
syms y1 y2 y3 y4 y5;
f1= y2;
f2= ((1/2*y1*(1-y1^2))-2*c*y2+x*y5+m*y4^2*cos(y3)+m*sin(y3)*(a-b*y4))/(1-m*q*((sin(y3))^2));
f3= y4;
f4= (q*sin(y3))*((1/2*y1*(1-y1^2))-2*c*y2+x*y5)+m*q*(y4^2)*cos(y3)*sin(y3)+a-b*y4/(1-m*q*((sin(y3))^2));
f5= -l*y5-k*y2;
J = jacobian([f1; f2; f3; f4; f5], [y1 y2 y3 y4 y5]);

%Valores para linearização
y1=1;
y2=0;
y3=0;
y4=0;
y5=0;
  
%Autovalores
A=subs (J); A=double(A)
autovalor=eig(A)
```

```matlab
% saída:

A =

         0    1.0000         0         0         0
   -1.0000   -0.0200    1.0000         0    0.0500
         0         0         0    1.0000         0
         0         0         0   -1.5000         0
         0   -0.5000         0         0   -0.0500


autovalor =

  -0.0106 + 1.0123i
  -0.0106 - 1.0123i
  -0.0488 + 0.0000i
   0.0000 + 0.0000i
  -1.5000 + 0.0000i
```

Sistema no limiar da estabilidade


```matlab
% arquivo: system_nao_linear_nao_ideal.m

function yprime = system_nao_linear_nao_ideal (t,z)
yprime=zeros(5,1);
% ========================== Parâmetros Realimentados ===================
c=  0.01;
x=  0.05;
k=  0.5;
l=  0.05;
m=  0.2;
q=  0.3;
b=  1.5;
a=  4.0; %0.5 a 5.0 (Parâmetro de Controle)
% ============================= State Space ========================
yprime(1)= z(2);
yprime(2)= (((1/2)*z(1)*(1-z(1)^2))-2*c*z(2)+x*z(5)+m*z(4)^2*cos(z(3))+m*sin(z(3))*(a-b*z(4)))/(1-m*q*((sin(z(3)))^2));
yprime(3)= z(4);
yprime(4)= (q*sin(z(3)))*(((1/2)*z(1)*(1-z(1)^2))-2*c*z(2)+x*z(5))+m*q*(z(4)^2)*cos(z(3))*sin(z(3))+a-b*z(4)/(1-m*q*((sin(z(3)))^2));
yprime(5)= -l*z(5)-k*z(2);
% ================================================================
```

```matlab
% arquivo: system_nao_linear_nao_ideal_plot.m

%PLANO DE FASE 

[t,z]=ode45(@system_nao_linear_nao_ideal,[0:0.1:2500],[1 0 0 0 0]);
   k1=t;
   k2=z(:,1); %displacement
   k3=z(:,2); %velocity
   k4=z(:,3); 
   k5=z(:,4);
   k6=z(:,5); %Voltagem
  
%Cálculo da Potência
%P= (Vrms)^2/R
Pot_nao_linear_nao_ideal=((rms(k6))^2)/0.1

      figure() %Descolcamento
      plot(k1,k2,'k')
      xlabel('Tempo [amostra]','fontsize',24);
      ylabel('Deslocamento [taxa]','fontsize',24);

      figure() %Velocidade
      plot(k1,k3,'k');
      xlabel('Tempo [amostra]','fontsize',24);
      ylabel('Velocidade [taxa]','fontsize',24);

      figure() %Tensão
      plot(k1,k6,'k');
      xlabel('Tempo [amostra]','fontsize',24);
      ylabel('Tensão Elétrica Captada [taxa]','fontsize',24);

      figure() %3D Phase Portrait
      plot3(k1,k2,k3,'k');
      grid on;
      xlabel('Tempo [amostra]','fontsize',18);
      ylabel('Deslocamento [taxa]','fontsize',18); 
      zlabel('Velocidade [taxa]','fontsize',18);

      figure() %Retrato de Fase
      plot(k2(20000:25000,:),k3(20000:25000,:),'k');
      xlabel('Deslocamento [taxa]','fontsize',24); 
      ylabel('Velocidade [taxa]','fontsize',24); 
```