% Importação dos dados
T = readtable('protein.csv', 'Delimiter', ',', 'ReadRowNames', true);
dados = table2array(T);
paises_nomes = T.Properties.RowNames;
proteinas_nomes = T.Properties.VariableNames;
T



% PCA
[coeff, score, latent, tsquared, explained, mu] = pca(dados);

disp('Principal Component Analysis (PCA) Results');
disp(['Explained Variance Ratio: ' num2str(explained')]);
disp(['Eigenvalues: ' num2str(latent')]);
disp('Loading Coefficients:');
disp(coeff);