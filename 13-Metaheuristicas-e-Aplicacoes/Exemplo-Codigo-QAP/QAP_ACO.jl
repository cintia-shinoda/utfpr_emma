# ==========================================================
# Continuação Aula 3: Aplicações - QAP
# Implementação com Algoritmo de Colônia de Formigas (ACO)
# ==========================================================

# Nota: Reutilizamos calculate_qap_cost, F_example, D_example, N_example
# definidos anteriormente.

# ----------------------------------------------------------
# Estrutura Principal do ACO para QAP
# ----------------------------------------------------------

"""
Função principal do ACO para resolver o QAP.
As formigas constroem a permutação decidindo qual local alocar para cada instalação.
"""
function aco_qap(
    F::Matrix{Float64},         # Matriz de Fluxo
    D::Matrix{Float64},         # Matriz de Distância
    N::Int,                     # Tamanho do problema
    num_ants::Int,              # Número de formigas (m)
    num_iterations::Int,        # Número de iterações (critério de parada)
    alpha::Float64,             # Importância do feromônio
    beta::Float64,              # Importância da heurística
    rho::Float64,               # Taxa de evaporação (0 < rho <= 1)
    q0::Float64 = 0.9,          # Probabilidade de explotação (ACS-style, opcional)
    tau0::Float64 = 0.1         # Feromônio inicial (ou calculado)
    # heuristic_info::Union{Matrix{Float64}, Nothing} = nothing # Matriz heurística (opcional)
)
    # --- 1. Inicialização ---
    println("Inicializando ACO...")

    # Matriz de Feromônio: tau[i, l] = feromônio para alocar instalação i no local l
    pheromone = fill(tau0, (N, N))

    # Matriz Heurística (eta): eta[i, l] = desejabilidade a priori de alocar i em l
    # Heurística simples: 1 (ignora informação local por simplicidade inicial)
    # Poderia ser algo como 1 / (sum(F[i,:]) + sum(D[l,:])) ou mais complexo
    heuristic_info = ones(Float64, N, N) # eta = 1 para todos os pares (i, l)

    # Melhor solução global
    best_solution_overall = Vector{Int}(undef, N)
    best_cost_overall = Inf
    println("Feromônio inicial: $tau0")

    println("Iniciando ciclo do ACO ($num_iterations iterações, $num_ants formigas)...")
    history_best_cost_aco = Float64[] # Para acompanhar a convergência

    # --- 2. Ciclo Iterativo do ACO ---
    for iter in 1:num_iterations
        # Armazenar soluções e custos desta iteração
        ant_solutions = Vector{Vector{Int}}(undef, num_ants)
        ant_costs = Vector{Float64}(undef, num_ants)
        best_cost_iteration = Inf
        best_solution_iteration = Vector{Int}()

        # --- 2.1 Construção das Soluções pelas Formigas ---
        for k in 1:num_ants
            current_permutation = zeros(Int, N) # permutation[i] = local da instalação i
            available_locations = Set(1:N) # Locais ainda não atribuídos

            # Construir a permutação passo a passo (alocando instalação i=1 até N)
            for i in 1:N # Para cada instalação 'i'
                # Calcular probabilidades para os locais disponíveis
                probabilities = Float64[]
                possible_locations = collect(available_locations) # Lista dos locais disponíveis
                denominator = 0.0

                for l in possible_locations
                    tau_il = pheromone[i, l]
                    eta_il = heuristic_info[i, l] # Usando eta=1 neste exemplo
                    prob_factor = (tau_il^alpha) * (eta_il^beta)
                    push!(probabilities, prob_factor)
                    denominator += prob_factor
                end

                # Normalizar probabilidades
                if denominator ≈ 0.0 # Evitar divisão por zero se todos os fatores forem zero
                    # Escolha aleatória uniforme se não houver informação
                    probabilities = fill(1.0 / length(possible_locations), length(possible_locations))
                else
                    probabilities ./= denominator
                end

                # Escolher o próximo local 'l' para a instalação 'i'
                # Estratégia de escolha (pode variar, ex: regra do ACS com q0)
                chosen_location = -1
                if rand() < q0 # Explotação (escolhe o melhor com base na prob) - estilo ACS
                    best_prob_idx = argmax(probabilities)
                    chosen_location = possible_locations[best_prob_idx]
                else # Exploração (roleta)
                    # Usar amostragem ponderada (roleta)
                     # Precisa garantir que as probs somem 1 e não sejam negativas
                     if !all(isfinite, probabilities) || sum(probabilities) < 1e-9
                         chosen_location = rand(possible_locations) # Fallback aleatório
                     else
                        # Criar roleta simples
                        cumulative_probs = cumsum(probabilities)
                        r = rand()
                        chosen_idx = findfirst(p -> r <= p, cumulative_probs)
                        chosen_location = possible_locations[something(chosen_idx, length(possible_locations))] # 'something' para lidar com Nothing se findfirst falhar (raro)
                     end
                end


                # Atribuir e atualizar estado
                current_permutation[i] = chosen_location
                delete!(available_locations, chosen_location)

            end # Fim da construção da solução pela formiga k

            ant_solutions[k] = current_permutation
            ant_costs[k] = calculate_qap_cost(current_permutation, F, D)

            # Atualizar melhor da iteração
            if ant_costs[k] < best_cost_iteration
                best_cost_iteration = ant_costs[k]
                best_solution_iteration = copy(current_permutation)
            end

        end # Fim do loop das formigas

        # --- 2.2 Atualização de Feromônio ---
        # 2.2.1 Evaporação
        pheromone .*= (1.0 - rho)

        # 2.2.2 Deposição (Estratégia: Apenas a melhor formiga da iteração deposita)
        # Quantidade de feromônio a depositar: 1 / Custo (inverso do custo)
        delta_tau = 1.0 / best_cost_iteration # Pode usar 1.0 / best_cost_overall também (elitismo forte)

        for i in 1:N
            location_l = best_solution_iteration[i] # O local atribuído à instalação i
            pheromone[i, location_l] += delta_tau
        end

        # Opcional: Implementar limites Max-Min no feromônio (tau_min, tau_max)
        # tau_min = ...; tau_max = ...
        # clamp!(pheromone, tau_min, tau_max)


        # --- 2.3 Atualizar Melhor Solução Global ---
        if best_cost_iteration < best_cost_overall
            best_cost_overall = best_cost_iteration
            best_solution_overall = copy(best_solution_iteration)
            println("Iter $iter: Novo melhor custo global (ACO) = $best_cost_overall")
        end

        push!(history_best_cost_aco, best_cost_overall)

        # Opcional: Printar progresso
         if iter % 50 == 0 || iter == num_iterations
             println("Iter $iter/$num_iterations concluída (ACO). Melhor Custo Atual: $best_cost_overall")
         end

    end # Fim do loop de iterações

    println("Otimização ACO concluída.")
    println("Melhor solução encontrada: $best_solution_overall")
    println("Melhor custo encontrado: $best_cost_overall")

    return best_solution_overall, best_cost_overall, history_best_cost_aco
end


