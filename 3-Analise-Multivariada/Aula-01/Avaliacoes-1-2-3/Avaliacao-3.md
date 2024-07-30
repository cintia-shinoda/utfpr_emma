Avaliação 3 - Anáise de Componentes Principais
================

<br> <br>

Apresente e comente em detalhes os resultados.

Na avaliação serão consideradas a exatidão dos resultados, a coerência e
a correção das interpretações.

As respostas devem ser registradas exclusivamente na sequência do
enunciado do problema.

Para entregar, salve o arquivo em formato PDF. <br> <br>

Para resolver o problema a seguir, use como base os conteúdos abordados
nas aulas, os materiais suplementares e utilize o apoio do software R.
<br> <br>

A Tabela 6.7 mostra estimativas do consumo médio de proteínas de
diferentes fontes de alimentos para os habitantes de 25 países europeus
como publicado por Weber (1973).

1.  Obtenha e interprete a matriz de covariâncias.

2.  Obtenha e interprete a matriz de correlações.

3.  Aplique a análise de componentes principais para investigar o
    relacionamento entre os países com base nestas variáveis.

4.  Interprete as duas primeiras componentes obtidas.

``` r
data <- data.frame(
  Carne_Vermelha = c(10, 9, 14, 8, 10, 11, 8, 10, 18, 10, 5, 14, 9, 10, 9, 7, 6, 6, 7, 10, 13, 17, 9, 11, 4),
  Carne_Branca = c(1, 14, 9, 6, 11, 11, 12, 5, 10, 3, 12, 10, 5, 14, 5, 10, 4, 6, 3, 8, 10, 6, 5, 13, 5),
  Ovos = c(1, 4, 4, 2, 3, 4, 4, 3, 3, 3, 3, 5, 3, 4, 3, 3, 1, 2, 3, 4, 3, 5, 2, 4, 1),
  Leite = c(9, 20, 18, 8, 13, 25, 11, 34, 20, 18, 10, 26, 14, 23, 23, 19, 5, 11, 9, 25, 24, 21, 17, 19, 10),
  Peixe = c(0, 2, 5, 1, 2, 10, 5, 6, 6, 6, 0, 2, 3, 3, 10, 3, 14, 1, 7, 8, 2, 4, 3, 3, 1),
  Cereais = c(42, 28, 27, 57, 34, 22, 25, 26, 28, 42, 40, 24, 37, 22, 23, 36, 27, 50, 29, 20, 26, 24, 44, 19, 56),
  Carboidratos = c(1, 4, 6, 1, 5, 5, 7, 5, 5, 2, 4, 6, 2, 4, 5, 6, 6, 3, 6, 4, 3, 5, 6, 5, 3),
  Graos = c(6, 1, 2, 4, 1, 1, 1, 1, 2, 8, 5, 2, 4, 2, 2, 2, 5, 5, 6, 1, 2, 3, 3, 2, 6),
  Frutas_Vegetais = c(2, 4, 4, 4, 4, 2, 4, 1, 7, 7, 4, 3, 7, 4, 3, 7, 8, 3, 7, 2, 5, 3, 3, 4, 3)
)

rownames(data) <- c("Albania", "Austria", "Belgica", "Bulgaria", "Tchecoslovaquia", "Dinamarca", "Alemanha_Ocidental", "Finlandia", "Franca", "Grecia", "Hungria", "Irlanda", "Italia", "Paises_Baixos", "Noruega", "Polonia", "Portugal", "Romenia", "Espanha", "Suecia", "Suica", "Reino_Unido", "URSS", "Alemanha_Oriental", "Iugoslavia")
```

</br> </br>

1.  

``` r
# Matriz de Covariâncias

matriz_cov <- cov(data)
matriz_cov
```

    ##                 Carne_Vermelha Carne_Branca       Ovos      Leite       Peixe
    ## Carne_Vermelha      11.5833333     2.400000  2.1833333  13.141667   0.7666667
    ## Carne_Branca         2.4000000    13.993333  2.5066667   7.898333  -2.5600000
    ## Ovos                 2.1833333     2.506667  1.2433333   4.851667   0.1850000
    ## Leite               13.1416667     7.898333  4.8516667  50.376667   4.0016667
    ## Peixe                0.7666667    -2.560000  0.1850000   4.001667  12.0433333
    ## Cereais            -19.1000000   -18.098333 -8.6100000 -46.301667 -19.7600000
    ## Carboidratos         0.8666667     2.071667  0.7616667   2.520000   2.5200000
    ## Graos               -2.8166667    -5.076667 -1.3400000  -8.940000  -0.8566667
    ## Frutas_Vegetais     -0.4166667    -0.525000 -0.3500000  -5.433333   1.5250000
    ##                     Cereais Carboidratos      Graos Frutas_Vegetais
    ## Carne_Vermelha  -19.1000000    0.8666667 -2.8166667      -0.4166667
    ## Carne_Branca    -18.0983333    2.0716667 -5.0766667      -0.5250000
    ## Ovos             -8.6100000    0.7616667 -1.3400000      -0.3500000
    ## Leite           -46.3016667    2.5200000 -8.9400000      -5.4333333
    ## Peixe           -19.7600000    2.5200000 -0.8566667       1.5250000
    ## Cereais         121.2266667  -10.5366667 14.1400000       0.8916667
    ## Carboidratos    -10.5366667    2.7400000 -1.6550000       0.2166667
    ## Graos            14.1400000   -1.6550000  4.0766667       1.3583333
    ## Frutas_Vegetais   0.8916667    0.2166667  1.3583333       3.6666667

