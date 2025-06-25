# Aula 2

## Módulo 4 - Análise Fatorial

### Leitura Complementar
Leitura do Capítulo 7 do livro: MANLY, Bryan F J.; ALBERTO, Jorge A N. Métodos estatísticos multivariados: uma introdução. Porto Alegre: Grupo A, 2019.



### Exemplo no R
```r
# ANÁLISE FATORIAL
# ENTRADA DOS DADOS
# Se houver diferencas de escalas e/ou de grandezas, usar dados padronizados
library(readxl)
aceitacao <- read_excel("aceitacao.xlsx")
dados <- aceitacao[,2:8]
summary(dados)            # resumo numérico
S <- cov(dados); print(S, digits=2)       # matriz de covariâncias
R <- cor(dados); print(R, digits=2)       # matriz de correlações
#   VIABILIDADE DA ANALISE FATORIAL
# Teste de esfericidade de Bartlett  - H0: R = I
# Se Tcalc maior ou igual a T_95 rejeita-se H0, ao nível de significância de 5%
n <- nrow(dados);           # total de observações
p <- ncol(dados);             # total de variáveis
auto <- eigen(R); print(auto, digits=2)     # autovalores e autovetores da matriz de correlações
a <- log(auto$values);      
UM <- cbind(rep(1,p));
lambda = a%*%UM;
Tcalc = -(n-(1/6)*(2*p+11))*(lambda);  Tcalc # estatística calculada
gl=(1/2)*p*(p-1);
T_95 <- qchisq(0.95,gl); T_95  # estatística teórica
# Medida de adequação amostral KMO
# quanto mais próximo de 1 maior a adequação
# se KMO < 0,6, então a amostra é inadequada
# função para obter as correlações parciais
partial.cor <- function (X, ...)
{
  R <- cor(X, ...)
  RI <- solve(R)
  D <- 1/sqrt(diag(RI))
  Rp <- -RI * (D %o% D)
  diag(Rp) <- 0
  rownames(Rp) <- colnames(Rp) <- colnames(X)
  Rp
}
matcorp <- partial.cor(dados);  # matriz das correlações parciais
idiag <- seq(1, by = p + 1, length = p);
somar2 <- sum((as.numeric(R)[-idiag])^2);
cat("\n KMO = ",somar2 / (somar2 + sum((as.numeric(matcorp)[-idiag])^2)))
# SELEÇÃO DO NÚMERO DE FATORES
# Análise Paralela de Horn - APH
Rep <- 1000;
Cent <- 0.95;
library(nFactors);      # Carrega o pacote que possui a função "parallel"
ap <- parallel(subject=n,var=p,rep=Rep,cent=Cent);
apAutovet <- ap$eigen;
results <- nScree(eig = auto$values,aparallel=apAutovet$qevpea); results  # resultado da APH
# Gráfico Scree Plot e resultados da APH
plotnScree(results,legend = TRUE,ylab = "Autovalores",xlab = "Fatores",
           main = "")
#INSERIR O NÚMERO DE FATORES DESEJADO
k <- 2
# ANÁLISE FATORIAL - abordagem por componentes principais 
an.fat.acp <- prcomp(dados, scale = TRUE, rank. = k, retx = TRUE)
summary(an.fat.acp)
carfat <- an.fat.acp$rotation[, 1:k] %*% diag(an.fat.acp$sdev[1:k])
colnames(carfat) <- paste("Fator", 1:k, sep = " "); print(carfat, digits=2)
carfatr <- varimax(carfat); print(carfatr, digits=2)
plot(carfat, pch = 20, col = "red", xlab = "Fator 1", ylab = "Fator 2")
text(carfat, rownames(carfat), adj = 1)
plot(carfatr$loadings, pch = 20, col = "red", xlab = "Fator 1", ylab = "Fator 2")
text(carfatr$loadings, rownames(carfat), adj = 1)
comunalidade <- rowSums(carfat^2)
varespec <- diag(R) - comunalidade
estimat <- cbind(comunalidade, varespec, diag(R))
rownames(estimat) <- colnames(dados)
colnames(estimat) <- c("Comunalidade", "Variância única", "Variância")
print(estimat, digits=2)
escores.f1 <- an.fat.acp$x[, 1]; print(escores.f1, digits=2)
escores.f2 <- an.fat.acp$x[, 2]; print(escores.f2, digits=2)
```