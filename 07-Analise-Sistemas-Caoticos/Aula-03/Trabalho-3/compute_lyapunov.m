function [lambda1, lambda2, lambda3] = compute_lyapunov(step_t, tend, sigma, beta, rho)
    % Parâmetros do sistema
    n = 3; % Dimensão do sistema
    x0 = [1; 1; 1]; % Condição inicial
    
    % Inicializar as perturbações ortogonais
    perturbations = eye(n) * 1e-6;
    
    % Inicializar variáveis para calcular os expoentes
    sum_lyapunov = zeros(n, 1);
    t_span = 0:step_t:tend;
    
    % Loop de integração
    for t_idx = 1:length(t_span)-1
        % Resolver sistema principal
        [~, X] = ode45(@(t, x) lorenz_system(t, x, sigma, beta, rho), [t_span(t_idx), t_span(t_idx+1)], x0);
        x0 = X(end, :)'; % Atualizar condição inicial
        
        % Resolver sistemas perturbados
        new_perturbations = zeros(n, n);
        for i = 1:n
            perturbed_x0 = x0 + perturbations(:, i);
            [~, perturbed_X] = ode45(@(t, x) lorenz_system(t, x, sigma, beta, rho), [t_span(t_idx), t_span(t_idx+1)], perturbed_x0);
            new_perturbations(:, i) = perturbed_X(end, :)' - x0;
        end
        
        % Re-ortogonalizar (Gram-Schmidt)
        [Q, R] = qr(new_perturbations);
        perturbations = Q;
        
        % Atualizar somatório dos expoentes
        sum_lyapunov = sum_lyapunov + log(abs(diag(R)));
    end
    
    % Calcular os expoentes médios
    lambda = sum_lyapunov / (tend * step_t);
    lambda1 = lambda(1);
    lambda2 = lambda(2);
    lambda3 = lambda(3);
end