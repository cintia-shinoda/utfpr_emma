# using Pkg
# Pkg.add("JuMP")
# Pkg.add("HiGHS")
# Pkg.add("DataFrames")
# Pkg.add("Distances")
# Pkg.add("Plots")

using JuMP, HiGHS, DataFrames, Distances	
using Plots

# Função para calcular a distância entre duas cidades usando suas coordenadas
function distancia(cidade1, cidade2, coords)
    coord1 = coords[cidade1]
    coord2 = coords[cidade2]
    return Int(round(haversine(coord1, coord2)/1000, digits = 0))  # Usa a distância de Haversine (mais precisa para distâncias geográficas)
end

# O PROBLEMA DE TRANSBORDO

# Dados do problema
origens = ["TOL", "CAS", "FOZ", "GUA", "MED"] 
# Oeste do Paraná (Toledo, Cascavel, Foz do Iguaçu, Guaíra, Medianeira)

transbordo = ["CAM", "APU", "MAR"] 
# Central do Paraná (Campo Mourão, Apucarana, Maringá)

destinos = ["PON", "TEL", "JAC", "PGU", "CUR", "UNI", "IRE", "LON"] 
# Leste do Paraná (Ponta Grossa, Telêmaco Borba, Jacarezinho, Pinhão, Curitiba, União da Vitória, Irati, Londrina)

# Gerando valores aleatórios para oferta, demanda e capacidade
random_oferta = rand(1000:3000, length(origens))
random_demanda = rand(500:2500, length(destinos))
random_capacidade = rand(5000:10000, length(transbordo))


oferta = Dict(zip(origens, random_oferta))
demanda = Dict(zip(destinos, random_demanda))
capacidade_transbordo = Dict(zip(transbordo, random_capacidade))

sum(random_oferta)
sum(random_demanda)
#verifica ofertas e demandas
if (sum(random_oferta) < sum(random_demanda))
    random_oferta[end] += sum(random_demanda) - sum(random_oferta)
else
    random_demanda[end] += sum(random_oferta) - sum(random_demanda)
end

if (sum(random_capacidade) < sum(random_oferta))
    random_capacidade[end] += sum(random_oferta) - sum(random_capacidade) 
end

sum(random_oferta)
sum(random_demanda)
sum(random_capacidade)

println("Oferta:")
display(oferta)
println("\nDemanda:")
display(demanda)
println("\nCapacidade de Transbordo:")
display(capacidade_transbordo)



# Dicionário com as coordenadas geográficas (latitude, longitude) das cidades.
# Substitua pelas coordenadas reais das cidades que você está usando.
coordenadas = Dict(
    "TOL" => (-24.89, -53.74), "CAS" => (-24.96,-53.45), "FOZ" => (-25.55, -54.56), "GUA" => (-24.08, -54.20), "MED" => (-25.30, -54.14), # Origens
    "CAM" => (-24.28, -52.37), "APU" => (-23.42, -51.47), "MAR" => (-23.42, -52.00), # Transbordo
    "PON" => (-25.09, -50.21), "TEL" => (-24.05, -50.45), "JAC" => (-23.17, -49.77), "PGU" => (-25.95, -51.54), "CUR" => (-25.43, -49.27), "UNI" => (-26.16, -51.07), "IRE" => (-25.43, -51.06), "LON" => (-23.31, -51.16) # Destinos
)

# Criando as matrizes de custos
custo_origem_transbordo = zeros(length(origens), length(transbordo))
for i in 1:length(origens)
    for j in 1:length(transbordo)
        custo_origem_transbordo[i, j] = distancia(origens[i], transbordo[j], coordenadas)
    end
end

custo_transbordo_destino = zeros(length(transbordo), length(destinos))
for i in 1:length(transbordo)
    for j in 1:length(destinos)
        custo_transbordo_destino[i, j] = distancia(transbordo[i], destinos[j], coordenadas)
    end
end

# Imprimindo os valores
let
    println("Origens-transbordo")
    for t in transbordo
        print(" ", lpad(t[1], 7, ' '))
        #lpad cria um string concatenando valores com espaços à esquerda
    end
    print("\n")
    for i = 1:length(origens)
        print(origens[i])
        for j = 1: length(transbordo)
                print(" ", lpad(custo_origem_transbordo[i, j], 7, ' ')) 
        end
        print("\n")
    end
    print("\n")
    println("Transbordo-destinos")
    for d in destinos
        print(" ", lpad(d[1], 7, ' '))
        #lpad cria um string concatenando valores com espaços à esquerda
    end
    print("\n")
    for i = 1:length(transbordo)
        print(transbordo[i])
        for j = 1: length(destinos)
                print(" ", lpad(custo_transbordo_destino[i, j], 7, ' ')) 
        end
        print("\n")
    end
end


# Criando um DataFrame com todas as cidades e suas coordenadas
cidades = unique([origens; transbordo; destinos])
df_cidades = DataFrame(cidade = cidades, lat = [coordenadas[c][1] for c in cidades], lon = [coordenadas[c][2] for c in cidades])

# Plotando os pontos
plt = plot(df_cidades.lon, df_cidades.lat, seriestype = :scatter, label = "Cidades", title = "Localização das Cidades", xlabel = "Longitude", ylabel = "Latitude")

