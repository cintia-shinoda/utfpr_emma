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
      
      figure() %Tensão
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