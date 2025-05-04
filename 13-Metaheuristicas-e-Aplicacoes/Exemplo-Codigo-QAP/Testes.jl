include("QAP_GA.jl")
include("QAP_ACO.jl")
include("QAP_PSO.jl")
include("QAP_TS.jl")


# ----------------------------------------------------------
# Exemplo de Execução
# ----------------------------------------------------------
# if abspath(PROGRAM_FILE) == @__FILE__

println("--- Exemplo de Execução GA para QAP ---")

# Definir um problema QAP pequeno (exemplo Nugent12, usar dados reais seria melhor)
# Para demonstração, usaremos dados aleatórios
N_example = 300 # Tamanho pequeno para teste rápido
Random.seed!(123) # Para reprodutibilidade
F_example = rand(N_example, N_example) .* 10
D_example = rand(N_example, N_example) .* 100
# Zerar diagonais (fluxo/distância de/para si mesmo)
for i in 1:N_example
    F_example[i, i] = 0.0
    D_example[i, i] = 0.0
    # Tornar simétrico (opcional, mas comum em QAP)
    for j in i+1:N_example
        F_example[j, i] = F_example[i, j]
        D_example[j, i] = D_example[i, j]
    end
end

println("Matriz de Fluxo (F):")
display(F_example)
println("\nMatriz de Distância (D):")
display(D_example)
println("-"^30)

# Parâmetros do GA (Exemplos, precisam de ajuste!)
pop_size_ga = 100
num_generations_ga = 300
pc = 0.85 # Crossover rate
pm = 0.10 # Mutation rate (por indivíduo)
tourn_size = 3
n_elite = Int(floor(0.05*pop_size_ga))

# Executar o GA
best_sol_ga, best_cost_ga, history_ga = genetic_algorithm_qap(
    F_example, D_example, N_example, pop_size_ga, num_generations_ga, pc, pm,
    tourn_size, n_elite)

# Resultados Finais
println("\n--- Resultados Finais GA ---")
println("Melhor Permutação Encontrada: ", best_sol_ga)
println("Custo QAP da Melhor Solução: ", best_cost_ga)


# --- Bloco de execução do PSO ---
println("="^40)
println("--- Executando PSO (RK) para QAP ---")
println("="^40)
# Parâmetros do PSO (Exemplos, precisam de ajuste!)
swarm_size_pso = 100
num_iterations_pso = 300
w_pso = 0.5      # Coeficiente de inércia
c1_pso = 1.5     # Cognitivo
c2_pso = 0.8     # Social
v_max_pso = 0.8 # Limite de velocidade (ajustar baseado na escala das chaves)

# Executar o PSO
best_sol_pso, best_cost_pso, history_pso = pso_rk_qap(
    F_example, D_example, N_example,  swarm_size_pso, 
    num_iterations_pso, w_pso, c1_pso, c2_pso, v_max_pso)

# Resultados Finais PSO
println("\n--- Resultados Finais PSO (RK) ---")
println("Melhor Permutação Encontrada (PSO): ", best_sol_pso)
println("Custo QAP da Melhor Solução (PSO): ", best_cost_pso)
println("="^40)


# --- Comparação Simples ---
println("\n--- Comparação Simples (Exemplo Aleatório N=$N_example) ---")
println("Melhor Custo GA: $best_cost_ga")
println("Melhor Custo PSO: $best_cost_pso")


# --- Bloco de execução da Busca Tabu ---
println("="^40)
println("--- Executando Busca Tabu para QAP ---")
println("="^40)
# Parâmetros da TS (Exemplos, precisam de ajuste!)
num_iterations_ts = 300 # Número total de iterações
# Duração Tabu: Um valor comum é algo relacionado a sqrt(N) ou log(N), ou fixo pequeno
tabu_tenure_ts = max(5, round(Int, sqrt(N_example)*2)) # Exemplo simples dependente de N
# Tamanho da vizinhança: null para completa, ou um número (e.g., N) para amostrar
neighbor_sample_size_ts = N_example * 2 # Avalia 2N vizinhos aleatórios por iteração

println("Duração Tabu (Tenure): $tabu_tenure_ts")
println("Tamanho Amostra Vizinhança: $neighbor_sample_size_ts")

# Executar a Busca Tabu
best_sol_ts, best_cost_ts, history_ts = tabu_search_qap(
    F_example, D_example, N_example,
    num_iterations_ts, tabu_tenure_ts, neighbor_sample_size_ts
)

# Resultados Finais TS
println("\n--- Resultados Finais Busca Tabu ---")
println("Melhor Permutação Encontrada (TS): ", best_sol_ts)
println("Custo QAP da Melhor Solução (TS): ", best_cost_ts)
println("="^40)


# --- Bloco de execução do ACO ---
println("="^40)
println("--- Executando ACO para QAP ---")
println("="^40)
# Parâmetros do ACO (Exemplos, precisam de ajuste!)
num_ants_aco = 100        # Número de formigas
num_iterations_aco = 300 # Número de iterações
alpha_aco = 1.0          # Importância feromônio
beta_aco = 2.0           # Importância heurística (eta=1 aqui, então beta tem menos efeito)
rho_aco = 0.2            # Taxa de evaporação
q0_aco = 0.9             # Probabilidade de explotação (escolher o melhor)
tau0_aco = 0.1           # Feromônio inicial

# Executar o ACO
best_sol_aco, best_cost_aco, history_aco = aco_qap(
    F_example, D_example, N_example,
    num_ants_aco, num_iterations_aco,
    alpha_aco, beta_aco, rho_aco, q0_aco, tau0_aco
)

# Resultados Finais ACO
println("\n--- Resultados Finais ACO ---")
println("Melhor Permutação Encontrada (ACO): ", best_sol_aco)
println("Custo QAP da Melhor Solução (ACO): ", best_cost_aco)
println("="^40)


# --- Comparação Final ---
println("\n--- Comparação FINAL (Exemplo Aleatório N=$N_example) ---")
println("Melhor Custo GA: $best_cost_ga")
println("Melhor Custo PSO: $best_cost_pso")
println("Melhor Custo TS: $best_cost_ts")
println("Melhor Custo ACO: $best_cost_aco")


# Plotar convergência de todos 
p = plot(1:num_generations_ga, history_ga, label="GA", yscale=:log10,
     xlabel="Geração/Iteração", ylabel="Melhor Custo QAP (log scale)",
     title="Convergência GA vs PSO vs TS vs ACO para QAP (N=$N_example)")
plot!(p, 1:num_iterations_pso, history_pso, label="PSO (RK)")
plot!(p, 1:num_iterations_ts, history_ts, label="TS")
plot!(p, 1:num_iterations_aco, history_aco, label="ACO")
display(p) # Mostra o plot
# savefig("convergencia_todas_qap.png")
