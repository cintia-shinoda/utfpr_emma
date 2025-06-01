# ==========================================================
# Implementação com PSO + Random Keys (RKPSO) para TSP
# ==========================================================

# Reutiliza a struct ParticleRK e keys_to_permutation do QAP (ou redefine se necessário)
# Se estiver em arquivos separados, copie/inclua essas definições.

"""
Função principal do PSO com Random Keys para resolver o TSP.
"""

# Estrutura da partícula 
mutable struct ParticleRKTSP 
    position::Vector{Float64}
    velocity::Vector{Float64}
    pbest_position::Vector{Float64}
    pbest_cost::Float64

    ParticleRKTSP(n_dims::Int) = new(
        rand(n_dims), zeros(n_dims), zeros(n_dims), Inf
    )
end
    
function tsp_pso_rk(D::Matrix{Float64};
                    swarm_size=max(20, size(D,1)),  # Tamanho do enxame
                    max_iter=100,                 # Iterações
                    w=0.7,                        # Inércia
                    c1=1.5,                       # Cognitivo
                    c2=1.5,                       # Social
                    v_max_factor=0.5)             # Fator para Vmax (0.5 = 50% do range [0,1])

    n = size(D, 1)



    # Função de mapeamento (igual à do QAP)
    function keys_to_permutation_tsp(keys::Vector{Float64})::Vector{Int}
        return sortperm(keys)
    end

    # Função de custo TSP (pode ser definida fora se preferir)
    function calculate_tsp_cost(route::Vector{Int}, dist_matrix::Matrix{Float64})
        cost = 0.0
        num_cities = length(route)
        for i in 1:num_cities
            cost += dist_matrix[route[i], route[i % num_cities + 1]]
        end
        return cost
    end


    # --- 1. Inicialização ---
    swarm = [ParticleRKTSP(n) for _ in 1:swarm_size]
    gbest_position = Vector{Float64}(undef, n)
    gbest_cost = Inf
    v_max = v_max_factor # Limite de velocidade (range das chaves é ~1.0)

    # Inicializar pbest e gbest
    for particle in swarm
        permutation = keys_to_permutation_tsp(particle.position)
        cost = calculate_tsp_cost(permutation, D) # Usa a função de custo TSP

        particle.pbest_position = copy(particle.position)
        particle.pbest_cost = cost

        if cost < gbest_cost
            gbest_cost = cost
            gbest_position = copy(particle.position)
        end
    end

    # --- 2. Ciclo Iterativo do PSO ---
    for iter in 1:max_iter
        for particle in swarm
            # Atualizar Velocidade
            r1 = rand(n); r2 = rand(n)
            particle.velocity = (w * particle.velocity) .+
                                (c1 * r1 .* (particle.pbest_position - particle.position)) .+
                                (c2 * r2 .* (gbest_position - particle.position))

            # Limitar velocidade
            clamp!(particle.velocity, -v_max, v_max)

            # Atualizar Posição (Chaves)
            particle.position += particle.velocity
            # Opcional: manter chaves em [0,1] (pode não ser necessário)
            particle.position .= max.(0.0, min.(1.0, particle.position))

            # Avaliar Nova Posição
            new_permutation = keys_to_permutation_tsp(particle.position)
            new_cost = calculate_tsp_cost(new_permutation, D)

            # Atualizar pbest e gbest
            if new_cost < particle.pbest_cost
                particle.pbest_cost = new_cost
                particle.pbest_position = copy(particle.position)
                if new_cost < gbest_cost
                    gbest_cost = new_cost
                    gbest_position = copy(particle.position)
                     # println("Iter $iter (PSO): Novo melhor custo = $gbest_cost") # Opcional
                end
            end
        end # Fim loop partículas
    end # Fim loop iterações

    best_route_overall = keys_to_permutation_tsp(gbest_position)
    return best_route_overall, gbest_cost
end