# using Pkg
# Pkg.add("Plots")
# Pkg.add("GraphPlot")
# Pkg.add("Graphs")
# Pkg.add("SimpleWeightedGraphs")
# Pkg.add("GraphRecipes")

using Plots, GraphPlot, Graphs, SimpleWeightedGraphs, GraphRecipes, Random
using Colors, HiGHS, JuMP

## O problema de fluxo máximo

function edmonds_karp(grafo, origem, destino)
    
    n = nv(grafo)
    fluxo_maximo = 0
    rede_residual = copy(grafo) # Copia o grafo para criar a rede residual

    while true
        # println(weights(rede_residual))
        caminho = bfs(rede_residual, origem, destino) # Função auxiliar BFS (definida abaixo)

        if isempty(caminho)  # Se não há caminho de aumento
            break
        end

        # Encontra a capacidade residual mínima no caminho
        cr_min = Inf
        for i in 1:(length(caminho) - 1)
            u, v = caminho[i], caminho[i+1]
            cr_min = min(cr_min, weights(rede_residual)[u,v])
        end
        # println(cr_min)
        # Aumenta o fluxo ao longo do caminho
        for i in 1:(length(caminho) - 1)
            u, v = caminho[i], caminho[i+1]
            weights(rede_residual)[u, v] -= cr_min
           
        end
        # println(weights(rede_residual))

        fluxo_maximo += cr_min

    end
    println("O Fluxo máximo entre $origem e $destino é de $fluxo_maximo")
    return fluxo_maximo, rede_residual
end

function bfs(grafo, origem, destino)
    n = nv(grafo)
    visitados = falses(n)
    fila = [origem]
    precedentes = fill(0, n)

    visitados[origem] = true

    while !isempty(fila)
        u = popfirst!(fila)

        if u == destino
            caminho = [destino]
            no_atual = destino
            while no_atual != origem
                no_atual = precedentes[no_atual]
                pushfirst!(caminho, no_atual)
            end
            return caminho
        end

        for v in outneighbors(grafo, u)
            if !visitados[v] && weights(grafo)[u, v] > 0
                visitados[v] = true
                precedentes[v] = u
                push!(fila, v)

            end
        end
    end
    return []  # Retorna um vetor vazio se não houver caminho
end

## Resolvendo o exemplo da aula 
n = 6 # Número de vértices
grafo = SimpleWeightedDiGraph(n)
add_edge!(grafo, 1, 2, 50)
add_edge!(grafo, 1, 3, 60)
add_edge!(grafo, 2, 4, 40)
add_edge!(grafo, 2, 5, 60)
add_edge!(grafo, 3, 4, 80)
add_edge!(grafo, 3, 5, 60)
add_edge!(grafo, 4, 6, 50)
add_edge!(grafo, 5, 6, 70)

gplot(grafo, nodelabel = ["O", "A", "B", "C", "D", "T"], edgelabel = [50, 60, 40, 60, 80, 60, 50, 70])
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

#Modelo de PLI
modelo = Model(HiGHS.Optimizer)
# set_silent(modelo)

for e in edges(grafo)
    println(e.dst)
    println(e.src)
    println(e.weight)
end

# Variáveis de decisão (fluxo )
@variable(modelo, 0 <= x[e in edges(grafo)] <= e.weight)
@variable(modelo, F >= 0)

@objective(modelo, Max, F)

@expression(modelo, entrando_em[v in vertices(grafo)], 
    sum(x[e] for e in edges(grafo) if e.dst == v))

    ##poderia ser


@expression(modelo, saindo_de[v in vertices(grafo)], 
    sum(x[e] for e in edges(grafo) if e.src == v))

    ##poderia ser

vertices_fluxo = 2:nv(grafo)-1    
@constraint(modelo, 
    conserva_fluxo[v in vertices_fluxo],
    entrando_em[v] == saindo_de[v])

