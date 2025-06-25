library(readxl)
ONU <- read_excel("ONU.xlsx")
attach(ONU)
padronizadas <- scale(ONU[,2:5])
# "euclidean", "maximum", "manhattan", "canberra", "binary", "minkowski"
d <- dist(ONU[,2:5], method="euclidean"); round(d,2)  # calcula as distâncias
# "ward.D", "ward.D2", "single", "complete", "average" (= UPGMA), "mcquitty" (= WPGMA), "median" (= WPGMC), "centroid" (= UPGMC).
agrupamentos<-hclust(d, "ward.D") # Formação dos grupos
plot(agrupamentos,ylab='Distância', hang=-1, main = "Dendrograma") # Dendrograma
library(dendextend)
dend1<-as.dendrogram(agrupamentos,ylab='Distância', hang=-1) # Dendograma
grafico <- color_branches(dend1, k=4, groupLabels = TRUE);  plot(grafico)