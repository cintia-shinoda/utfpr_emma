# Aula 02 - Modelos Não-Lineares e com Excitação Não-Ideal

---

## Vídeo da Aula
[Vídeo da Aula 2](https://drive.google.com/file/d/1GA5p2ic9qS0woOMMq8SwWnHvDenq0OdQ/view)

---

- continuação: controle do caos

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

$(m_1 + m_0)\ddot{\Chi} + l\dot{\Chi} + k\Chi = m_0r(\dot{\varphi^2}\cos\varphi + \ddot{\varphi} \sin \varphi)$

$(\Iota + m_0r^2)\ddot{\varphi} - m_0r\ddot{\Chi}\sin\varphi = S(\dot{\varphi})$

$\dot{V} + \tau V + \delta \dot{\Chi}=0$


47