</br> </br>

2.  

``` r
# Matriz de Correlações

#install.packages("corrr")
#library(corrr)
#install.packages("ggcorrplot")
#library(ggcorrplot)
#install.packages("FactoMineR")
#library(FactoMineR)
#install.packages("factoextra")
#library(factoextra)

matriz_cor <- cor(data)
matriz_cor
```

    ##                 Carne_Vermelha Carne_Branca        Ovos      Leite       Peixe
    ## Carne_Vermelha      1.00000000   0.18850977  0.57532001  0.5440251  0.06491072
    ## Carne_Branca        0.18850977   1.00000000  0.60095535  0.2974816 -0.19719960
    ## Ovos                0.57532001   0.60095535  1.00000000  0.6130310  0.04780844
    ## Leite               0.54402512   0.29748163  0.61303102  1.0000000  0.16246239
    ## Peixe               0.06491072  -0.19719960  0.04780844  0.1624624  1.00000000
    ## Cereais            -0.50970337  -0.43941908 -0.70131040 -0.5924925 -0.51714759
    ## Carboidratos        0.15383673   0.33456770  0.41266333  0.2144917  0.43868411
    ## Graos              -0.40988882  -0.67214885 -0.59519381 -0.6238357 -0.12226043
    ## Frutas_Vegetais    -0.06393465  -0.07329308 -0.16392249 -0.3997753  0.22948842
    ##                     Cereais Carboidratos      Graos Frutas_Vegetais
    ## Carne_Vermelha  -0.50970337    0.1538367 -0.4098888     -0.06393465
    ## Carne_Branca    -0.43941908    0.3345677 -0.6721488     -0.07329308
    ## Ovos            -0.70131040    0.4126633 -0.5951938     -0.16392249
    ## Leite           -0.59249246    0.2144917 -0.6238357     -0.39977527
    ## Peixe           -0.51714759    0.4386841 -0.1222604      0.22948842
    ## Cereais          1.00000000   -0.5781345  0.6360595      0.04229293
    ## Carboidratos    -0.57813449    1.0000000 -0.4951880      0.06835670
    ## Graos            0.63605948   -0.4951880  1.0000000      0.35133227
    ## Frutas_Vegetais  0.04229293    0.0683567  0.3513323      1.00000000

``` r
corr_matrix <- cor(data)
ggcorrplot::ggcorrplot(corr_matrix, lab = TRUE)
```

![](Avaliacao-3_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

</br> </br>

3.  

``` r
r.pca <- princomp(matriz_cor)
summary(r.pca)
```

    ## Importance of components:
    ##                          Comp.1    Comp.2    Comp.3     Comp.4     Comp.5
    ## Standard deviation     1.306476 0.5182247 0.3610639 0.27323842 0.14161042
    ## Proportion of Variance 0.768188 0.1208652 0.0586723 0.03360071 0.00902517
    ## Cumulative Proportion  0.768188 0.8890531 0.9477255 0.98132616 0.99035133
    ##                             Comp.6      Comp.7      Comp.8 Comp.9
    ## Standard deviation     0.114308469 0.081225268 0.042129867      0
    ## Proportion of Variance 0.005880602 0.002969253 0.000798813      0
    ## Cumulative Proportion  0.996231934 0.999201187 1.000000000      1

``` r
r.pca$loadings[, 1:2]
```

    ##                     Comp.1      Comp.2
    ## Carne_Vermelha   0.2993407  0.10651363
    ## Carne_Branca     0.3193363  0.22312711
    ## Ovos             0.4134492  0.11960563
    ## Leite            0.3837089  0.15175036
    ## Peixe            0.1137789 -0.68417466
    ## Cereais         -0.4246411  0.28573531
    ## Carboidratos     0.2807581 -0.40862948
    ## Graos           -0.4375650 -0.07772646
    ## Frutas_Vegetais -0.1633793 -0.42281956

``` r
#fviz_eig(r.pca, addlabels = TRUE)
```

</br> </br>

4.  
