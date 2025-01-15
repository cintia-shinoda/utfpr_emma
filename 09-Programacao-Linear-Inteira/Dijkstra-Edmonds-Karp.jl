using Pkg
Pkg.add("Plots")
Pkg.add("GraphPlot")
Pkg.add("Graphs")
Pkg.add("SimpleWeightedGraphs")
Pkg.add("GraphRecipes")
Pkg.add("Colors")

using Plots, GraphPlot, Graphs, SimpleWeightedGraphs, GraphRecipes, Random, Colors

function dijkstra(grafo, origem)
    n = length(grafo[1,:])
    distancias = fill(Inf, n) # Inicializa distâncias com infinito
    precedentes = fill(0, n) # Inicializa precedentes com zero
    rotulados = falses(n) # Inicializa rotulados com falso

    distancias[origem] = 0

    while !all(rotulados)
        menor_distancia = Inf
        k = 0

        for i in 1:n
            if !rotulados[i] && distancias[i] < menor_distancia
                menor_distancia = distancias[i]
                k = i
            end
        end

        if k == 0
            break # Não há mais nós não rotulados alcançáveis
        end

        rotulados[k] = true

        for j in 1:n
            if grafo[k,j] != Inf && !rotulados[j] # j é sucessor de k e não rotulado
                novo_valor = distancias[k] + grafo[k,j]
                if novo_valor < distancias[j]
                    distancias[j] = novo_valor
                    precedentes[j] = k
                end
            end
        end


    end
        
    return distancias, precedentes

end

function SWG_dijkstra(grafo, origem)
    n = nv(grafo) # nv() pega o número de vértices do grafo
    distancias = fill(Inf, n)
    precedentes = fill(0, n)
    rotulados = falses(n)

    distancias[origem] = 0

    while !all(rotulados)
        menor_distancia = Inf
        k = 0

        for i in 1:n
            if !rotulados[i] && distancias[i] < menor_distancia
                menor_distancia = distancias[i]
                k = i
            end
        end

         if k == 0
            break # Não há mais nós não rotulados alcançáveis
        end

        rotulados[k] = true

        for j in outneighbors(grafo, k) # Itera pelos vizinhos de k
            peso = get_weight(grafo, k, j) # Pega o peso da aresta (k,j)
             if !rotulados[j]
                novo_valor = distancias[k] + peso
                if novo_valor < distancias[j]
                    distancias[j] = novo_valor
                    precedentes[j] = k
                end
            end
        end
    end

    return distancias, precedentes
end

function imprime_caminho(precedentes, origem, destino)
    caminho = [destino]
    no_atual = destino

    while no_atual != origem
        no_anterior = precedentes[no_atual]
        if no_anterior == 0
            println("Não há caminho da origem ao destino.")
            return
        end
        pushfirst!(caminho, no_anterior)  # Insere o nó anterior no início do caminho
        no_atual = no_anterior
    end

    println("Caminho mais curto de ", origem, " para ", destino, ":")
    for i in 1:length(caminho)
        print(caminho[i])
        if i < length(caminho)
            print(" -> ")
        end
    end
    println()
end

function plota_grafo_com_solucao(grafo, distancias, precedentes, origem, destino)
    # Calcula o caminho mais curto (se existir)
    Random.seed!(nv(grafo));
    caminho = [destino]
    no_atual = destino
    while no_atual != origem
        no_anterior = precedentes[no_atual]
        if no_anterior == 0
            println("Não há caminho da origem ao destino.")
            return  # Retorna se não houver caminho
        end
        pushfirst!(caminho, no_anterior)
        no_atual = no_anterior
    end

    # Plota o grafo
    # gplot(grafo, nodelabel=1:nv(grafo))

    # Destaca o caminho da solução (em vermelho)
    arestas_caminho = Tuple{Int,Int}[]
    for i in 1:(length(caminho) - 1)
        push!(arestas_caminho, (caminho[i], caminho[i+1]))
    end

    arestas_caminho
    # Plota o grafo original
    
    edges1 = collect(edges(grafo))
    
    cor_edges = fill("lightgray", length(edges1))
    grossura_edges = fill(0.2, length(edges1))

    for i = 1 : length(arestas_caminho), j = 1:length(edges1)
        if Edge(arestas_caminho[i]) == edges1[j]
            cor_edges[j] = "red"
            grossura_edges[j] = 0.4
        end
    end
    
    
    gplot(grafo, nodelabel=1:nv(grafo), edgestrokec = cor_edges, edgelinewidth = grossura_edges, arrowlengthfrac = 0.02) 
