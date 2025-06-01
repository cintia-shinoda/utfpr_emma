# ==========================================================
# Aula 3: Aplicações - Problema de Alocação Quadrática (QAP)
# Implementação com Algoritmo Genético (GA)
# ==========================================================

using Random # Para operações aleatórias (shuffle, rand, etc.)
using Plots # Plots de convergência 

# ----------------------------------------------------------
# Definição do Problema QAP
# ----------------------------------------------------------
# Objetivo: Minimizar o custo total de alocação de N instalações a N locais.
# Custo(π) = Σᵢ Σⱼ Fᵢⱼ * D_{πᵢ, πⱼ}
# Onde:
#   N: Número de instalações/locais
#   F: Matriz de Fluxo (N x N), Fᵢⱼ = fluxo entre instalação i e j
#   D: Matriz de Distância (N x N), Dₖₗ = distância entre local k e l
#   π: Permutação (solução), πᵢ = local da instalação i. Vetor de 1 a N.
# ----------------------------------------------------------

"""
Calcula o custo QAP para uma dada permutação (solução).
"""
function calculate_qap_cost(permutation::Vector{Int}, F::Matrix{Float64}, D::Matrix{Float64})
    N = length(permutation)
    cost = 0.0
    for i in 1:N
        for j in 1:N
            if i != j # O fluxo Fii e Dkk são geralmente 0, mas é bom garantir
                cost += F[i, j] * D[permutation[i], permutation[j]]
            end
        end
    end
    return cost
end

# ----------------------------------------------------------
# Estrutura Principal do Algoritmo Genético
# ----------------------------------------------------------

"""
Função principal do Algoritmo Genético para resolver o QAP.
"""
function genetic_algorithm_qap(
    F::Matrix{Float64},         # Matriz de Fluxo
    D::Matrix{Float64},         # Matriz de Distância
    N::Int,                     # Tamanho do problema (número de instalações/locais)
    pop_size::Int,              # Tamanho da população
    num_generations::Int,       # Número de gerações (critério de parada)
    crossover_rate::Float64,    # Taxa de crossover (Pc)
    mutation_rate::Float64,     # Taxa de mutação (Pm) por indivíduo
    tournament_size::Int,       # Tamanho do torneio para seleção
    elite_size::Int             # Número de indivíduos elite a serem preservados
    )
    # Passando os valores manualmente
    # F = F_example        # Matriz de Fluxo
    # D = D_example         # Matriz de Distância
    # N = N_example                     # Tamanho do problema (número de instalações/locais)
    # pop_size = pop_size_ga            # Tamanho da população
    # num_generations = num_generations_ga       # Número de gerações (critério de parada)
    # crossover_rate = pc    # Taxa de crossover (Pc)
    # mutation_rate = pm     # Taxa de mutação (Pm) por indivíduo
    # tournament_size = tourn_size       # Tamanho do torneio para seleção
    # elite_size = n_elite     

    
    # --- 1. Inicialização ---
    println("Inicializando população...")
    population = initialize_population(pop_size, N)
    best_solution_overall = Vector{Int}()
    best_cost_overall = Inf # Como estamos minimizando

    println("Iniciando ciclo evolucionário ($num_generations gerações)...")
    history_best_cost = Float64[] # Para acompanhar a convergência

    # --- 2. Ciclo Evolucionário ---
    for gen in 1:num_generations
        # gen = 1
        # --- 2.1 Avaliação ---
        fitness_values = evaluate_population(population, F, D)
        # Encontrar o melhor da geração atual e atualizar o melhor geral
        min_cost_gen, best_idx_gen = findmin(fitness_values)
        if min_cost_gen < best_cost_overall
            best_cost_overall = min_cost_gen
            best_solution_overall = copy(population[best_idx_gen]) # Copiar para evitar modificação
            println("Gen $gen: Novo melhor custo = $best_cost_overall")
        end
        push!(history_best_cost, best_cost_overall)

        # Preparar para a próxima geração
        new_population = Vector{Vector{Int}}(undef, pop_size)

        # --- 2.2 Elitismo ---
        # Copiar os 'elite_size' melhores indivíduos diretamente
        sorted_indices = sortperm(fitness_values) # Índices ordenados do melhor para o pior
        for i in 1:elite_size
            new_population[i] = copy(population[sorted_indices[i]])
        end

        # --- 2.3 Geração dos Filhos (Seleção, Crossover, Mutação) ---
        num_offspring = pop_size - elite_size
        offspring_generated = 0
        while offspring_generated < num_offspring
            # --- 2.3.1 Seleção dos Pais ---
            # Seleciona dois pais diferentes usando torneio
            parent1_idx = tournament_selection(fitness_values, tournament_size)
            parent2_idx = tournament_selection(fitness_values, tournament_size)
            # Garante que os pais sejam diferentes (simples verificação)
            while parent1_idx == parent2_idx
                parent2_idx = tournament_selection(fitness_values, tournament_size)
            end
            parent1 = population[parent1_idx]
            parent2 = population[parent2_idx]

            # --- 2.3.2 Crossover ---
            child1 = parent1 # Por padrão, se não houver crossover
            child2 = parent2
            if rand() < crossover_rate
                 # Usaremos PMX como exemplo, pode precisar de outra função se escolher outro
                child1, child2 = pmx_crossover_corrected(parent1, parent2)
            end

            # --- 2.3.3 Mutação ---
             # Aplica mutação aos filhos gerados (ou cópias dos pais se não houve crossover)
             if offspring_generated < num_offspring
                mutate!(child1, mutation_rate) # Mutação inplace
                new_population[elite_size + offspring_generated + 1] = child1
                offspring_generated += 1
             end
             if offspring_generated < num_offspring && child1 !== child2 # Evita duplicar se crossover não gerou 2 filhos distintos ou não ocorreu
                mutate!(child2, mutation_rate) # Mutação inplace
                new_population[elite_size + offspring_generated + 1] = child2
                offspring_generated += 1
             end
        end # Fim do while offspring

        # Atualiza a população para a próxima geração
        population = new_population

        # Opcional: Printar progresso a cada X gerações
        if gen % 50 == 0 || gen == num_generations
             println("Gen $gen/$num_generations concluída. Melhor Custo Atual: $best_cost_overall")
        end

    end # Fim do loop de gerações

    println("Otimização GA concluída.")
    println("Melhor solução encontrada: $best_solution_overall")
    println("Melhor custo encontrado: $best_cost_overall")

    return best_solution_overall, best_cost_overall, history_best_cost
