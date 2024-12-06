% ALUNA: CINTIA IZUMI SHINODA
% RA: 2687674
% DESCRIÇÃO: EXERCÍCIO 1


% Declaração de uma function que recebe o número n e retorna uma matriz A
function A = cria_matriz(n)       

A = diag(2*ones(n,1)) + diag(-ones(n-1,1),1) + diag(-ones(n-1,1),-1);
end

% A = diag(2*ones(n,1)): criação de uma matriz de tamanho n x n com todos 
% os elementos da diagonal principal iguais a 2

% + diag(-ones(n-1,1),1): adiciona diagonal superior com todos os elementos
% iguais a -1   (o argumento 1, indica que a diagonal será acima da
% diagonal principal

% + diag(-ones(n-1,1), -1: adiciona uma diagonal inferior com todos os
% elementos iguais a -1. O argumento -1, indica que a diagonal será abaixo
% da diagonal principal

%-------------------------------------------------------------------------%


% Script para mostrar o funcionamento da função:

% matriz com dimensão igual a 7:
n = 7;

% chamando a função que cria a matriz:
A = cria_matriz(n);

% exibindo a matriz:
disp(A);