# Destacando as origens, transbordo e destinos com cores diferentes
scatter!(df_cidades[in.(df_cidades.cidade, Ref(origens)), :].lon, df_cidades[in.(df_cidades.cidade, Ref(origens)), :].lat, color = :blue, label = "Origens", markersize = 8)
scatter!(df_cidades[in.(df_cidades.cidade, Ref(transbordo)), :].lon, df_cidades[in.(df_cidades.cidade, Ref(transbordo)), :].lat, color = :green, label = "Transbordo", markersize = 8)
scatter!(df_cidades[in.(df_cidades.cidade, Ref(destinos)), :].lon, df_cidades[in.(df_cidades.cidade, Ref(destinos)), :].lat, color = :red, label = "Destinos", markersize = 8)

# Adicionando conexões entre origens-transbordo e transbordo-destinos (opcional)
for o in origens
    for t in transbordo
        plot!([coordenadas[o][2], coordenadas[t][2]], [coordenadas[o][1], coordenadas[t][1]], color = :lightblue, label = nothing, linewidth = 0.5) # Linhas origem-transbordo
    end
end

for t in transbordo
    for d in destinos
        plot!([coordenadas[t][2], coordenadas[d][2]], [coordenadas[t][1], coordenadas[d][1]], color = :lightpink, label = nothing, linewidth = 0.5)  # Linhas transbordo-destino
    end
end

display(plt) # Exibe o gráfico atualizado com as linhas


# Criando o modelo
modelo = Model(HiGHS.Optimizer)

# Conjuntos de índices
I = 1:length(origens) # Origens
K = 1:length(transbordo) # Transbordo
J = 1:length(destinos) # Destinos

# Variáveis de decisão
@variable(modelo, x[i in I, k in K] >= 0, Int) # Origem -> Transbordo
@variable(modelo, y[k in K, j in J] >= 0, Int) # Transbordo -> Destino

# Função objetivo (minimizar o custo total)
@objective(modelo, Min, sum(custo_origem_transbordo[i,k] * x[i,k] for i in I, k in K) + 
                          sum(custo_transbordo_destino[k,j] * y[k,j] for k in K, j in J))

# Restrições de oferta (o que sai das origens)
for i in I
    @constraint(modelo, sum(x[i,k] for k in K) <= random_oferta[i])
end

# Restrições de demanda (o que chega nos destinos)
for j in J
    @constraint(modelo, sum(y[k,j] for k in K) == random_demanda[j])
end

# Restrições de capacidade dos pontos de transbordo (o que entra é igual ao que sai)
for k in K
    @constraint(modelo, sum(x[i,k] for i in I) <= random_capacidade[k]) # O que entra no transbordo
    @constraint(modelo, sum(x[i,k] for i in I) == sum(y[k,j] for j in J)) # Conservação de fluxo (o que entra = o que sai)

end



# Resolvendo o modelo
    optimize!(modelo)

# Imprimindo a solução
if termination_status(modelo) == OPTIMAL
    println("Solução ótima encontrada!")
    println("Valor da função objetivo: ", objective_value(modelo))

    println("\nFluxo Origem -> Transbordo:")
    for i in I
        for k in K
            if value(x[i,k]) > 0
                println("Origem $(origens[i]) -> Transbordo $(transbordo[k]): $(value(x[i,k]))")
            end
        end
    end

    println("\nFluxo Transbordo -> Destino:")
    for k in K
        for j in J
            if value(y[k,j]) > 0
                println("Transbordo $(transbordo[k]) -> Destino $(destinos[j]): $(value(y[k,j]))")
            end
        end
    end

else
    println("Solução ótima não encontrada. Status: ", termination_status(modelo))
end


cidades = unique([origens; transbordo; destinos])
df_cidades = DataFrame(cidade = cidades, lat = [coordenadas[c][1] for c in cidades], lon = [coordenadas[c][2] for c in cidades])

# Plotando os pontos
plt = plot(df_cidades.lon, df_cidades.lat, seriestype = :scatter, label = "Cidades", title = "Localização das Cidades", xlabel = "Longitude", ylabel = "Latitude")

# Destacando as origens, transbordo e destinos com cores diferentes
scatter!(df_cidades[in.(df_cidades.cidade, Ref(origens)), :].lon, df_cidades[in.(df_cidades.cidade, Ref(origens)), :].lat, color = :blue, label = "Origens", markersize = 8)
scatter!(df_cidades[in.(df_cidades.cidade, Ref(transbordo)), :].lon, df_cidades[in.(df_cidades.cidade, Ref(transbordo)), :].lat, color = :green, label = "Transbordo", markersize = 8)
scatter!(df_cidades[in.(df_cidades.cidade, Ref(destinos)), :].lon, df_cidades[in.(df_cidades.cidade, Ref(destinos)), :].lat, color = :red, label = "Destinos", markersize = 8)


origens
coordenadas[origens[1]]

# Adicionando conexões entre origens-transbordo e transbordo-destinos (opcional)
for o in origens
    for t in transbordo
        plot!([coordenadas[o][2], coordenadas[t][2]], [coordenadas[o][1], coordenadas[t][1]], color = :lightblue, label = nothing, linewidth = 0.5) # Linhas origem-transbordo
    end
end

for t in transbordo
    for d in destinos
        plot!([coordenadas[t][2], coordenadas[d][2]], [coordenadas[t][1], coordenadas[d][1]], color = :lightpink, label = nothing, linewidth = 0.5)  # Linhas transbordo-destino
    end
end

# Exibindo o gráfico
display(plt)