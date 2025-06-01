function tsp_ils(D::Matrix{Float64}; max_iter=1000, perturbation_size=3)
    n = size(D, 1)
    current_route = shuffle(1:n)
    current_cost = sum(D[current_route[i], current_route[i%n+1]] for i in 1:n)
    best_route, best_cost = copy(current_route), current_cost
    
    for i in 1:max_iter
        # Perturbação
        new_route = copy(current_route)
        indices = sort(rand(1:n, perturbation_size))
        reverse!(new_route, indices[1], indices[end])
        
        # Busca Local
        improved = true
        while improved
            improved = false
            for i1 in 1:n
                for i2 in i1+1:n
                    temp_route = copy(new_route)
                    reverse!(temp_route, i1, i2)
                    temp_cost = sum(D[temp_route[i], temp_route[i%n+1]] for i in 1:n)
                    if temp_cost < sum(D[new_route[i], new_route[i%n+1]] for i in 1:n)
                        new_route = temp_route
                        improved = true
                    end
                end
            end
        end
        
        new_cost = sum(D[new_route[i], new_route[i%n+1]] for i in 1:n)
        
        if new_cost < current_cost
            current_route, current_cost = new_route, new_cost
            if new_cost < best_cost
                best_route, best_cost = new_route, new_cost
            end
        end
    end
    best_route, best_cost
end


