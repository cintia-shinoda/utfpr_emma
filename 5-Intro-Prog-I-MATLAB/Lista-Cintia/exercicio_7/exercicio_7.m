% ALUNA: CINTIA IZUMI SHINODA
% RA: 2687674
% DESCRIÇÃO: EXERCÍCIO 7



% Carregamento dos dados da planilha no Excel:
dados = xlsread('dados.xlsx'); 

% Cálculo da média, desvio padrão e soma:
media = mean(dados);
desvio_padrao = std(dados);
soma = sum(dados);

% Criação da matriz com os resultados:
resultados = [media; desvio_padrao; soma];

% Salvando os resultados em arquivo.txt
save('resultados.txt', 'resultados', '-ascii');