end

# Exemplo de uso:
grafo = [
    0 11 9 Inf Inf Inf Inf Inf Inf;
    Inf 0 Inf 4 8 Inf Inf Inf Inf;
    Inf Inf 0 8 6 Inf Inf Inf Inf;
    Inf Inf Inf 0 Inf 6 5 Inf Inf;
    Inf Inf Inf Inf 0 Inf 6 4 Inf;
    Inf Inf Inf Inf Inf 0 Inf Inf 6;
    Inf Inf Inf Inf Inf Inf 0 Inf 4;
    Inf Inf Inf Inf Inf Inf Inf 0 6;
    Inf Inf Inf Inf Inf Inf Inf Inf 0
]

origem = 1
distancias, precedentes = dijkstra(grafo, origem)

println("Distâncias mínimas a partir do nó ", origem, ": ", distancias)
println("Precedente de cada nó: ", precedentes)


## Um pouco mais interessante!

# Exemplo de uso com SimpleWeightedDiGraph:
origens = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 7, 8]
destinos = [2, 3, 4, 5, 4, 5, 6, 7, 7, 8, 9, 9, 9]
distancias = [11, 9, 4, 8, 8, 6, 6, 5, 6, 4, 6, 4, 6]

grafo = SimpleWeightedDiGraph(origens, destinos, distancias)

gplot(grafo, nodelabel = 1:nv(grafo), edgelabel = distancias)

origem = 1
distancias, precedentes = SWG_dijkstra(grafo, origem)

println("Distâncias mínimas a partir do nó ", origem, ": ", distancias)
println("Precedente de cada nó: ", precedentes)

##Generalizando

# Exemplo com 30 nós e mais arestas:
n = 50
origens = Int[]
destinos = Int[]
distancias = Int[]

# Conecta cada nó aos próximos 3 nós (com pesos aleatórios)
for i in 1:n
    for j in (i+1):(min(i+3, n))
        push!(origens, i)
        push!(destinos, j)
        push!(distancias, Int(rand(1:10))) # Pesos aleatórios entre 1 e 10
    end
end

# Adiciona algumas arestas extras para garantir conexidade e mais caminhos
for i in 1:200  # Adiciona 20 arestas extras aleatórias
    o = rand(1:n)
    d = rand(1:n)
    if o != d
        push!(origens, o)
        push!(destinos, d)
        push!(distancias, Int(rand(1:10)))
    end
end

grafo = SimpleWeightedDiGraph(origens, destinos, distancias)

# Executa o Dijkstra a partir do nó 1
origem = 1
distancias, precedentes = SWG_dijkstra(grafo, origem)

println("Distâncias mínimas a partir do nó ", origem, ": ", distancias)
println("Precedente de cada nó: ", precedentes)

# Plota o grafo (opcional - descomente se tiver o Plots instalado)
gplot(grafo, nodelabel=1:nv(grafo))

## Imprimindo a solução 
origem = 1
destino = 25
distancias, precedentes = SWG_dijkstra(grafo, origem);

imprime_caminho(precedentes, origem, destino)
plota_grafo_com_solucao(grafo, distancias, precedentes, origem, 2)
plota_grafo_com_solucao(grafo, distancias, precedentes, origem, 3)
plota_grafo_com_solucao(grafo, distancias, precedentes, origem, 4)
plota_grafo_com_solucao(grafo, distancias, precedentes, origem, 17)


























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
            print
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



# Função auxiliar BFS para encontrar caminhos de aumento
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

    # Mostra as camadas (opcional - para depuração)
    @show layers


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

dif_grafo = SimpleWeightedDiGraph(n)

for i = 1: n, j = 1:n
    if cg[i,j] != 0 
        push!(capacidades, cg[i,j])
        add_edge!(dif_grafo, i, j, cg[i,j])
    end
end

collect(edges(dif_grafo))

fluxo_maximo

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
edgecolors = Any[]

for i = 1: n, j = 1:n
    if cg[i,j] != 0 
        push!(edgecolors,
        RGB(0.0, 1.0 - cg[i,j]/fluxo_maximo, 0.0))
    end
end

edgecolors

gplot(grafo, nodelabel=labels, nodefillc=colors, edgestrokec=edgecolors)