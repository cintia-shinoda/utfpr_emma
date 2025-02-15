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

### Aproximação para o erros
- no mundo real, NÃO conhecemos a resposta verdadeira. 
- encontramos um limitante para o erro, que fornece o "pior caso" de erro
- $\varepsilon = \frac{erro \ aproximado}{aproximação} . 100\%$
<br>
- nos métodos iterativos, uma aproximação atual é feita com base em uma aproximação prévia
- Erro relativo percentual: $\varepsilon_{a} = \frac{aproximacao \ atual - aproximacao \ prévia}{aproximacao \ atual} . 100\%$


57min