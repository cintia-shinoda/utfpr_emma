%PLANO DE FASE 

clear
clc
format short

[t,y]=ode45(@system_nao_linear_periodico,[0:0.1:500],[1 0 0]);
   h1=t;
   h2=y(:,1); %deslocamento da ponta da viga
   h3=y(:,2); %Velocidade da ponta da viga
   h4=y(:,3); %Tens�o El�trica Captada

   [t,y]=ode45(@system_nao_linear_periodico,[500:0.1:2500],[1 1.3 0]);
   n1=t;
   n2=y(:,1); %deslocamento da Ponta da Viga
   n3=y(:,2); %Velocidade da Ponta da Viga
   n4=y(:,3); %Tens�o El�trica Captada

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
      
      figure() %Tens�o El�trica Captada
      plot(o1,o4,'k');
      xlabel('Tempo [amostra]','fontsize',18);
      ylabel('Tens�o El�trica Captada [taxa]','fontsize',18);
  
      figure() %Retrato de fase da Energia Cin�tica
      plot(o2(20000:25000,:),o3(20000:25000,:),'k');
      xlabel('Deslocamento da Ponta da Viga [taxa]','fontsize',18); 
      ylabel('Velocidade da Ponta da Viga [taxa]','fontsize',18);
      
      figure() %3D retrato fase da Energia Cin�tica
      plot3(o1,o2,o3,'k');
      grid on;
      xlabel('Tempo [amostra]','fontsize',18);
      ylabel('Deslocamento da Ponta da Viga [taxa]','fontsize',18); 
      zlabel('Velocidade da Ponta da Viga [taxa]','fontsize',18);
      

%C�lculo da Pot�ncia
%P= (Vrms)^2/R
Pot_nao_linear_periodico_muda=((rms(o4))^2)/0.1
      