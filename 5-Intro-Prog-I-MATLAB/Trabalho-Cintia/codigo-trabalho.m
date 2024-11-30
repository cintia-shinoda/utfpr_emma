% Importação dos dados
T = readtable('protein.csv', 'Delimiter', ',', 'ReadRowNames', true);
dados = table2array(T);
paises_nomes = T.Properties.RowNames;
proteinas_nomes = T.Properties.VariableNames;
T


% Matriz de Covariâncias
disp("Matriz de Covariâncias");
m_cov = cov(dados);
disp(m_cov);


% Matriz de Correlações
disp ("Matriz de Correlações")
matriz_cor = corrcoef(dados);
disp(matriz_cor);



% Gráfico de calor (heatmap) para a matriz de correlação
figure;
heatmap(matriz_cor, 'Colormap', parula, 'CellLabelColor', 'k');

% Personalização do gráfico
for i = 1:size(matriz_cor, 1)
    for j = 1:size(matriz_cor, 2)
    end
end;


% Análise de componentes principais (PCA):
[coeff, score, latent, tsquared, explained] = pca(matriz_cor);

disp('Componentes principais:');
disp(coeff);

% Porcentagem de variância explicada por cada componente:
disp('Variância explicada:');
disp(explained);

% Autovalores (variância explicada por cada componente:
disp('Autovalores:');
disp(latent);