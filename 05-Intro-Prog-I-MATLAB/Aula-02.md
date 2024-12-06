## Aula 02 - 31/08/2024


---
### Vídeo da Aula
[Vídeo da Aula 2](https://drive.google.com/file/d/1P_G5skCCdTtd00oBhpGlqr8WyCw25LaY/view)

---


### Vetorização
- linguagem interpretada -> custo de processamento
- vantagens: > velocidade, maior legibilidade, operações com matrizes

```{matlab}
>> A = [1 2 3; 4 5 6; 7 8 9];
>> A
A =

     1     2     3
     4     5     6
     7     8     9

>> B = rand(3);
>> B

B =

    0.8147    0.9134    0.2785
    0.9058    0.6324    0.5469
    0.1270    0.0975    0.9575

>> A * B

ans =

    3.0073    2.4707    4.2448
    8.5498    7.4005    9.5934
   14.0923   12.3304   14.9421

>> A .* B

ans =

    0.8147    1.8268    0.8355
    3.6232    3.1618    3.2813
    0.8889    0.7803    8.6176
```