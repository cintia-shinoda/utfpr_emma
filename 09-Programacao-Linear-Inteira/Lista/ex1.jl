using Pkg
Pkg.add("JuMP")
Pkg.add("GLPK")

using JuMP
using GLPK

# Função para resolver um problema dado um conjunto de restrições
function solve_bnb(model)
    optimize!(model)
    status = termination_status(model)
    if status == MOI.OPTIMAL
        return (
            value(objective_function(model)),
            [value(var) for var in all_variables(model)],
            true
        )
    elseif status == MOI.INFEASIBLE
        return (nothing, nothing, false)
    else
        error("Problema não resolvido corretamente")
    end
end

# Função para criar o modelo (com ou sem integralidade)
function create_model(integrality::Bool)
    model = Model(GLPK.Optimizer)

    # Variáveis (definidas como contínuas ou inteiras)
    @variable(model, x1 >= 0)
    @variable(model, x2 >= 0)
    @variable(model, x3 >= 0)
    @variable(model, x4 >= 0)

    if integrality
        set_integer.(all_variables(model))  # Configura todas as variáveis como inteiras
    end

    # Função objetivo
    @objective(model, Max, 7x1 + 9x2 + x3 + 6x4)

    # Restrições
    @constraint(model, x1 + 3x2 + 9x3 + 6x4 <= 16)
    @constraint(model, 6x1 + 6x2 + 7x4 <= 19)
    @constraint(model, 7x1 + 8x2 + 18x3 + 3x4 <= 44)

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
    println("Problema com solução inviável.")
end