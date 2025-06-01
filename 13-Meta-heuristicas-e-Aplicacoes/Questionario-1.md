# Questionário 1

#### Questão 1
Qual das seguintes opções é uma DESVANTAGEM das Meta-heurísticas?

[ ] a. Sua limitação fundamental em abordar problemas de grande escala, sendo eficazes apenas para instâncias com poucas variáveis e restrições simples.

**[x] b. A necessidade de ajuste cuidadoso de parâmetro (tuning) para obter um bom desempenho, o que frequentemente requer experimentação extensiva e consome tempo.**

[ ] c. O tempo de execução que, para qualquer problema dado, é sistematicamente superior ao tempo necessário por um método exato para encontrar a solução ótima garantida.

[ ] d. A restrição obrigatória de utilizar exclusivamente a representação binária para codificar as soluções candidatas, dificultando a aplicação em problemas contínuos ou de permutação.

---

#### Questão 2
No Algoritmo Genético, qual é o principal objetivo do operador de Crossover (Recombinação)?

[ ] a. Escolher, com base em critérios de aptidão, quais indivíduos da população atual terão a oportunidade de sobreviver e passar suas características para a próxima geração.

[x] **b. Combinar segmentos ou características ("material genético") provenientes de dois indivíduos pais selecionados para gerar um ou mais novos indivíduos filhos, na esperança de herdar e juntar boas propriedades de ambos (explotação).**

[ ] c. Inserir novas informações genéticas na população por meio de alterações aleatórias e pontuais nos cromossomos dos indivíduos selecionados.

[ ] d. Calcular e atribuir um valor de qualidade (fitness) a cada um dos indivíduos presentes na população atual, de acordo com a função objetivo do problema.

---

#### Questão 3
No contexto das meta-heurísticas, o que define a "Representação da Solução"?

[ ] a. O valor numérico que quantifica a qualidade ou aptidão de uma solução específica em relação ao objetivo do problema de otimização.

[ ] b. A arquitetura computacional específica, como processamento paralelo ou distribuído, utilizada para acelerar a execução da meta-heurística em hardware adequado.

[ ] c. O conjunto de condições ou regras que determinam o momento em que a execução do algoritmo de otimização deve ser encerrada.

[x] **d. A forma como uma solução candidata para o problema é codificada (por exemplo, como um vetor binário, uma permutação de itens, ou um vetor de números reais) para que o algoritmo possa manipulá-la.**

---

#### Questão 4
Qual a definição mais adequada para Meta-heurística?

[ ] a. Um conjunto de técnicas de pré-processamento de dados, como normalização e redução de dimensionalidade, aplicadas antes de iniciar algoritmos de otimização exatos.

[x] **b. Uma estratégia de busca de alto nível que guia outras heurísticas para encontrar soluções de boa qualidade para problemas complexos em tempo razoável.**

[ ] c. Um procedimento algorítmico formalmente derivado da matemática pura que possui a capacidade comprovada de localizar, sem falhas, a solução que representa o ótimo global absoluto para qualquer instância de problema de otimização formulado.

[ ] d. Uma coleção de heurísticas específicas para problemas particulares, como o método do vizinho mais próximo para o TSP, que garantem velocidade mas não qualidade.

---

#### Questão 5
Qual das seguintes meta-heurísticas é um exemplo de algoritmo Baseado em População e Inspirado na Natureza?

[ ] a. O Simulated Annealing (SA), cujo mecanismo de aceitação probabilística de soluções piores é análogo ao processo físico de recozimento de metais.

[ ] b. O Iterated Local Search (ILS), que combina busca local com perturbações para escapar de ótimos locais, sem uma inspiração natural direta.

[ ] c. A Busca Tabu (TS), que utiliza memória de curto prazo para guiar a busca local de forma inteligente, inspirada no raciocínio humano.

[x] **d. O Algoritmo Genético (GA), que simula processos da evolução biológica como seleção natural, recombinação e mutação em uma população de indivíduos.**

---

#### Questão 6
Qual é o principal objetivo do operador de Mutação em um Algoritmo Genético?

