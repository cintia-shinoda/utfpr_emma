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