end

# ----------------------------------------------------------
# Funções Auxiliares e Operadores Genéticos (Implementação Pendente)
# ----------------------------------------------------------

"""
Inicializa a população com permutações aleatórias.
"""
function initialize_population(pop_size::Int, N::Int)::Vector{Vector{Int}}
    population = Vector{Vector{Int}}(undef, pop_size)
    base_permutation = collect(1:N)
    for i in 1:pop_size
        population[i] = shuffle(base_permutation) # Cria uma permutação aleatória
    end
    return population
end

"""
Calcula o fitness (custo QAP) para cada indivíduo na população.
Retorna um vetor de custos.
"""
function evaluate_population(population::Vector{Vector{Int}}, F::Matrix{Float64}, D::Matrix{Float64})::Vector{Float64}
    pop_size = length(population)
    fitness_values = Vector{Float64}(undef, pop_size)
    for i in 1:pop_size
        fitness_values[i] = calculate_qap_cost(population[i], F, D)
    end
    return fitness_values
end

"""
Seleciona um índice de pai usando seleção por torneio.
Assume que fitness_values corresponde à população (menor é melhor).
"""
function tournament_selection(fitness_values::Vector{Float64}, tournament_size::Int)::Int
    pop_size = length(fitness_values)
    best_idx_in_tournament = -1
    best_fitness_in_tournament = Inf

    for _ in 1:tournament_size
        candidate_idx = rand(1:pop_size)
        if fitness_values[candidate_idx] <= best_fitness_in_tournament
            best_fitness_in_tournament = fitness_values[candidate_idx]
            best_idx_in_tournament = candidate_idx
        end
    end
    return best_idx_in_tournament
end

