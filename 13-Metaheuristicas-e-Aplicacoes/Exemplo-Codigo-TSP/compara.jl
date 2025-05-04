using Random, LinearAlgebra, DataFrames

include("algo_geneticos.jl")
include("busca_local_iterada.jl")
include("busca_tabu.jl")
include("colonia_formigas.jl")
include("enxame_particulas.jl")
include("recozimento_sim.jl")

# Exemplo de uso:

n = 13
coordinates = rand(n, 2)
D = [norm(coordinates[i,:] - coordinates[j,:]) for i=1:n, j=1:n]
@time bt_route, bt_cost = tsp_bt(D)
@time ag_route, ag_cost = tsp_ag(D)
@time sa_route, sa_cost = tsp_sa(D)
@time ils_route, ils_cost = tsp_ils(D)
@time aco_route, aco_cost = tsp_aco(D)
@time pso_route, pso_cost = tsp_pso_rk(D)
println("Resultados n=8: \nBT=\t$bt_cost, \nAG=\t$ag_cost, \nSA=\t$sa_cost, \nILS=\t$ils_cost, \nACO=\t$aco_cost, \nPSO=\t$pso_cost")

using Plots
plotly() # Ou gr()
default(size = (1000,800))
using Printf

println("\n" * "="^50)
println("Plotando Rotas Finais Encontradas pelas Metaheurísticas (N=$n)")
println("="^50 * "\n")

# --- Função Auxiliar para Plotar Rota (reutilizada/adaptada) ---
function plot_tsp_final_route(cities_coords, route, cost, algorithm_name)
    num_cities_plot = size(cities_coords, 1)
    plot_title = "$algorithm_name - Melhor Rota (Custo: $(@sprintf("%.2f", cost)))"
    p = plot(title=plot_title, xlabel="x", ylabel="y", aspect_ratio=:equal, legend=false)
    # Plotar cidades como pontos numerados
    scatter!(p, cities_coords[:, 1], cities_coords[:, 2], markersize=5, marker=:circle, color=:grey)
    for i in 1:num_cities_plot
        annotate!(p, cities_coords[i,1]+0.1, cities_coords[i,2]+0.1, text(string(i), 8, :darkgrey))
    end
    # Plotar a rota (conectando ao início)
    if !isempty(route) # Verifica se a rota não está vazia
        route_coords_x = [cities_coords[node, 1] for node in vcat(route, route[1])]
        route_coords_y = [cities_coords[node, 2] for node in vcat(route, route[1])]
        plot!(p, route_coords_x, route_coords_y, linewidth=2, linecolor=:red)
    else
        println("Aviso: Rota vazia para $algorithm_name.")
    end
    return p # Retorna o objeto do plot
end

# --- Gerar e Exibir os Plots ---

# Plot Busca Tabu
p_bt = plot_tsp_final_route(coordinates, bt_route, bt_cost, "Busca Tabu")
display(p_bt)
# savefig(p_bt, "tsp_final_bt.png")

# Plot Algoritmo Genético
p_ag = plot_tsp_final_route(coordinates, ag_route, ag_cost, "Algoritmo Genético")
display(p_ag)
# savefig(p_ag, "tsp_final_ag.png")

# Plot Simulated Annealing
p_sa = plot_tsp_final_route(coordinates, sa_route, sa_cost, "Simulated Annealing")
display(p_sa)
# savefig(p_sa, "tsp_final_sa.png")

# Plot Iterated Local Search
p_ils = plot_tsp_final_route(coordinates, ils_route, ils_cost, "Iterated Local Search")
display(p_ils)
# savefig(p_ils, "tsp_final_ils.png")

# Plot ACO
p_aco = plot_tsp_final_route(coordinates, aco_route, aco_cost, "ACO")
display(p_aco)
# savefig(p_aco, "tsp_final_aco.png")

# Plot PSO (RK)
p_pso = plot_tsp_final_route(coordinates, pso_route, pso_cost, "PSO (Random Keys)")
display(p_pso)
# savefig(p_pso, "tsp_final_pso.png")

plot_combinado = plot(p_bt, p_ag, p_sa, p_ils, p_aco, p_pso, layout=(2, 3), size=(1200, 800))
# savefig(plot_combinado, "tsp_final_combinado.png")
println("\nPlots das rotas finais gerados.")


println("\n" * "="^50)
println("Plotando TODAS as Rotas Finais no MESMO Gráfico (N=$n)")
println("="^50 * "\n")

# --- Criar o Plot Base com as Cidades ---
plot_title = "Comparativo de Rotas TSP (N=$n)"
p_all_routes = plot(title=plot_title, xlabel="x", ylabel="y", aspect_ratio=:equal, legend=:outertopright) # Habilita legenda

