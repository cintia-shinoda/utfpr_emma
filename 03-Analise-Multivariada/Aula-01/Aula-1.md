#





## Módulo 1 - Vetores Aleatórios

### Leitura Complementar
Leitura das seções 2.6 e 2.7 do livro: MANLY, Bryan F J.; ALBERTO, Jorge A N. Métodos estatísticos multivariados: uma introdução. Porto Alegre: Grupo A, 2019



--- 

## Módulo 2 - Estimação de Parâmetros em Distribuições Multivariadas

### Leitura Complementar
Leitura do Capítulo 2 do livro: MINGOTI, S. A. Análise de Dados Através de Métodos de Estatística Multivariada: Uma Abordagem Aplicada. Belo Horizonte: UFMG, 2005. ISBN 9788570414519


---

## Módulo 3 - Análise de Componentes Principais

### Leitura Complementar
Leitura do Capítulo 6 do livro: MANLY, Bryan F J.; ALBERTO, Jorge A N. Métodos estatísticos multivariados: uma introdução. Porto Alegre: Grupo A, 2019. 


### Exemplo no R
```r
# AULA 1 - conceitos iniciais

# Importar previamente a planilha de dados "coxinha.xlsx"
library(readxl)
coxinha <- read_excel("coxinha.xlsx")
summary(coxinha) # resumo numérico
S <- cov(coxinha); S     # matriz de covariâncias
R <- cor(coxinha); R     # matriz de correlações
plot(coxinha)            # gráficos de dispersão
D <- eigen(S)            # decomposição da matriz de covariâncias
sum(D$values)            # variância total
det(S)                   # variância generalizada
sqrt(det(S))             # desvio-padrão generalizado
D$values                 # autovalores
D$vectors                # autovetores

# COMPONENTES PRINCIPAIS
# Se as variâncias forem muito diferentes devemos padronizar, fazendo scale = TRUE 
# Para escolher a quantidade de componentes usar rank. = nº desejado
ACP <- prcomp(coxinha, scale = FALSE, rank. = 2, retx = TRUE); ACP   # extrai as componentes
summary(ACP)          # desvio-padrão e representatividade das componentes
plot(ACP)             # gráfico dos autovalores
biplot(ACP)           # gráfico das duas primeiras componentes
# Ordenação das marcas - ranking, pela CP1
escores1 <- ACP$x[, 1]
names(escores1) <- c("M1", "M2", "M3", "M4", "M5", "M6", "M7", "M8")
ordem <- order(escores1, decreasing = TRUE)
barplot(escores1[ordem], ylab = "Escore da primeira componente", las = 2)
box() 
```