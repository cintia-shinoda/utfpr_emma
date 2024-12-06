## Aula 01 - 24/08/2024

---

### Bibliografia:

- CHAPMAN, S. J. **Programação em MATLAB para engenheiros**. São Paulo: Cengage Learning, 2018. ISBN 9788522125227.
- MATSUMOTO, É. Y. **Matlab R2013a : teoria e programação: guia prático**. São Paulo: Erica, 2013. ISBN 9788536504681.
- CHAPRA, S. C. **Métodos numéricos aplicados com matlab® para engenheiros e cientistas**. Porto Alegre: AMGH, 2013. ISBN 9788580551778.
- MICHAEL WEEKS. **Programming Fundamentals Using MATLAB**. Dulles, Virginia: Mercury Learning & Information, 2020. ISBN 9781683925538.
- PALM III, W. J. **Introdução ao matlab para engenheiros**. Porto Alegre: AMGH, 2014. ISBN 9788580552058. Acesso em: 18 maio. 2023.

---

### Vídeo da Aula
[Vídeo da Aula 1](https://drive.google.com/file/d/1Lnf5kybGmkdtiZWulmc3ni2f8uB2D4tP)


---

```clc```   = limpar a janela de comandos
```clear``` = limpar as variáveis
```help``` = acessar documentação
CONTROL + C = parar de rodar

case sensitive

nomes de variáveis:
- sem espaços
- não começar com números
- não pode ter caracteres especiais (exceto underscore)


ans = variável para respostas que não foram atribuídas a nenhuma variável

```size(a)```  = número de dimensões

```a = rand(3)``` = cria uma matriz randômica 3x3

notação científica
números complexos: variáveis ```i``` e ```j```
```;``` no final da atribuição em que não se queira exibir o resultado logo abaixo

```pi```
```Inf``` variável infinito (é maior que ```realmax```)
```NaN``` Not a Number

- criação de matriz:
```matlab
A = [1 2 3 ; 4 5 6 ; 7 8 9]
```

- criação de vetor:
```matlab
v = [6 ; 15 ; 2]
```

- transposição:
```matlab
transpose(v)
```
ou 
```matlab 
v' 
```

- soma de matrizes
```matlab
A + B
```

```matlab
A - B
```

- multiplicação
```matlab
A * B
```

- divisão
```matlab
x = B \ v
```

- potenciação
```matlab
A ^ 2
```

- precedência de operadores

- concatenação
```matlab
C = [A v]
```

estruturas de dados um pouco mais complexas::
- table
- struct
- cell

```matlab
syms = cria variáveis simbólicas
```

- indexação
```matlab
A(2, 1)    % retorna 2ª linha, 1ª coluna da matriz A
A(2,1) = 4.1   % atribui 4.1 à 2ª linha, 1ª coluna da matriz A
```

- slicing
```matlab
A(1, :)    % retorna a 1ª linha inteira da matriz A
```

```matlab
w = 0:0.2:1   % cria um vetor de 0 a 1 com passo 0.2
```

```matlab
w = linspace(0,1,20)   % cria um vetor de 0 a 1 com 20 elementos
```

- determinante
```matlab
det(A)  % determinante da matriz A
```

- identidade
```matlab
A = eye(3)   % matriz identidade 3x3
```

- inversa
```matlab
A2 = inv(A)   % inversa da matriz A (inversa é a matriz que multiplicada pela matriz original resulta na matriz identidade)
```

- funções anônimas (functions handles) 
= funções definidas de forma algébrica
```matlab
f = @(x) (x^2)   % cria uma função f(x) = x^2

f(3)             % retorna 9
```

```matlab
whos  % exibe todas as variáveis criadas
```

#### Funções Matemáticas
##### Trigonométricas
```matlab
sin(x)  % seno
asin(x) % arco seno
sinh(x) % seno hiperbólico
cos(x)  % cosseno
tan(x)  % tangente
cot(x)  % cotangente
sec(x)  % secante
csc(x)  % cossecante
```

##### Exponenciais e Logarítmicas
```matlab
exp(x)   % exponencial
log(x)   % logaritmo natural (ln, logaritmo na base e)
log10(x) % logaritmo na base 10
sqrt(x)  % raiz quadrada
e = exp(1) % número de Euler
```

##### Arredondamento
```matlab
fix(x)    % arredonda para o inteiro mais próximo
mod(x, y) % resto da divisão de x por y
round(x)  % arredonda para o inteiro mais próximo
ceil(x)   % arredonda para cima
floor(x)  % arredonda para baixo
```