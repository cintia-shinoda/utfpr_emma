# Aula 03 - Análise do Caos

---

## Vídeo da Aula
[Vídeo da Aula 3](https://drive.google.com/file/d/1ve_jAfX3d-blyU651ul8fHeLRDTCqyMp/view)

---

## Expoentes de Lyapunov - $\lambda$
- medidas que quantificam a **taxa de separação das trajetórias** infinitesimalmente próximas em um sistema dinâmico.

- usados para **caracterizar o comportamento caótico** dos sistemas, onde pequenas diferenças nas condições iniciais podem levar a grandes divergências no comportamento ao longo do tempo.

- gera um expoente para cada equação do sistema
<br>

### Interpretação
- se um dos $\lambda > 0$, o **sistema é caótico** (uma pequena perturbação introduzida, gera mudança significativa)
- se todos os $\lambda < 0,$ **o sistema é atrativo**, convergindo para um ponto fixo
- se algum dos $\lambda = 0$, o sistema pode ter órbitas periódicas ou comportamento de **limiar de caos**.

### Passos para o cálculo:

1. Linearização do sistema
- $\delta x$ = pequena perturbação
- Jacobiana: $J(x)$
- evolução de $\delta x$ pode ser descrita pela equação de variacionais:
$J(x) = \dfrac{\partial f}{\partial x}$
2. Medição da taxa de expansão ou contração
- cálculo da norma de $\delta x$
3. Cálculo do Expoente de Lyapunov: $\lambda$
- usando a seguinte equação: $\frac{dx + \epsilon \nu}{dt} = f(x + \epsilon \nu)$
- onde: $\epsilon$ = perturbação na variável dependente $v$ 
- Lyapunov afirma: $\nu(t) = e^{\lambda t}$

### Implementações do Algoritmo
- 1985: detalhado no artigo de Alan Wolf em Fortran
- 2004: Govorukhin V.N. em MATLAB

#### Algoritmo de Govorukhin V.N. em MATLAB

```matlab
% Copyright (C) 2004, Govorukhin V.N.
% This file is intended for use with MATLAB and was produced for MATDS-program
% http://www.math.rsu.ru/mexmat/kvm/matds/
% lyapunov.m is free software. lyapunov.m is distributed in the hope that it 
% will be useful, but WITHOUT ANY WARRANTY. 
%
%
%       n=number of nonlinear odes
%       n2=n*(n+1)=total number of odes
%

n1=n; 
n2=n1*(n1+1);

%  Number of steps
nit = round((tend-tstart)/stept);

% Memory allocation 
y=zeros(n2,1); cum=zeros(n1,1); y0=y;
gsc=cum; znorm=cum;

% Initial values
y(1:n)=ystart(:);
for i=1:n1 y((n1+1)*i)=1.0; end;
t=tstart;

% Main loop
for ITERLYAP=1:nit

% Solutuion of extended ODE system 
  [T,Y] = feval(fcn_integrator,rhs_ext_fcn,[t t+stept],y);  
  
  t=t+stept;
  y=Y(size(Y,1),:);
  for i=1:n1 
      for j=1:n1 y0(n1*i+j)=y(n1*j+i); end;
  end;

%
%       construct new orthonormal basis by gram-schmidt
%
  znorm(1)=0.0;
  for j=1:n1 znorm(1)=znorm(1)+y0(n1*j+1)^2; end;
  znorm(1)=sqrt(znorm(1));
  for j=1:n1 y0(n1*j+1)=y0(n1*j+1)/znorm(1); end;
  for j=2:n1
      for k=1:(j-1)
          gsc(k)=0.0;
          for l=1:n1 gsc(k)=gsc(k)+y0(n1*l+j)*y0(n1*l+k); end;
      end;
 
      for k=1:n1
          for l=1:(j-1)
              y0(n1*k+j)=y0(n1*k+j)-gsc(l)*y0(n1*k+l);
          end;
      end;
      znorm(j)=0.0;
      for k=1:n1 znorm(j)=znorm(j)+y0(n1*k+j)^2; end;
      znorm(j)=sqrt(znorm(j));
      for k=1:n1 y0(n1*k+j)=y0(n1*k+j)/znorm(j); end;
  end;
%
%       update running vector magnitudes
%
  for k=1:n1 cum(k)=cum(k)+log(znorm(k)); end;
%
%       normalize exponent
%
  for k=1:n1 
      lp(k)=cum(k)/(t-tstart); 
  end;
% Output modification
  if ITERLYAP==1
     Lexp=lp;
     Texp=t;
  else
     Lexp=[Lexp; lp];
     Texp=[Texp; t];
  end;
  if (mod(ITERLYAP,ioutp)==0)
     fprintf('t=%6.4f',t);
     for k=1:n1 fprintf(' %10.6f',lp(k)); end;
     fprintf('\n');
  end;
  for i=1:n1 
      for j=1:n1
          y(n1*j+i)=y0(n1*i+j);
      end;
  end;
end;
  ```

  ##### Parâmetros de entrada:
  - `n` = number of equations
  - `rhs_ext_fcn` = handle of function with right hand side of extended ODE-system.
  This function must include RHS of ODE-system coupled with variational equation (n items of linearized systems)
  - `fnc_integrator` = handle of ODE integrator function, for example: `@ode45`
  - `tstart` = start values of independent value (time t)
  - `stept`= step on t-variable for Gram-Schmidt renormalization procedure.
  - `tend` = finish value of time
  - `ystart` = start point of trajectory of ODE system
  - `ioutp` = step of print to MATLAB main window. ioutp==0 - no print, if ioutp>0 then each ioutp-th point will be printed.

  ##### Parâmetros de saída:
  - `Texp` = time values
  - `Lexp` = Lyapunov exponents to each time value


  ### Exemplo para função de Lorenz
```matlab
function f=lorenz_ext(t,X)
%
%  Lorenz equation 
%
%               dx/dt = SIGMA*(y - x)
%               dy/dt = R*x - y -x*z
%               dz/dt= x*y - BETA*z
%
%        In demo run SIGMA = 10, R = 28, BETA = 8/3
%        Initial conditions: x(0) = 0, y(0) = 1, z(0) = 0;
%        Reference values for t=10 000 : 
%              L_1 = 0.9022, L_2 = 0.0003, LE3 = -14.5691
%
%        See:
%    K. Ramasubramanian, M.S. Sriram, "A comparative study of computation 
%    of Lyapunov spectra with different algorithms", Physica D 139 (2000) 72-86.
%
% --------------------------------------------------------------------
% Copyright (C) 2004, Govorukhin V.N.
% Values of parameters
SIGMA = 10;
R = 28;
BETA = 8/3;
x=X(1); y=X(2); z=X(3);
Y= [X(4), X(7), X(10);
    X(5), X(8), X(11);
    X(6), X(9), X(12)];
f=zeros(9,1);
%Lorenz equation
f(1)=SIGMA*(y-x);
f(2)=-x*z+R*x-y;
f(3)=x*y-BETA*z;
%Linearized system
 Jac=[-SIGMA, SIGMA,     0;
         R-z,    -1,    -x;
           y,     x, -BETA];
  
%Variational equation   
f(4:12)=Jac*Y;
%Output data must be a column vector
```

