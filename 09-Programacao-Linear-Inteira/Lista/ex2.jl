function create_model(integrality::Bool)
    model = Model(GLPK.Optimizer)

    # Variáveis (definidas como contínuas ou inteiras)
    @variable(model, x1 >= 0)
    @variable(model, x2 >= 0)
    @variable(model, x3 >= 0)
    @variable(model, x4 >= 0)

    if integrality
        set_integer(x1)
        set_integer(x2)
        set_integer(x4)
        # x3 permanece contínua
    end

    # Função objetivo
    @objective(model, Max, 7x1 + 9x2 + x3 + 6x4)

    # Restrições
    @constraint(model, 8x1 + 2x2 + 4x3 + 2x4 <= 16)
    @constraint(model, 4x1 + 8x2 + 2x3 <= 20)
    @constraint(model, 7x1 + 6x3 + 2x4 <= 11)

    return model
end

# Criar o modelo relaxado
relaxed_model = create_model(false)
z, solution, feasible = solve_bnb(relaxed_model)

println("Solução Relaxada:")
println("z = $z, x = $solution")

# Criar o modelo com variáveis inteiras
integer_model = create_model(true)
z_int, solution_int, feasible_int = solve_bnb(integer_model)

println("\nSolução com Inteiros:")
if feasible_int
    println("z = $z_int, x = $solution_int")
else
    println("Nenhuma solução viável encontrada.")
end