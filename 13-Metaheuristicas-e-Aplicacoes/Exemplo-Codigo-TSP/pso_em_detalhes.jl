# Exemplo de uso:

n = 5
coordinates = rand(n, 2)
D = [norm(coordinates[i,:] - coordinates[j,:]) for i=1:n, j=1:n]

swarm_size=max(5, size(D,1))   # Tamanho do enxame
max_iter=3                      # Iterações
w=0.7                           # Inércia
c1=1.5                          # Cognitivo
c2=1.5                          # Social
v_max_factor=0.5                # Fator para Vmax (0.5 = 50% do range [0,1])

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

# particle = swarm[1]
# Inicializar pbest e gbest
for particle in swarm
    println("particle.position ", particle.position)    
    permutation = keys_to_permutation_tsp(particle.position)
    
    cost = calculate_tsp_cost(permutation, D) # Usa a função de custo TSP
    println("permutation ", permutation, " cost ", cost, "\n")
    particle.pbest_position = copy(particle.position)
    particle.pbest_cost = cost

    if cost < gbest_cost
    gbest_cost = cost
    gbest_position = copy(particle.position)
    end
    
end
println("gbest_position ", gbest_position, " gbest_cost ", gbest_cost, "\n")

# --- 2. Ciclo Iterativo do PSO ---
for iter in 1:max_iter
    println(" ")
    println("iter ", iter)
    
    for particle in swarm
        # Atualizar Velocidade
        r1 = rand(n); r2 = rand(n)
        particle.velocity = (w * particle.velocity) .+
                        (c1 * r1 .* (particle.pbest_position - particle.position)) .+
                        (c2 * r2 .* (gbest_position - particle.position))

        # Limitar velocidade
        clamp!(particle.velocity, -v_max, v_max)

        # Atualizar Posição (Chaves)
        println("atual ", particle.position)
        
        particle.position += particle.velocity
        # Opcional: manter chaves em [0,1] (pode não ser necessário)
        #particle.position .= max.(0.0, min.(1.0, particle.position))

        println("nova ", particle.position, "\n")
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




#TENTANDO MELHORAR O PSORK
# --- Definir a Instância TSP para o Teste ---
println("Definindo instância TSP para teste de parâmetros...")
n_test = 20 # Tamanho do problema (ajuste conforme necessário)
Random.seed!(42) # Semente para gerar a mesma instância
coordinates_test = rand(n_test, 2) .* 100
D_test = zeros(Float64, n_test, n_test)
for i = 1:n_test, j = i+1:n_test
    dist = norm(coordinates_test[i,:] - coordinates_test[j,:])
    D_test[i, j] = D_test[j, i] = dist
end
println("Instância TSP com N=$n_test criada.")

# --- Parâmetros Fixos do PSO para o Teste ---
# (Ajuste conforme necessário, exceto w, c1, c2)
test_swarm_size = 30
test_max_iter = 150 # Mais iterações para dar chance aos parâmetros
test_v_max_factor = 0.5

# --- Definir os Ranges dos Parâmetros a Testar ---
w_range = 0.0:0.1:1.0
c1_range = 0.5:0.5:4.5
c2_range = 0.5:0.5:4.5

# --- Estrutura para Armazenar Resultados ---
results_pso_tuning = DataFrame(w=Float64[], c1=Float64[], c2=Float64[], best_cost=Float64[], run_time=Float64[])
num_runs_per_config = 3 # Número de execuções para cada combinação (reduzir variância)

# --- Loop de Teste dos Parâmetros ---
println("\nIniciando teste de parâmetros PSO (w, c1, c2)...")
total_configs = length(w_range) * length(c1_range) * length(c2_range)
config_count = 0

for w_val in w_range
    for c1_val in c1_range
        for c2_val in c2_range
            config_count += 1
            println("Testando Config [ $config_count / $total_configs ]: w=$w_val, c1=$c1_val, c2=$c2_val (Executando $num_runs_per_config vezes)")

            run_costs = Float64[]
            run_times = Float64[]

            for run in 1:num_runs_per_config
                # Medir tempo e executar PSO com os parâmetros atuais
                exec_time = @elapsed begin
                    # Garante que a semente aleatória interna do PSO mude a cada run
                    Random.seed!() # Reseta a semente global antes de chamar
                    best_route, best_cost = tsp_pso_rk(D_test;
                                                       swarm_size=test_swarm_size,
                                                       max_iter=test_max_iter,
                                                       w=w_val,
                                                       c1=c1_val,
                                                       c2=c2_val,
                                                       v_max_factor=test_v_max_factor)
                end
                push!(run_costs, best_cost)
                push!(run_times, exec_time)
                @printf("  Run %d: Custo=%.2f, Tempo=%.3fs\n", run, best_cost, exec_time)
            end

            # Calcular média dos resultados para esta configuração
            avg_cost = sum(run_costs) / num_runs_per_config
            avg_time = sum(run_times) / num_runs_per_config

            # Armazenar resultados médios no DataFrame
            push!(results_pso_tuning, (w=w_val, c1=c1_val, c2=c2_val, best_cost=avg_cost, run_time=avg_time))

        end # Fim loop c2
    end # Fim loop c1
end # Fim loop w

println("\nTeste de parâmetros concluído.")

# --- Análise dos Resultados ---
println("\n--- Resultados do Ajuste de Parâmetros PSO ---")
# Ordenar por melhor custo médio encontrado
sort!(results_pso_tuning, :best_cost)

println("Melhores 5 Configurações encontradas (menor custo médio):")
display(first(results_pso_tuning, 5))

println("\nPiores 5 Configurações encontradas (maior custo médio):")
display(last(results_pso_tuning, 5))

# Encontrar a melhor configuração geral
best_config = results_pso_tuning[1, :] # Primeira linha após ordenar por custo
println("\nMelhor Configuração Geral:")
println("  w  = ", best_config.w)
println("  c1 = ", best_config.c1)
println("  c2 = ", best_config.c2)
println("  Custo Médio = ", best_config.best_cost)
println("  Tempo Médio = ", best_config.run_time)

# --- Opcional: Visualização dos Resultados (Exemplo Simples) ---
# using Plots
plotly()

# Plot Custo vs w (pode colorir por c1 ou c2, mas fica complexo)
p_w = plot(xlabel="Coeficiente de Inércia (w)", ylabel="Custo Médio TSP", title="Impacto de w no Custo PSO (N=$n_test)", legend=false)
scatter!(p_w, results_pso_tuning.w, results_pso_tuning.best_cost, marker=:circle, markersize=3)
display(p_w)

# Plot Custo vs c1 (pode colorir por w ou c2)
p_c1 = plot(xlabel="Coeficiente Cognitivo (c1)", ylabel="Custo Médio TSP", title="Impacto de c1 no Custo PSO (N=$n_test)", legend=false)
scatter!(p_c1, results_pso_tuning.c1, results_pso_tuning.best_cost, marker=:circle, markersize=3)
display(p_c1)

# Plot Custo vs c2 (pode colorir por w ou c1)
p_c2 = plot(xlabel="Coeficiente Social (c2)", ylabel="Custo Médio TSP", title="Impacto de c2 no Custo PSO (N=$n_test)", legend=false)
scatter!(p_c2, results_pso_tuning.c2, results_pso_tuning.best_cost, marker=:circle, markersize=3)
display(p_c2)
