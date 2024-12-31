# Parte 1: Revisão de Programação Linear

## 1.1 - Introdução

### O que é Otimização?
- encontrar a melhor solução, considerando um conjunto de restrições
- objetivo: Maximizar ou Minimizar uma função objetivo, que representa a qualidade da solução
- Tipos:
    - Maximizar Lucro
    - Minimizar Custos
    - Alocação de Recursos

### Modelagem em Programação Linear
- técnica matemática para otimizar problemas com relações lineares entre as variáveis e a função objetivo

---

### Questionário sobre PL
1. A função objetivo de um problema de PL pode ser não-linear: FALSO

2. A função objetivo em um problema de PL sempre busca maximizar o lucro: FALSO

3. Selecione a melhor descrição para cada componente:
a. São os valores desconhecidos que queremos determinar: ```Variáveis de Decisão```
b. É uma equação linear que relaciona as variáveis de decisão ao objetivo: ```Função Objetivo```
c. Representam as limitações e exigências do problema: ```Restrições```
d. Expressa matematicamente o objetivo a ser otimizado: ```Função Objetivo```
e. Representam as decisões que precisam ser tomadas: ```Variáveis de Decisão```
f. São inequações lineares que as variáveis de decisão devem satisfazer: ```Restrições```

---


## 1.2 - Formulação de um PPL

### Elementos da Modelagem em PL
#### Variáveis de Decisão
- representação das decisões a serem tomadas
- valores desconhecidos a serem determinados

#### Função Objetivo
- expressa matematicamente o objetivo a ser otimizado
- equação linear que relaciona as variáveis de decisão ao objetivo

#### Restrições
- limitações e exigências do problema
- inequações lineares que as variáveis de decisão devem satisfazer

---


## 1.3 - Solução pelo Método Gráfico

### Solução Gráfica de Problemas de PL
- abordagem visual para problemas com duas variáveis de decisão (plano cartesiano)
- permite entender a geometria do problema e encontrar a solução ótima intuitivamente

#### Passos para representar as Restrições:
1 - transformar as inequações em equações
2 - encontrar pontos de intersecção com os eixos
3 - traçar a reta que passa pelos pontos de intersecção
4 - identificar a área que satisfaz a inequação original

##### Região Factível
- área onde todas as restrições são satisfeitas simultaneamente
- é a intersecção das áreas sombreadas de cada restrição
- representa o conjunto de soluções viáveis para o problema

#### Passos para representar a Função Objetivo
1 - escolher um valor arbitrário para a função objetivo (Z)
2 - substituir Z na equação da função objetivo
3 - encontrar os pontos de intersectação com os eixos
4 - traçar a reta que passa pelos pontos de intersecção
5 - mover a reta paralelamente, aumentando ou diminuindo o valor de Z, até encontrar a solução ótima
    - o ponto mais distante da origem = em problemas de maximização
    - ponto mais próximo da origem = em problemas de minimização

#### Limitações da Solução Gráfica
- torna-se complexa e inviável para problemas com mais de duas variáveis de decisão
- para problemas maiores, utiliza-se métodos algébricos e computacionais

---

### Questionário sobre formulação de PPL e Método Gráfico



---

## 1.4 - Método Simplex
- procedimento algébrico iterativo para solucionar problemas de PL
- busca a solução ótima movendo-se entre soluções básicas factíveis (SBF) adjacentes com melhor valor na função objetivo
- desenvolvido por George Dantzig, 1947
- aplicável a problemas de grande porte
- presente em softwares amplamente disponíveis

### Pré-requisitos
#### Problema na forma padrão
- função objetivo de maximização ou minimização
- restrições como equações de igualdade
- variáveis não-negativas

### Etapas
#### 1 -  Encontrar uma Solução Básica Factível inicial
- em restrições $\le$: atribuir zero às variáveis de decisão e usar variáveis de folga como básicas
- restrições de igualdade ou $\ge$: usar variáveis artificiais na função objetivo
    - Método das Penalidades (Big M): alto custo (M) para variáveis artificiais na função objetivo
    - Método das Duas Fases:
        - Fase 1: minimizar a soma das variáveis artificiais
        - Fase 2: otimizar a função objetivo original com a Solução Básica Factível encontrada na Fase 1
#### 2 - Teste de Otimalidade
- Maximização: SBF ótima se os coeficientes das variáveis não-básicas na linha 0 não são negativos ( $\ge0$ )
- Minimização: SBF ótima se coeficientes das variáveis não-básicas na linha 0 são positivos ( $\le0$ )

#### 3 - Iteração (SBF adjacente melhor)
- variável não básica que entra na base:
    - Maximização: maior coeficiente negativo na linha 0
    - Minimização: maior coeficiente positivo na linha 0
- variável básica que sai da base: limita o crescimento da variável que entra, mantendo a factibilidade
- transformar a tabela (Gauss-Jordan): Calcular a nova SBF
- repetir passos 2 e 3 até a solução ótima

### Casos Especiais
- Múltiplas soluções ótimas: Coeficiente zero na linha 0 para uma variável não-básica na tabela ótima
- Função objetivo ilimitada: Variável não básica não pode entrar na base (coeficientes não positivos na maximização, não negativos na minimização)
- Infactibilidade: variável artificial positiva na solução final (métodos Big M ou Duas Fases)
- Solução degenerada: variável básica com valor zero em uma solução

---
## Questionário sobre o Método Simplex



---

## 1.5 - Solver e Considerações dos PPLIs

### PL x PLI
- representar decisões discretas
- modelar decisões do tipo "sim" ou "não"
    - usa-se variáveis binárias (0 ou 1) para representar escolhas
- representar relações lógicas completas

#### Tipos de Variáveis Inteiras
- variáveis inteiras
- variáveis binárias


- Programação Inteira Pura
- Programação Inteira Lista
- Programação Binária

#### Complexidade da PLI
- Dificuldade Computacional
- Explosão Combinatória

####
- Métodos Exatos
- Métodos Heurísticos e Meta-heurísticas

---

## Questionário sobre o Solver do Excel