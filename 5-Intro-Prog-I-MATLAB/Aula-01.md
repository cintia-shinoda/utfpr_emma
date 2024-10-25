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

- transposta:
```matlab
transpose(v)
```
ou 
```matlab 
v' 
```

1h39min