function tsp_ag(D::Matrix{Float64}; 
    pop_size=100, 
    max_iter=100, 
    elite_perc = 0.25, 
    mutation_prob=0.10)

    
    n = size(D, 1)
    population = [shuffle(1:n) for _ in 1:pop_size]
    costs = [sum(D[route[i], route[i%n+1]] for i in 1:n) for route in population]
    
    for i in 1:max_iter
        # Seleção
        parents = sortperm(costs)[1:Int(pop_size*elite_perc)]
        offspring = []
        
        # Cruzamento
        for _ in 1:pop_size*(1-elite_perc)
            p1, p2 = population[parents[rand(1:length(parents))]], population[parents[rand(1:length(parents))]]
            child = zeros(Int, n)
            start_idx = rand(1:n)
            end_idx = rand(start_idx:n)
            child[start_idx:end_idx] .= p1[start_idx:end_idx]
            idx = 1
            for j in 1:n
                if child[j] == 0
                    while p2[idx] in child
                        idx += 1
                    end
                    child[j] = p2[idx]
                end
            end
            push!(offspring, child)
        end
        
        # Mutação
        for route in offspring
            if rand() < mutation_prob
                i1, i2 = sort(rand(1:n, 2))
                reverse!(route, i1, i2)
            end
        end
        
        # Substituição
        population = vcat(population[parents], offspring)
        costs = [sum(D[route[i], route[i%n+1]] for i in 1:n) for route in population]
    end
    
    best_idx = argmin(costs)
    population[best_idx], costs[best_idx]
end

