% ALUNA: CINTIA IZUMI SHINODA
% RA: 2687674
% DESCRIÇÃO: EXERCÍCIO 2



% Function para calcular o coeficiente binomial:
function c = binomial_coefficient(n, k)

    % Verifica se os argumentos são válidos
    if k < 0 || k > n
        error('k deve ser um número inteiro não negativo e menor ou igual a n');
    end

    % Calcula o coeficiente binomial usando a fórmula
    c = factorial(n) / (factorial(k) * factorial(n-k));
end

%-------------------------------------------------------------------------%


% Script para testar a função:
n_values = [5, 10];
k_values = [2, 5];

for i = 1:length(n_values)
    for j = 1:length(k_values)
        n = n_values(i);
        k = k_values(j);
        
        % Cálculo do coeficiente binomial:
        c = binomial_coefficient(n, k);
        
        % Imprime o resultado
        fprintf('C(%d, %d) = %d\n', n, k, c);
    end
end




%-------------------------------------------------------------------------%


% Comparando a resposta com o resultado da função do Matlab:
c_matlab = nchoosek(n, k);
fprintf('C(%d, %d) = %d (minha função), %d (função nchoosek)\n', n, k, c, c_matlab);