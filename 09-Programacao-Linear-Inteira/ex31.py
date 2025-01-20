from pulp import LpProblem, LpMinimize, LpVariable, lpSum

# Dados do problema
custos = [
    [10, 7, 5, 6],  # Custos da Fábrica 1 para cada mercado
    [12, 7, 6, 4],  # Custos da Fábrica 2 para cada mercado
    [13, 6, 3, 5],  # Custos da Fábrica 3 para cada mercado
]

offerta = [220, 180, 230]  # Ofertas das fábricas
demanda = [150, 165, 210, 90]  # Demandas dos mercados

# Índices
fabrics = range(len(offerta))
mercados = range(len(demanda))

# Modelo de otimização
modelo = LpProblem("Problema_de_Transporte", LpMinimize)

# Variáveis de decisão
x = [[LpVariable(f"x_{i}_{j}", lowBound=0) for j in mercados] for i in fabrics]

# Função objetivo: minimizar o custo total de transporte
modelo += lpSum(custos[i][j] * x[i][j] for i in fabrics for j in mercados), "Custo_Total"

# Restrições de oferta
for i in fabrics:
    modelo += lpSum(x[i][j] for j in mercados) <= offerta[i], f"Oferta_Fabrica_{i}"

# Restrições de demanda
for j in mercados:
    modelo += lpSum(x[i][j] for i in fabrics) >= demanda[j], f"Demanda_Mercado_{j}"

# Resolver o problema
modelo.solve()

# Resultados
print("Status:", modelo.status)
print("Custo Total:", modelo.objective.value())

for i in fabrics:
    for j in mercados:
        print(f"Quantidade transportada de Fábrica {i+1} para Mercado {j+1}: {x[i][j].value()}")
