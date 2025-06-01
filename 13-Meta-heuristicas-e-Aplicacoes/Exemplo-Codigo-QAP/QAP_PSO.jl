# ==========================================================
# Continuação Aula 3: Aplicações - QAP
# Implementação com Otimização por Enxame de Partículas (PSO)
# Usando Random Keys (RKPSO)
# ==========================================================

# Nota: As funções calculate_qap_cost, F_example, D_example, N_example
# definidas anteriormente na seção do GA são reutilizadas aqui.

# ----------------------------------------------------------
# Estrutura de Dados para Partícula (RKPSO)
# ----------------------------------------------------------
mutable struct ParticleRK
    position::Vector{Float64}        # Vetor de chaves aleatórias (tamanho N)
    velocity::Vector{Float64}        # Vetor de velocidades (tamanho N)
    pbest_position::Vector{Float64}  # Melhor posição (chaves) encontrada pela partícula
    pbest_cost::Float64              # Custo QAP da pbest_position

    ParticleRK(N::Int) = new(
        rand(N),                     # Posição inicial aleatória [0, 1)
        zeros(N),                    # Velocidade inicial zero
        zeros(N),                    # pbest inicial (será atualizado)
        Inf                          # pbest_cost inicial infinito (minimização)
    )
end

# ----------------------------------------------------------
# Função de Mapeamento: Chaves Aleatórias -> Permutação
# ----------------------------------------------------------
"""
Converte um vetor de chaves aleatórias em uma permutação.
Ordena as chaves e retorna a ordem dos índices originais.
"""
function keys_to_permutation(keys::Vector{Float64})::Vector{Int}
    # sortperm retorna os índices que ordenariam o vetor `keys`
    return sortperm(keys)
end

# ----------------------------------------------------------
# Estrutura Principal do PSO com Random Keys (RKPSO)
# ----------------------------------------------------------

"""
Função principal do PSO com Random Keys para resolver o QAP.
"""
function pso_rk_qap(
    F::Matrix{Float64},         # Matriz de Fluxo
    D::Matrix{Float64},         # Matriz de Distância
    N::Int,                     # Tamanho do problema
    swarm_size::Int,            # Tamanho do enxame
    num_iterations::Int,        # Número de iterações (critério de parada)
    w::Float64,                 # Coeficiente de inércia
    c1::Float64,                # Coeficiente cognitivo
    c2::Float64,                # Coeficiente social
    v_max::Union{Float64, Nothing}=nothing # Limite de velocidade (opcional)
)
    # --- 1. Inicialização ---
    println("Inicializando enxame (RKPSO)...")
    swarm = [ParticleRK(N) for _ in 1:swarm_size]
    gbest_position = Vector{Float64}(undef, N) # Melhor posição global (chaves)
    gbest_cost = Inf                        # Melhor custo global

    # Inicializar pbest e gbest
    for particle in swarm
        permutation = keys_to_permutation(particle.position)
        cost = calculate_qap_cost(permutation, F, D)

        particle.pbest_position = copy(particle.position)
        particle.pbest_cost = cost

        if cost < gbest_cost
            gbest_cost = cost
            gbest_position = copy(particle.position)
        end
    end
    println("Melhor custo inicial: $gbest_cost")

    println("Iniciando ciclo do PSO ($num_iterations iterações)...")
    history_best_cost_pso = Float64[] # Para acompanhar a convergência

    # --- 2. Ciclo Iterativo do PSO ---
    for iter in 1:num_iterations
        # Para cada partícula no enxame
        for particle in swarm
            # --- 2.1 Atualizar Velocidade ---
            r1 = rand(N) # Vetor de números aleatórios [0,1] para componente cognitivo
            r2 = rand(N) # Vetor de números aleatórios [0,1] para componente social

            # Aplica a equação de velocidade a cada dimensão (chave)
            particle.velocity = (w * particle.velocity) +
                                (c1 * r1 .* (particle.pbest_position - particle.position)) +
                                (c2 * r2 .* (gbest_position - particle.position))

            # Limitar velocidade (opcional)
            if v_max !== nothing
                clamp!(particle.velocity, -v_max, v_max)
            end

            # --- 2.2 Atualizar Posição (Chaves) ---
            particle.position += particle.velocity
            # Nota: Não é estritamente necessário limitar as chaves a [0,1],
            # mas pode ajudar a evitar valores muito grandes/pequenos.
            # clamp!(particle.position, 0.0, 1.0) # Descomente se desejar limitar

            # --- 2.3 Avaliar Nova Posição ---
            new_permutation = keys_to_permutation(particle.position)
            new_cost = calculate_qap_cost(new_permutation, F, D)

            # --- 2.4 Atualizar pbest e gbest ---
            # Atualizar pbest da partícula
            if new_cost < particle.pbest_cost
                particle.pbest_cost = new_cost
                particle.pbest_position = copy(particle.position)

                # Atualizar gbest se necessário
                if new_cost < gbest_cost
                    gbest_cost = new_cost
                    gbest_position = copy(particle.position)
                    println("Iter $iter: Novo melhor custo global (PSO) = $gbest_cost")
                end
            end
        end # Fim do loop das partículas

        push!(history_best_cost_pso, gbest_cost)

        # Opcional: Printar progresso
         if iter % 50 == 0 || iter == num_iterations
             println("Iter $iter/$num_iterations concluída (PSO). Melhor Custo Atual: $gbest_cost")
         end

    end # Fim do loop de iterações

    println("Otimização PSO (RK) concluída.")
    # A melhor solução é a permutação gerada pelas chaves em gbest_position
    best_solution_pso = keys_to_permutation(gbest_position)
    println("Melhor solução (permutação) encontrada: $best_solution_pso")
    println("Melhor custo encontrado: $gbest_cost")

    return best_solution_pso, gbest_cost, history_best_cost_pso
end


