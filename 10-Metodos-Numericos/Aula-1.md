# Aula 1 - Solução Numérica de Equações Diferenciais Ordinárias

https://drive.google.com/file/d/1yfRcMsnmJIPzLSrU0yvd22uFV6pe0fDP/view

- Técnicas matemáticas usadas na solução de problemas matemáticos que não podem ser resolvidos ou que são difíceis de se resolver analiticamente.
  - solução analítica: solução exata
  - solução numérica: valor numérico aproximado (porém, podem ser muito precisas)
- em muitos métodos numéricos, os cálculos são executados iterativamente, até que a precisão desejada seja alcançada.

### Usos:
  - busca de soluções de equações polinomiais de grau maior que 4
  - frequentemente em problemas técnicos-científicos
<br>

### Fases:
- Problema + Levantamento de Dados
- Construção do modelo matemáticos
- Escolha do Método Numérico Adequado
- Implementação Computacional
- Análise dos Resultados
<br>

### Tipos de erros:
#### Erro dos dados de entrada
#### Erro por truncamento: 
- troca de um número infinito por um número finito
#### Erro por arredondamento
- corte
- arredondamento
#### Erros na fase de modelagem
- nos dados de entrada
- gerados pelo modelo (simplificações do mundo físico)
#### Erros na fase de resolução
- por truncamento: $E^{TR}$ (infinito -> finito)
- por arredondamento
  - tipo corte: dígitos além da precisão requerida são abandonados
  - para o número mais próximo (se $>=5$, soma-se uma unidade; se $<5$, o algarismo permanece inalterado)
<br>

#### Erro Absoluto ($E_{Ab}$)
$E_{Ab} = x - \={x}$
- $x$: valor exato (ou valor anterior)
- $\={x}$: valor aproximado (ou valor atual)

#### Erro Relativo ($E_{Rel}$)
$E_{Rel} = \frac{x-\={x}}{x}$
<br>

### Aproximação para o erro
- no mundo real, NÃO conhecemos a resposta verdadeira. 
- encontramos um limitante para o erro, que fornece o "pior caso" de erro
- $\varepsilon = \frac{erro \ aproximado}{aproximação} . 100\%$
<br>
- nos métodos iterativos, uma aproximação atual é feita com base em uma aproximação prévia
- Erro relativo percentual: $\varepsilon_{a} = \frac{aproximacao \ atual - aproximacao \ prévia}{aproximacao \ atual} . 100\%$


- repetem-se os cálculos até que o valor absoluto percentual seja MENOR que uma tolerância percentual pré-definida ($\varepsilon_{s}$) 
$$|\varepsilon_{a}| < \varepsilon_{s}$$

#### Exemplos de influência dos erros nas soluções
- falha no lançamento de mísseis
- explosão de foguetes
- afundamento de plataforma marítima


## Soluções Numéricas de Equações Diferenciais
- PVI (Problema de Valor Inicial)
- discretização
- na solução numérica, já se parte da condição inicial, dentro de um intervalo
  - em solução analítica, ignora-se a condição inicial, encontra-se a solução geral, e aplica-se a condição inicial para encontrar a solução particular
  

### Métodos de Passo Simples
- Método de Euler
- Método de Euler Modificado
- Método de Euler Melhorado
- Método de Runge-Kutta de 3ª Ordem
- Método de Runge-Kutta de 4ª Ordem

### Método de Passo Múltiplo
- Método de Adams-Bashforth
- Método de Adams-Moulton
- Método de Milne


- aumenta a ordem do método, aumenta-se a precisão (diminui-se o erro associado)

### Definições Básicas
#### Equação Diferencial:
- Tipo: 
  - EDO: $y$ é a função de $x$, $x$ é a única variável independente
  - EDP: $u$ é função de $x$ e $y$; $x$ e $y$ são variáveis independentes
- Ordem: ordem da derivada de maior ordem em uma equação diferencial
- Linearidade: não interfere na escolha do método na solução numérica
#### Problema de Valor Inicial (PVI)
- intervalo
- passo $h$

### Métodos de Passo Simples
$y_{j+1} = y_{j} + h . \varphi(x_{j}, y_{j}, h)$

#### Método de Euler
- uma reta tangente pode ser usada para aproximar os valores de uma função em uma pequena vizinhança do ponto de tangência
- Exemplo: Achar aproximações pelo Método de Euler para a solução do problema de inicial, na malha $[0,1]$ e $h=0,2$, dado por:
$y' = x - y + 2 $ para $y(0) = 2$