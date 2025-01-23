using Pkg
Pkg.add("Plots")
Pkg.add("GraphPlot")
Pkg.add("Graphs")
Pkg.add("SimpleWeightedGraphs")
Pkg.add("GraphRecipes")

using GraphPlot
using GraphRecipes
using Graphs
using Plots
using Random
using SimpleWeightedGraphs


n = 12 # Número de vértices
grafo = SimpleWeightedDiGraph(n)
add_edge!(grafo, 1, 2, 10)
add_edge!(grafo, 1, 3, 7)
add_edge!(grafo, 2, 4, 4)
add_edge!(grafo, 3, 6, 5)
add_edge!(grafo, 3, 5, 8)
add_edge!(grafo, 3, 4, 6)
add_edge!(grafo, 4, 5, 9)
add_edge!(grafo, 4, 9, 8)
add_edge!(grafo, 5, 6, 7)
add_edge!(grafo, 5, 8, 10)
add_edge!(grafo, 5, 9, 20)
add_edge!(grafo, 6, 7, 22)
add_edge!(grafo, 7, 11, 6)
add_edge!(grafo, 7, 10, 9)
add_edge!(grafo, 8, 9, 7)
add_edge!(grafo, 8, 10, 4)
add_edge!(grafo, 9, 10, 7)
add_edge!(grafo, 10, 12, 13)
add_edge!(grafo, 11, 12, 11)

gplot(grafo, nodelabel = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"], edgelabel = [10, 7, 4, 6, 8, 5, 9, 7, 20, 10, 8, 7, 22, 6, 9, 7, 10, 4, 13, 11])
origem = 1
destino = n

fluxo_maximo, rede_residual = edmonds_karp(grafo, origem, destino)

println(weights(grafo))
println(weights(rede_residual))

dif_grafo = copy(grafo);

for i = 1: length(weights(grafo))
    weights(dif_grafo)[i] = weights(grafo)[i] -  weights(rede_residual)[i]
end

println(weights(dif_grafo))

# Imprime o fluxo máximo
cg = weights(dif_grafo)
capacidades = Any[]

for i = 1: n, j = 1:n
    if cg[i,j] != 0 
        push!(capacidades, cg[i,j])
    end
end

gplot(grafo, nodelabel = 1:n, edgelabel = capacidades)