[x] **a. Introduzir diversidade genética na população, alterando aleatoriamente um ou mais genes nos cromossomos dos filhos, o que ajuda a evitar a estagnação em ótimos locais e permite a exploração de novas áreas do espaço de busca.**

[ ] b. Acelerar o processo de convergência do algoritmo, forçando a população a se concentrar rapidamente em torno da solução localmente ótima mais próxima encontrada até o momento.

[ ] c. Realizar a combinação de material genético entre dois cromossomos pais para gerar descendentes que herdem características de ambos.

[ ] d. Assegurar que a melhor solução encontrada em qualquer geração anterior seja sempre preservada e copiada sem alterações para a geração seguinte (elitismo).

---

#### Questão 7
Qual o propósito do operador de Seleção em um Algoritmo Genético?

[ ] a. Gerar novos indivíduos (filhos) através da recombinação de informações genéticas provenientes de dois indivíduos selecionados (pais).

[ ] b. Avaliar se algum dos critérios definidos para a terminação do algoritmo (como número máximo de gerações ou convergência) foi satisfeito.

[x] **c. Escolher, geralmente de forma probabilística e favorecendo indivíduos com maior aptidão (fitness), quais membros da população atual atuarão como pais para a criação da próxima geração de soluções.**

[ ] d. Aplicar modificações aleatórias e pontuais nos genes dos cromossomos dos indivíduos para introduzir nova variabilidade genética na população.

---

#### Questão 8
Qual a função do Elitismo em um Algoritmo Genético?

[ ] a. Modificar a população de forma a garantir que todos os indivíduos se tornem rapidamente idênticos ao melhor indivíduo encontrado, acelerando a convergência local.

[ ] b. Servir como um substituto completo para os métodos tradicionais de seleção, como roleta ou torneio, definindo deterministicamente quem serão os pais.

[ ] c. Aplicar uma taxa de mutação mais elevada especificamente aos indivíduos que apresentam os piores valores de fitness na população atual.

[x] **d. Assegurar que um ou mais dos melhores indivíduos encontrados na geração corrente sejam copiados diretamente para a próxima geração, sem sofrerem os efeitos dos operadores de crossover ou mutação, prevenindo assim a perda da melhor solução encontrada até então.**

---

#### Questão 9
Por que as Meta-heurísticas são frequentemente utilizadas em problemas de otimização do mundo real?

[x] a. Porque muitos problemas reais são NP-difíceis, possuem espaços de busca vastos e complexos (não-convexos, multimodais), tornando métodos exatos inviáveis.

[ ] b. Porque a codificação de uma meta-heurística é inerentemente mais simples e requer menos linhas de código do que a implementação de qualquer método exato ou heurística específica.

[ ] c. Devido à incorporação de técnicas sofisticadas de inteligência artificial e aprendizado de máquina, as meta-heurísticas conseguem antecipar a localização exata da solução ótima global, eliminando a necessidade de qualquer processo iterativo de busca exploratória no espaço de soluções.

[ ] d. Visto que a maioria dos problemas encontrados na prática industrial e acadêmica carece de restrições complexas, a aplicação direta de meta-heurísticas torna-se trivial e muito eficiente.

---

#### Questão 10
Como são classificadas as meta-heurísticas Simulated Annealing (SA) e Busca Tabu (TS) quanto à estratégia de busca predominante?

[x] a. São exemplos de meta-heurísticas baseadas em trajetória (Single-Solution), focadas em modificar e melhorar iterativamente uma única solução candidata.

[ ] b. São classificadas como algoritmos baseados em população, pois mantêm e evoluem um grande conjunto de soluções candidatas simultaneamente a cada iteração.

[ ] c. Pertencem à categoria de métodos determinísticos, pois dada a mesma entrada e configuração de parâmetros, sempre produzirão exatamente a mesma sequência de soluções.

[ ] d. Caracterizam-se por serem aplicáveis exclusivamente a problemas de otimização onde o espaço de busca é contínuo e as variáveis podem assumir valores reais.