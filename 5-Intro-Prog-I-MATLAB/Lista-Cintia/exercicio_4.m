% ALUNA: CINTIA IZUMI SHINODA
% RA: 2687674
% DESCRIÇÃO: EXERCÍCIO 4



% Geração de dados:
x = linspace (0, 1, 20)';
y = rand(size(x)) - 0.5 - rand(size(x)).*x + pi*x.^2;

% Ajuste de parábola:
p = polyfit(x, y, 2);

% Criação dos pontos da parábola ajustada:
x_fit = linspace(0, 1, 100)';
y_fit = polyval(p, x_fit);

% Plota o gráfico:
plot(x, y, 'o', 'MarkerSize', 8, 'DisplayName', 'Dados');
hold on;
plot(x_fit, y_fit, '-', 'LineWidth', 2, 'DisplayName', 'Parábola Ajustada');
hold off;

% Personaliza o gráfico:
xlabel('x');
ylabel('y');
title('Ajuste de uma Parábola');
legend('Location','best');
grid on;