# Plotar cidades como pontos numerados (uma vez)
scatter!(p_all_routes, coordinates[:, 1], coordinates[:, 2], markersize=5, marker=:circle, color=:black, label="Cidades")
for i in 1:n
    annotate!(p_all_routes, coordinates[i,1]+0.1, coordinates[i,2]+0.1, text(string(i), 8, :darkgrey))
end

# --- Definir cores e nomes para cada algoritmo ---
algorithms = [
    ("Busca Tabu", bt_route, bt_cost, :blue),
    ("Alg. Genético", ag_route, ag_cost, :red),
    ("Sim. Annealing", sa_route, sa_cost, :green),
    ("ILS", ils_route, ils_cost, :purple),
    ("ACO", aco_route, aco_cost, :orange),
    ("PSO (RK)", pso_route, pso_cost, :cyan)
]

# --- Plotar cada rota sobre o gráfico base ---
for (name, route, cost, color) in algorithms
    println("Plotando Rota: $name (Custo: $(@sprintf("%.2f", cost)))")
    if !isempty(route)
        legend_label = "$name: $(@sprintf("%.2f", cost))"
        route_coords_x = [coordinates[node, 1] for node in vcat(route, route[1])]
        route_coords_y = [coordinates[node, 2] for node in vcat(route, route[1])]
        plot!(p_all_routes, route_coords_x, route_coords_y, linewidth=2, linecolor=color, label=legend_label)
    else
        println("Aviso: Rota vazia para $name, não será plotada.")
    end
end

# --- Exibir o Plot Combinado ---
display(p_all_routes)
println("\nPlot combinado das rotas finais gerado.")

# Salvar o plot combinado (opcional)
# savefig(p_all_routes, "tsp_final_todas_rotas.png", size=(1000,800)) # Aumentar tamanho pode ajudar

## COMO SÃO OS RESULTADOS SE N AUMENTAR?!
# Criar um DataFrame para armazenar os resultados para n variando
results = DataFrame(
    N = Int64[],
    Best_BT = Float64[],
    Time_BT = Float64[],
    Best_AG = Float64[],
    Time_AG = Float64[],
    Best_SA = Float64[],
    Time_SA = Float64[],
    Best_ILS = Float64[],
    Time_ILS = Float64[],
    Best_ACO = Float64[], 
    Time_ACO = Float64[], # Novo
    Best_PSO = Float64[], 
    Time_PSO = Float64[]  # Novo
)

# Loop para testar diferentes valores de n
for n in 5:30
    coordinates = rand(n, 2)
    D = [norm(coordinates[i,:] - coordinates[j,:]) for i=1:n, j=1:n]
    # Busca Tabu
    bt_time = @elapsed bt_route, bt_cost = tsp_bt(D)
    # Algoritmos Genéticos
    ag_time = @elapsed ag_route, ag_cost = tsp_ag(D)
    # Simulated Annealing
    sa_time = @elapsed sa_route, sa_cost = tsp_sa(D)
    # Busca Local Iterada
    ils_time = @elapsed ils_route, ils_cost = tsp_ils(D)
    # Colonia de Formigas
    aco_time = @elapsed aco_route, aco_cost = tsp_aco(D)   # Novo
    #Enxame de Particulas
    pso_time = @elapsed pso_route, pso_cost = tsp_pso_rk(D) # Novo

    # Armazenar os resultados
    push!(results, (
        n, bt_cost, bt_time, ag_cost, ag_time, sa_cost, sa_time, ils_cost,
        ils_time, aco_cost, aco_time, pso_cost, pso_time))
    println("Concluído para n = $n")
end

# Exibir o DataFrame
println("\nDataFrame de Resultados Completos:")
println(results)

# --- Atualizar Plots ---
using Plots, StatsPlots
gr()

# Gráfico 1: Melhores Soluções 
plot_sol = @df results plot(:N,
    [:Best_BT :Best_AG :Best_SA :Best_ILS :Best_ACO :Best_PSO],
    title = "Comparação de Heurísticas - Qualidade da Solução (TSP)",
    label = ["BT" "AG" "SA" "ILS" "ACO" "PSO"],
    xlabel = "Número de Cidades (n)",
    ylabel = "Melhor Custo (Distância Total)",
    legend = :topleft,
    marker = [:circle :square :diamond :utriangle :star5 :hexagon],
    linewidth = 2)
display(plot_sol) # Mostra o gráfico

# Gráfico 2: Tempos de Execução 
plot_time = @df results plot(:N,
    [:Time_BT :Time_AG :Time_SA :Time_ILS :Time_ACO :Time_PSO],
    title = "Comparação de Heurísticas - Desempenho Computacional (TSP)",
    label = ["BT" "AG" "SA" "ILS" "ACO" "PSO"],
    xlabel = "Número de Cidades (n)",
    ylabel = "Tempo de Execução (s, log scale)",
    yscale = :log10,  # Escala logarítmica
    legend = :topleft,
    marker = [:circle :square :diamond :utriangle :star5 :hexagon],
    linewidth = 2)
display(plot_time)




