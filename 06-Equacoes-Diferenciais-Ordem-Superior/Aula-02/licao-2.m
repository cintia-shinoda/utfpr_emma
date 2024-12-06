function x_ponto=licao2(t,x)
x_ponto=[0;0]; %valores iniciais para solução numérica
x_ponto(1)=x(2);
x_ponto(2)=-2*x(2)-x(1);