# using Pkg
# Pkg.add("JuMP")
# Pkg.add("HiGHS")

using JuMP, HiGHS
			
# O PROBLEMA DE TRANSPORTE

# Dados do problema
origens = ["GARY", "CLEV", "PITT"]
destinos = ["FRA", "DET", "LAN", "WIN", "STL", "FRE", "LAF"]

oferta = Dict(
    "GARY" => 1400,
    "CLEV" => 2600,
    "PITT" => 2900,
)

demanda = Dict(
    "FRA" => 900,
    "DET" => 1200,
    "LAN" => 600,
    "WIN" => 400,
    "STL" => 1700,
    "FRE" => 1100,
    "LAF" => 1000,
)

custo = Dict(
    ("GARY", "FRA") => 39,
    ("GARY", "DET") => 14,
    ("GARY", "LAN") => 11,
    ("GARY", "WIN") => 14,
    ("GARY", "STL") => 16,
    ("GARY", "FRE") => 82,
    ("GARY", "LAF") => 8,
    ("CLEV", "FRA") => 27,
    ("CLEV", "DET") => 99999, # Representando como infinito (TEM OUTRA OPÇÃO!)
    ("CLEV", "LAN") => 12,
    ("CLEV", "WIN") => 99999,
    ("CLEV", "STL") => 26,
    ("CLEV", "FRE") => 95,
    ("CLEV", "LAF") => 17,
    ("PITT", "FRA") => 24,
    ("PITT", "DET") => 14,
    ("PITT", "LAN") => 17,
    ("PITT", "WIN") => 13,
    ("PITT", "STL") => 28,
    ("PITT", "FRE") => 99,
    ("PITT", "LAF") => 20,
)

# Criando o modelo
modelo = Model(HiGHS.Optimizer)

# Variáveis de decisão
@variable(modelo, x[o in origens, d in destinos] >= 0, Int)

# Função objetivo (minimizar o custo total)
@objective(modelo, 
        Min, 
        sum(custo[o,d] * x[o,d] for o in origens, d in destinos))

# Restrições de oferta
for o in origens
@constraint(modelo, sum(x[o,d] for d in destinos) <= oferta[o])
end

# Restrições de demanda
for d in destinos
@constraint(modelo, sum(x[o,d] for o in origens) == demanda[d])
end

# Resolvendo o modelo
optimize!(modelo)

# Obtendo valores não próximos a zero
let
    for d in demanda
        print(" ", lpad(d[1], 7, ' '))
        #lpad cria um string concatenando valores com espaços à esquerda
    end
    print("\n")
    for o in origens
        print(o)
        for d in destinos
            if isapprox(value(x[o, d]), 0.0; atol = 1e-6)
                print("       .")
            else
                print(" ", lpad(value(x[o, d]), 7, ' ')) 
            end
        end
        print("\n")
    end
end
