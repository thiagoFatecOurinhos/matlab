% author: thiago at fatecourinhos.edu.br
% 08/2018

%+----------------------------------------------------------+
%|               Funcao buscaClasseDatabase()               |
%+----------------------------------------------------------+

function [precisionRecallCurve] = buscaClasseDatabase(classe,database)

    % ordenar a base antes da consulta
    % pela distancia do frag1 da classe recebida
    database_ord = ordenaPelaDistancia(classe,database);
    database_ord;

    precisionRecallCurve = zeros(1,3); %resultado a retornar
    count=0;
    %laço
    for i=1 : size(database_ord,1)
        %query
        if database_ord(i,1) == classe

            %fprintf("Encontrei na posicao %i", i)
            count = count +1 ;
            divisor = i;

            if (count == 1) && (divisor == 1) %achou a mesma da consulta - ignorar
            else
                precisionRecallCurve(1,count-1) = count/divisor;
            end
        end
    end

    %fprintf("RETORNANDO...\n")
    %precisionRecallCurve
    %fprintf("\n PARA A CLASSE %i\n", classe)


end

%+----------------------------------------------------------+
%|               Funcao ordenaPelaDistancia()               |
%+----------------------------------------------------------+
function [database] = ordenaPelaDistancia(classe,database)

    %busca pelo valor do frag 1 da classe
    for i=1 : size(database,1)
        if database(i,2) == 1 %soh frag 1
            if database(i,1) == classe %soh classe esperada
               valor = database(i,3:258); %encontra o valor do frag1
            end
        end
    end
    %pause
