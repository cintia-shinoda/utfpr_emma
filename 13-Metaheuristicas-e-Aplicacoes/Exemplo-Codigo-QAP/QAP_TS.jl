# ==========================================================
# Continuação Aula 3: Aplicações - QAP
# Implementação com Busca Tabu (TS)
# ==========================================================

# Nota: Reutilizamos calculate_qap_cost, F_example, D_example, N_example
# definidos anteriormente.

# ----------------------------------------------------------
# Estrutura Principal da Busca Tabu (TS)
# ----------------------------------------------------------

"""
Função principal da Busca Tabu para resolver o QAP.
"""
function tabu_search_qap(
    F::Matrix{Float64},         # Matriz de Fluxo
    D::Matrix{Float64},         # Matriz de Distância
    N::Int,                     # Tamanho do problema
    num_iterations::Int,        # Número de iterações (critério de parada)
    tabu_tenure::Int,           # Duração tabu (fixa neste exemplo)
    neighborhood_size::Union{Int, Nothing}=nothing # Tamanho da vizinhança a explorar (opcional, Nothing=completa)
)
    # --- 1. Inicialização ---
    println("Inicializando Busca Tabu...")
    # Solução inicial aleatória
    current_solution = shuffle(collect(1:N))
    current_cost = calculate_qap_cost(current_solution, F, D)

    # Melhor solução encontrada globalmente
    best_solution_overall = copy(current_solution)
    best_cost_overall = current_cost
    println("Custo inicial (TS): $best_cost_overall")

    # Lista Tabu: Armazena o atributo (par de índices trocados) e a iteração em que se torna não-tabu
    # Usaremos um Dict: (min_idx, max_idx) => iteration_non_tabu
    tabu_list = Dict{Tuple{Int, Int}, Int}()

    println("Iniciando ciclo da Busca Tabu ($num_iterations iterações)...")
    history_best_cost_ts = Float64[] # Para acompanhar a convergência

    # --- 2. Ciclo Iterativo da Busca Tabu ---
    for iter in 1:num_iterations
        best_neighbor_solution = Vector{Int}()
        best_neighbor_cost = Inf
        best_move_attribute = (-1, -1) # Armazena o (i, j) do melhor movimento vizinho

        # --- 2.1 Explorar Vizinhança (Swap) ---
        # Estratégia: Avaliar 'neighborhood_size' vizinhos aleatórios ou todos se 'nothing'
        possible_moves = N * (N - 1) ÷ 2 # Número total de swaps possíveis
        moves_to_evaluate = isnothing(neighborhood_size) ? possible_moves : min(neighborhood_size, possible_moves)

        evaluated_moves = Set{Tuple{Int,Int}}() # Para evitar avaliar o mesmo swap duas vezes se neighborhood_size < possible_moves

        for _ in 1:moves_to_evaluate
            # Gerar um movimento de swap (trocar i e j)
            i = rand(1:N)
            j = rand(1:N)
            while i == j
                j = rand(1:N)
            end
            idx1, idx2 = minmax(i, j) # Pega o par ordenado (min, max) como atributo
            move_attribute = (idx1, idx2)

            # Se estamos amostrando a vizinhança, pula se já avaliou esse par
            if !isnothing(neighborhood_size) && move_attribute in evaluated_moves
                 if length(evaluated_moves) < possible_moves # Evita loop infinito se todos já foram vistos
                    continue
                 else
                    # Se neighborhood_size >= total de moves, não precisa checar 'evaluated_moves'
                    # Se < total e já vimos todos, talvez parar a exploração da vizinhança aqui?
                    # Por simplicidade, deixamos continuar, pode re-avaliar se a amostragem for grande
                 end
            end
            push!(evaluated_moves, move_attribute)


            # Criar o vizinho aplicando o swap
            neighbor_solution = copy(current_solution)
            neighbor_solution[idx1], neighbor_solution[idx2] = neighbor_solution[idx2], neighbor_solution[idx1]
            neighbor_cost = calculate_qap_cost(neighbor_solution, F, D)

            # --- 2.2 Verificar Status Tabu e Aspiração ---
            is_tabu = false
            if haskey(tabu_list, move_attribute)
                if iter <= tabu_list[move_attribute] # Ainda está tabu?
                    is_tabu = true
                else
                    # Se a iteração atual > iteração não-tabu, remove da lista (limpeza implícita)
                    # Poderia fazer uma limpeza explícita periódica também
                    delete!(tabu_list, move_attribute)
                end
            end

            # Critério de Aspiração: Melhor que o melhor global encontrado até agora
            aspiration_met = neighbor_cost < best_cost_overall

            # --- 2.3 Selecionar Melhor Movimento Admissível ---
            admissible = !is_tabu || aspiration_met

            if admissible && neighbor_cost < best_neighbor_cost
                best_neighbor_cost = neighbor_cost
                best_neighbor_solution = neighbor_solution # Armazena a solução vizinha
                best_move_attribute = move_attribute      # Armazena o atributo do movimento que levou a ela
            end

        end # Fim da exploração da vizinhança

        # --- 2.4 Mover para o Melhor Vizinho Admissível ---
        if best_move_attribute == (-1, -1)
            # Nenhum movimento admissível encontrado (raro, mas pode acontecer se vizinhança for muito pequena/restrita)
            println("Iter $iter: Nenhum movimento admissível encontrado. Estagnação?")
            # Poderia implementar uma estratégia de diversificação aqui, ou simplesmente continuar
        else
            current_solution = best_neighbor_solution
            current_cost = best_neighbor_cost

            # --- 2.5 Atualizar Lista Tabu ---
            # Adiciona o atributo do movimento realizado, tornando-o tabu pelas próximas 'tabu_tenure' iterações
            iteration_non_tabu = iter + tabu_tenure
            tabu_list[best_move_attribute] = iteration_non_tabu
             #println("Iter $iter: Movi para custo $current_cost. Tornando $best_move_attribute tabu até iter $iteration_non_tabu")

             # Limpeza Opcional: Remover entradas muito antigas para não crescer indefinidamente
             # (Embora a verificação no início já remova os expirados ao serem encontrados)
             # keys_to_delete = [k for (k,v) in tabu_list if iter > v]
             # for k in keys_to_delete delete!(tabu_list, k) end
        end

        # --- 2.6 Atualizar Melhor Solução Global ---
        if current_cost < best_cost_overall
            best_cost_overall = current_cost
            best_solution_overall = copy(current_solution)
            println("Iter $iter: Novo melhor custo global (TS) = $best_cost_overall")
        end

        push!(history_best_cost_ts, best_cost_overall)

        # Opcional: Printar progresso
         if iter % 50 == 0 || iter == num_iterations
             println("Iter $iter/$num_iterations concluída (TS). Melhor Custo Atual: $best_cost_overall")
         end

    end # Fim do loop de iterações

    println("Otimização Busca Tabu concluída.")
    println("Melhor solução encontrada: $best_solution_overall")
    println("Melhor custo encontrado: $best_cost_overall")

    return best_solution_overall, best_cost_overall, history_best_cost_ts
end


