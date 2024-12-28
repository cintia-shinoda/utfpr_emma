function optimize_lyapunov()
    % Parâmetros do sistema
    sigma = 16;
    beta = 4;
    rho = 45;
    
    % Intervalos para step_t e tend
    step_t_values = 0.001:0.001:0.01;
    tend_values = 50:10:100;
    
    % Valores alvo dos expoentes
    target_lambda1 = 1.102;
    target_lambda2 = 0;
    target_lambda3 = -20.55;
    
    % Variáveis para armazenar os melhores valores
    best_error = inf;
    best_step_t = 0;
    best_tend = 0;
    
    % Loop sobre step_t e tend
    for step_t = step_t_values
        for tend = tend_values
            [lambda1, lambda2, lambda3] = compute_lyapunov(step_t, tend, sigma, beta, rho);
            error = abs(lambda1 - target_lambda1) + abs(lambda2 - target_lambda2) + abs(lambda3 - target_lambda3);
            
            if error < best_error
                best_error = error;
                best_step_t = step_t;
                best_tend = tend;
            end
        end
    end
    
    % Exibir os melhores valores
    fprintf('Melhor step_t: %.4f\n', best_step_t);
    fprintf('Melhor tend: %.4f\n', best_tend);
    fprintf('Erro mínimo: %.4f\n', best_error);
end