@constraint(modelo, saindo_de[1] == F)
@constraint(modelo, entrando_em[nv(grafo)] == F)

print(modelo)


optimize!(modelo)

# Imprimindo a solução
if termination_status(modelo) == OPTIMAL
    println("Solução ótima encontrada! Fluxo Máximo: ", objective_value(modelo))
        for e in edges(grafo)
            if value(x[e]) > 0.5
                println(e, " tem fluxo " , value(x[e]))
            end
        end
else
    println("Solução ótima não encontrada. Status: ", termination_status(modelo))
end



## Um exemplo um pouco maior

function generate_flow_graph(n, m, min_f, max_f)
    @assert n >= m  # Garante que há nós suficientes para as camadas

    graph = SimpleWeightedDiGraph(n)
    layers = Dict(k => Int[] for k = 1:m)

    # Adiciona os nós de origem e destino às camadas 1 e m
    push!(layers[1], 1)
    push!(layers[m], n)

    # Distribui os nós intermediários nas camadas
    for k = 2:m-1
        push!(layers[k], k) 
    end
    for v = m:n-1
        push!(layers[rand(2:m-1)], v)
    end

    # Conecta os nós entre camadas adjacentes
    for ℓ = 1:m-1
        for src in layers[ℓ], dst in layers[ℓ+1]
            cap = Int(rand(min_f: max_f))
            add_edge!(graph, src, dst, cap)
        end
    end


    return graph
end

n = 20  # Número de nós
m = 5   # Número de camadas
min_f = 10 
max_f = 100
grafo = generate_flow_graph(n, m, min_f, max_f)

# Imprime o grafo 
cg = weights(grafo)

capacidades = Any[]

for i = 1: n, j = 1:n
    if cg[i,j] != 0 
        push!(capacidades, cg[i,j])
    end
end

gplot(grafo, nodelabel = 1:n, edgelabel = capacidades)

#Modelo de PLI
modelo = Model(HiGHS.Optimizer)
# set_silent(modelo)

for e in edges(grafo)
    println(e.dst)
    println(e.src)
    println(e.weight)
end

# Variáveis de decisão (fluxo )
@variable(modelo, 0 <= x[e in edges(grafo)] <= e.weight)
@variable(modelo, F >= 0)

@objective(modelo, Max, F)

@expression(modelo, entrando_em[v in vertices(grafo)], 
    sum(x[e] for e in edges(grafo) if e.dst == v))

    ##poderia ser


@expression(modelo, saindo_de[v in vertices(grafo)], 
    sum(x[e] for e in edges(grafo) if e.src == v))

    ##poderia ser

vertices_fluxo = 2:nv(grafo)-1    
@constraint(modelo, 
    conserva_fluxo[v in vertices_fluxo],
    entrando_em[v] == saindo_de[v])

@constraint(modelo, saindo_de[1] == F)
@constraint(modelo, entrando_em[nv(grafo)] == F)

print(modelo)


optimize!(modelo)

# Imprimindo a solução
if termination_status(modelo) == OPTIMAL
    println("Solução ótima encontrada! Fluxo Máximo: ", objective_value(modelo))
        for e in edges(grafo)
            if value(x[e]) > 0.5
                println(e, " tem fluxo " , value(x[e]))
            end
        end
else
    println("Solução ótima não encontrada. Status: ", termination_status(modelo))
end

## imprimir de um jeito mais interessante:
using Colors

Random.seed!(0)
labels = ["V$i" for i = 1:nv(grafo)]
colors = [
    RGB(0.0, 1.0, 0.0);
    fill(RGB(0.5, 0.7, 0.9), nv(grafo) - 2);
    RGB(1.0, 0.0, 0.0)
]

cg = weights(grafo)
edgecolors = [
    RGB(value(x[e]) / e.weight, 0.2, 0.3) for e in edges(grafo)]

gplot(grafo, nodelabel=labels, nodefillc=colors, edgestrokec=edgecolors)
