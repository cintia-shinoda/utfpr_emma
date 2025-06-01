function tsp_bt(D::Matrix{Float64}; 
    max_iter=1000, 
    tabu_size=10)
    
    n = size(D, 1)
    current_route = shuffle(1:n)
    current_cost = sum(D[current_route[i], current_route[i%n+1]] for i in 1:n)
    best_route, best_cost = copy(current_route), current_cost
    tabu_list = []
    
    for i in 1:max_iter
        best_neighbor = nothing
        best_neighbor_cost = Inf
        
        for i1 in 1:n
            for i2 in i1+1:n
                neighbor_route = copy(current_route)
                reverse!(neighbor_route, i1, i2)
                neighbor_cost = sum(D[neighbor_route[i], neighbor_route[i%n+1]] for i in 1:n)
                
                if neighbor_cost < best_neighbor_cost && !(neighbor_route in tabu_list)
                    best_neighbor = neighbor_route
                    best_neighbor_cost = neighbor_cost
                end
            end
        end
        
        if best_neighbor !== nothing
            push!(tabu_list, current_route)
            if length(tabu_list) > tabu_size
                popfirst!(tabu_list)
            end
            
            current_route, current_cost = best_neighbor, best_neighbor_cost
            if best_neighbor_cost < best_cost
                best_route, best_cost = best_neighbor, best_neighbor_cost
            end
        end
    end
    best_route, best_cost
end

