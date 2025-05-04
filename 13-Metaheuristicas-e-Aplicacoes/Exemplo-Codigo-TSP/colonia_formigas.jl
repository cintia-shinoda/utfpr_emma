using Random, LinearAlgebra # Certificar que estão carregadas

# ==========================================================
# Implementação com Algoritmo de Colônia de Formigas (ACO) para TSP
# ==========================================================

"""
Função principal do ACO para resolver o TSP.
"""
function tsp_aco(D::Matrix{Float64};
                 num_ants=max(10, size(D, 1) ÷ 2), # Número de formigas
                 max_iter=100,                   # Iterações
                 alpha=1.0,                      # Importância do feromônio
                 beta=2.0,                       # Importância da heurística (distância)
                 rho=0.1,                        # Taxa de evaporação
                 Q=1.0,                          # Fator de deposição (ou 1/custo)
                 tau0=0.1)                       # Feromônio inicial

    n = size(D, 1)
    pheromone = fill(tau0, (n, n))
    # Heurística: Inverso da distância (evita divisão por zero)
    heuristic_info = [i == j ? 0.0 : 1.0 / (D[i, j] + 1e-9) for i in 1:n, j in 1:n]

    best_route_overall = collect(1:n)
    best_cost_overall = sum(D[best_route_overall[i], best_route_overall[i%n+1]] for i in 1:n)

    for iter in 1:max_iter
        ant_routes = Vector{Vector{Int}}(undef, num_ants)
        ant_costs = Vector{Float64}(undef, num_ants)
        best_cost_iteration = Inf

        # Construção das rotas pelas formigas
        for k in 1:num_ants
            start_node = rand(1:n)
            current_route = [start_node]
            visited = Set([start_node])

            while length(visited) < n
                current_node = current_route[end]
                probabilities = Float64[]
                neighbor_nodes = Int[]
                denominator = 0.0

                # Calcular probabilidades para vizinhos não visitados
                for next_node in 1:n
                    if !(next_node in visited)
                        tau = pheromone[current_node, next_node]
                        eta = heuristic_info[current_node, next_node]
                        prob_factor = (tau^alpha) * (eta^beta)
                        push!(probabilities, prob_factor)
                        push!(neighbor_nodes, next_node)
                        denominator += prob_factor
                    end
                end

                # Selecionar próximo nó
                if denominator ≈ 0.0 || isempty(neighbor_nodes)
                     # Fallback: Se não há opções ou probabilidade zero, adiciona um nó aleatório não visitado
                     remaining_nodes = setdiff(Set(1:n), visited)
                     next_chosen_node = isempty(remaining_nodes) ? start_node : rand(collect(remaining_nodes)) # Pega um aleatório dos que faltam
                else
                    probabilities ./= denominator # Normaliza
                    # Roleta
                    cumulative_probs = cumsum(probabilities)
                    r = rand()
                    chosen_idx = findfirst(p -> r <= p, cumulative_probs) #Retorna um indice para vizinho de acordo com probabilidade acumulada 
                    # Se findfirst retornar Nothing (problema numérico raro), escolher aleatoriamente
                    next_chosen_node = isnothing(chosen_idx) ? rand(neighbor_nodes) : neighbor_nodes[chosen_idx]
                end

                push!(current_route, next_chosen_node)
                push!(visited, next_chosen_node)
            end # Fim da construção da rota da formiga k

            ant_routes[k] = current_route
            ant_costs[k] = sum(D[current_route[i], current_route[i%n+1]] for i in 1:n)

            if ant_costs[k] < best_cost_iteration
                best_cost_iteration = ant_costs[k]
            end
        end # Fim do loop das formigas

        # Atualização do Feromônio
        # 1. Evaporação
        pheromone .*= (1.0 - rho)

        # 2. Deposição (Todas as formigas depositam, proporcional ao inverso do custo)
        for k in 1:num_ants
            route = ant_routes[k]
            cost = ant_costs[k]
            # delta_tau = Q / cost # Usar Q ou 1/custo
            delta_tau = 1.0 / cost # Mais simples, favorece rotas melhores
            for i in 1:n
                u, v = route[i], route[i%n+1]
                pheromone[u, v] += delta_tau
                pheromone[v, u] += delta_tau # Assumindo problema simétrico
            end
        end

        # Atualizar melhor rota global
        min_cost_iter, best_ant_idx = findmin(ant_costs)
        if min_cost_iter < best_cost_overall
            best_cost_overall = min_cost_iter
            best_route_overall = copy(ant_routes[best_ant_idx])
            # println("Iter $iter (ACO): Novo melhor custo = $best_cost_overall") # Opcional
        end

    end # Fim do loop de iterações

    return best_route_overall, best_cost_overall
end