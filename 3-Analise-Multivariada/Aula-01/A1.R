## Módulo 1 - Vetores Aleatórios

### 1.1 - Variável Aleatória

### 1.2 - Vetor Aleatório

### 1.3 - Vetor de médias

### 1.4 - Variância e Desvio Padrão

fornece informação sobre a dispersão dos valores da variável em relação à respectiva média

### 1.5 - Covariâncias

grau de relacionamento linear entre duas variáveis

quanto menor em módulo (mais próximo a zero) = as variáveis estão menos associadas -> variáveis independentes

negativa: variam em sentidos opostos

matriz simétrica 

#### 1.5.1 - Variância Total

soma dos elementos da diagonal principal da matriz de Covariâncias

#### 1.5.2 - Variância Generalizada

raiz quadrada do determinante da matriz de covariâncias

### 1.6 - Correlação

relacionamento linear entre duas variáveis

valor em módulo, quanto mais próximo de 1, maior a associação entre as variáveis

varia de -1 a 1

linear de Pearson

diagonal da matriz = 1

### 1.7 - Teorema da decomposição espectral

obter matrizes que multiplicadas originam a matriz de covariâncias ( $\Sigma$ )

matriz ortogonal: multiplicada por ela mesmma na forma transposta, resulta na matriz identidade (diagonal principal composta por 1, o restante por 0)

#### 1.7.1 - autovalores: 
- diagonal principal
são ordenados em ordem decrescente
- $\lambda$
  
  #### 1.7.2 - autovetor (ou vetor característico)
  - associado a cada $\lambda$
  - colunas da matriz O

```{r} 
# Exemplo


```

```{r}
# Importação dos dados

#install.packages("readxl")
library(readxl)

coxinha <- read_excel("coxinha.xlsx")

summary(coxinha) # resumo numérico
```

```{r}
# Matriz de Covariâncias Amostral (S)

S <- cov(coxinha)
S
```

```{r}
# Matriz de Correlações

R <- cor(coxinha)
R

```

```{r}
# Gráficos de Dispersão
plot(coxinha)
```

```{r}
# Decomposição da Matriz de Covariâncias

D <- eigen(S)
sum(D$values)  #variância total (soma das variâncias)
```

```{r}
# Variância Generalizada

det(S)
```

```{r}
# Desvio-Padrão Generalizado

sqrt(det(S))
```

```{r}
# Autovalores

D$values
```

```{r}
# Autovetores

D$vectors
```


<br>
  <br>
  <br>
  
  ---
  ## Módulo 2 - Estimação de Parâmetros em Distribuições Multivariadas
  
  
  
  ## Módulo 3 - Análise de Componentes Principais