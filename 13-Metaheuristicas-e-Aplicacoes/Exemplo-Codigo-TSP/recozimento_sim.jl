function tsp_sa(D::Matrix{Float64}; max_iter=1000, T=1000.0, α=0.99)
    n = size(D, 1)
    current_route = shuffle(1:n)
    current_cost = sum(D[current_route[i], current_route[i%n+1]] for i in 1:n)
    best_route, best_cost = copy(current_route), current_cost
    
    for i in 1:max_iter
        T *= α
        new_route = copy(current_route)
        i1, i2 = sort(rand(1:n, 2))
        reverse!(new_route, i1, i2)
        new_cost = sum(D[new_route[i], new_route[i%n+1]] for i in 1:n)
        
        if new_cost < current_cost || exp((current_cost - new_cost)/T) > rand()
            current_route, current_cost = new_route, new_cost
            if new_cost < best_cost
                best_route, best_cost = new_route, new_cost
            end
        end
    end
    best_route, best_cost
end