"""
Realiza o Crossover PMX (Partially Mapped Crossover) entre dois pais.
VERSÃO COM ADEQUAÇÕES
Retorna dois filhos (novas permutações).
"""
function pmx_crossover_corrected(parent1::Vector{Int}, parent2::Vector{Int})::Tuple{Vector{Int}, Vector{Int}}
    N = length(parent1)
    child1 = fill(0, N) # Inicializa com zeros ou outro valor inválido
    child2 = fill(0, N)

    # 1. Escolher dois pontos de corte aleatórios
    cut1 = rand(1:N)
    cut2 = rand(1:N)
    if cut1 > cut2
        cut1, cut2 = cut2, cut1
    elseif cut1 == cut2
       # Se os pontos são iguais ou adjacentes cobrindo tudo, PMX não faz sentido ou é trivial
       # Retornar cópias pode ser uma opção segura, ou recalcular os cortes.
       # Para simplificar, vamos garantir que haja um segmento real:
       if N <= 1 return copy(parent1), copy(parent2) end
       while cut1 == cut2
            cut1 = rand(1:N)
            cut2 = rand(1:N)
            if cut1 > cut2 cut1, cut2 = cut2, cut1 end
       end
       # Evitar segmento cobrindo tudo se cut1=1 e cut2=N? Opcional.
    end


    # 2. Copiar segmento e criar mapeamentos
    mapping1 = Dict{Int, Int}() # Mapeia P2[i] -> P1[i] no segmento
    mapping2 = Dict{Int, Int}() # Mapeia P1[i] -> P2[i] no segmento
    p1_in_segment = Set{Int}()
    p2_in_segment = Set{Int}()

    for i in cut1:cut2
        child1[i] = parent2[i]
        child2[i] = parent1[i]
        mapping1[parent2[i]] = parent1[i]
        mapping2[parent1[i]] = parent2[i]
        push!(p1_in_segment, parent1[i])
        push!(p2_in_segment, parent2[i])
    end

    # 3. Preencher fora do segmento, resolvendo conflitos
    for i in vcat(1:cut1-1, cut2+1:N)
        # Preencher Child 1
        val_p1 = parent1[i]
        # Enquanto o valor de P1 já estiver no segmento de C1 (que veio de P2)...
        while val_p1 in p2_in_segment
            val_p1 = mapping1[val_p1] # ... segue o mapeamento para encontrar o valor substituto
        end
        child1[i] = val_p1

        # Preencher Child 2
        val_p2 = parent2[i]
        # Enquanto o valor de P2 já estiver no segmento de C2 (que veio de P1)...
        while val_p2 in p1_in_segment
            val_p2 = mapping2[val_p2] # ... segue o mapeamento
        end
        child2[i] = val_p2
    end

    # Verificação de Sanidade (Opcional, mas útil para depuração)
    #=
    if length(unique(child1)) != N || length(unique(child2)) != N
        println("ERRO PMX: Filho inválido gerado!")
        println("P1: ", parent1)
        println("P2: ", parent2)
        println("Cuts: ", cut1, "-", cut2)
        println("C1: ", child1)
        println("C2: ", child2)
        # Decide o que fazer: retornar cópias dos pais? Lançar erro?
        return copy(parent1), copy(parent2) # Fallback seguro
    end
    =#

    return child1, child2
end

"""
Realiza o Crossover PMX (Partially Mapped Crossover) entre dois pais.
Retorna dois filhos (novas permutações).
(IMPLEMENTAÇÃO DETALHADA NECESSÁRIA AQUI)
"""
function pmx_crossover(parent1::Vector{Int}, parent2::Vector{Int})::Tuple{Vector{Int}, Vector{Int}}
    N = length(parent1)
    child1 = zeros(Int, N)
    child2 = zeros(Int, N)

    # Escolher dois pontos de corte
    cut1 = rand(1:N)
    cut2 = rand(1:N)
    if cut1 > cut2
        cut1, cut2 = cut2, cut1 # Garante cut1 <= cut2
    elseif cut1 == cut2
        # Se os pontos são iguais, os filhos são cópias dos pais
        return copy(parent1), copy(parent2)
    end

    # Mapeamento para garantir a validade da permutação
    mapping1 = Dict{Int, Int}()
    mapping2 = Dict{Int, Int}()

    # Copiar o segmento do meio e criar mapeamentos
    for i in cut1:cut2
        child1[i] = parent2[i]
        child2[i] = parent1[i]
        mapping1[parent2[i]] = parent1[i]
        mapping2[parent1[i]] = parent2[i]
    end

    # Preencher o restante dos filhos, resolvendo conflitos com mapeamento
    for i in vcat(1:cut1-1, cut2+1:N)
        # Filho 1
        current_val_p1 = parent1[i]
        while current_val_p1 in values(mapping1) # Enquanto o valor estiver no *range* do map (foi mapeado DELE)
             # Encontra a chave que mapeia PARA ele (simulando o ciclo reverso)
             key_found = -1
             for (k, v) in mapping1
                 if v == current_val_p1
                     key_found = k
                     break
                 end
             end
             current_val_p1 = key_found # Segue o ciclo reverso usando a chave como próximo valor
        end
        child1[i] = current_val_p1


        # Filho 2
        current_val_p2 = parent2[i]
         while current_val_p2 in values(mapping2)
             key_found = -1
              for (k, v) in mapping2
                 if v == current_val_p2
                     key_found = k
                     break
                 end
             end
             current_val_p2 = key_found
        end
        child2[i] = current_val_p2
    end


    return child1, child2
end


"""
Aplica mutação por troca (swap) a um indivíduo (inplace) com probabilidade `mutation_rate`.
"""
function mutate!(individual::Vector{Int}, mutation_rate::Float64)
    if rand() < mutation_rate
        N = length(individual)
        if N >= 2
            # Escolhe dois índices distintos para trocar
            idx1 = rand(1:N)
            idx2 = rand(1:N)
            while idx1 == idx2
                idx2 = rand(1:N)
            end
            # Realiza a troca
            individual[idx1], individual[idx2] = individual[idx2], individual[idx1]
        end
    end
    # A modificação é feita inplace, não precisa retornar
end


