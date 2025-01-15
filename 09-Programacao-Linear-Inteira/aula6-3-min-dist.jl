using DataFrames, Distances, JuMP, HiGHS, Gurobi, Plots

# Função distancia (incluída para completar o código)
function distancia(cidade1, cidade2, coords)
    coord1 = coords[cidade1]
    coord2 = coords[cidade2]
    return Int(round(haversine(coord1, coord2)/1000, digits = 0))  # Usa a distância de Haversine (mais precisa para distâncias geográficas)
end

# Coordenadas 
coordenadas = Dict(
    "TOL" => (-24.89, -53.74), "CAS" => (-24.96,-53.45), "FOZ" => (-25.55, -54.56), "GUA" => (-24.08, -54.20), "MED" => (-25.30, -54.14), # Origens
    "CAM" => (-24.28, -52.37), "APU" => (-23.42, -51.47), "MAR" => (-23.42, -52.00), # Transbordo
    "PON" => (-25.09, -50.21), "TEL" => (-24.05, -50.45), "JAC" => (-23.17, -49.77), "PGU" => (-25.95, -51.54), "CUR" => (-25.43, -49.27), "UNI" => (-26.16, -51.07), "IRE" => (-25.43, -51.06), "LON" => (-23.31, -51.16), # Destinos
    "GUA" => (-25.39, -50.85)  # Guarapuava (GPA). Observe que a sigla foi corrigida para evitar conflito com Guaíra.
)

# Todas as cidades
cidades = keys(coordenadas) |> collect


# Criando a matriz de adjacências (distâncias)
n_cidades = length(cidades)
matriz_adjacencias = zeros(n_cidades, n_cidades)

df_adjacencias = DataFrame(origem = String[], destino = String[], dist = Int64[])

for i = 1:n_cidades
    for j = 1:n_cidades
        temp_dist = distancia(cidades[i], cidades[j], coordenadas)
        if temp_dist <= 180
            matriz_adjacencias[i,j] = temp_dist
            push!(df_adjacencias, [cidades[i], cidades[j], temp_dist])
            println(cidades[i], "-> ", cidades[j], " = ", temp_dist)
        end
    end
end

# Criando um DataFrame com todas as cidades e suas coordenadas
df_cidades = DataFrame(cidade = cidades, lat = [coordenadas[c][1] for c in cidades], lon = [coordenadas[c][2] for c in cidades])

# Plotando os pontos
plt = plot(df_cidades.lon, df_cidades.lat, seriestype = :scatter, label = "Cidades", title = "Localização das Cidades", xlabel = "Longitude", ylabel = "Latitude")

# Adicionando conexões entre cidades
for i = 1: n_cidades, j =1: n_cidades
    if (matriz_adjacencias[i,j] > 0 )
        println(matriz_adjacencias[i,j])
        plot!(
            [coordenadas[cidades[i]][2], coordenadas[cidades[j]][2]], 
            [coordenadas[cidades[i]][1], coordenadas[cidades[j]][1]], 
            color = :lightblue, label = nothing, linewidth = 0.5) # Linhas com arcos > 300 km
    end
end

display(plt) # Exibe o gráfico atualizado com as linhas




cidades

# Cidade de origem e destino (substitua pelos nomes corretos)
cidade_origem = "TOL"  
cidade_destino = "APU"

# Criando o modelo
modelo = Model(HiGHS.Optimizer)
# set_silent(modelo)

# Variáveis de decisão (1 se a aresta (i, j) faz parte do caminho, 0 caso contrário)
@variable(modelo, x[1:n_cidades, 1:n_cidades], Bin)
## Remove arcs with "." cost by fixing them to 0.0.
for i in 1:n_cidades, j in 1: n_cidades
    if matriz_adjacencias[i, j] == 0.0
        fix(x[i, j], 0.0; force = true)
    end
end
@objective(modelo, Min, sum(matriz_adjacencias[i,j] * x[i,j] for i in 1:n_cidades, j in 1: n_cidades))
@constraint(modelo, origem[i = 1: n_cidades; cidades[i] == cidade_origem], 
sum(x[i, j] for j in 1:n_cidades) + sum(x[j,i] for j in 1:n_cidades) == 1)
@constraint(modelo, destino[i = 1: n_cidades; cidades[i] == cidade_destino], 
sum(x[i, j] for j in 1:n_cidades) + sum(x[j, i] for j in 1:n_cidades) == 1)

@constraint(modelo, fluxo[i = 1: n_cidades; cidades[i] != cidade_origem && cidades[i] != cidade_destino], sum(x[k, i] for k in 1:n_cidades) - sum(x[i, j] for j in 1:n_cidades) == 0)

# Resolvendo o modelo
optimize!(modelo)

# Imprimindo a solução
if termination_status(modelo) == OPTIMAL
    println("Solução ótima encontrada! Distância mínima: ", objective_value(modelo))
        for i in 1:n_cidades, j in 1:n_cidades
            if value(x[i, j]) > 0.5
                println(cidades[i], " -> ", cidades[j], " ", matriz_adjacencias[i,j])
            end
        end
else
    println("Solução ótima não encontrada. Status: ", termination_status(modelo))
end

# Criando um DataFrame com todas as cidades e suas coordenadas
df_cidades = DataFrame(cidade = cidades, lat = [coordenadas[c][1] for c in cidades], lon = [coordenadas[c][2] for c in cidades])

using Plots

# Plotando os pontos
plt = plot(df_cidades.lon, df_cidades.lat, seriestype = :scatter, label = "Cidades", title = "Localização das Cidades", xlabel = "Longitude", ylabel = "Latitude")

# Adicionando conexões entre cidades
for i = 1: n_cidades, j =1: n_cidades
    if (matriz_adjacencias[i,j] > 0 )
        corpadrao = :lightblue
        if value(x[i,j]) > 0.05
            corpadrao = :red
        end
        plot!(
            [coordenadas[cidades[i]][2], coordenadas[cidades[j]][2]], 
            [coordenadas[cidades[i]][1], coordenadas[cidades[j]][1]], 
            color = corpadrao, label = nothing, linewidth = 0.5) # Linhas com arcos > 300 km
    end
end

display(plt) # Exibe o gráfico atualizado com as linhas