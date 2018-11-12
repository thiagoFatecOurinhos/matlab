% @author  thiago@fatecourinhos.edu.br
% @since   2018-11
% @version v1.3
%
% PID - Prof. Ap. Nilceu Marana
% PPGCC Unesp SJRP/Bauru
%
% Código em MATLAB que gera descritores LBP
% para a face, o olho esquerdo, o olho direito
% e também gera um descritor de multibiometria
% que é a média dos três anteriores
%
% Escrito e testado no MATLAB R2017b



% Calcula LBP
% Face + Left + Right

calcular_lbp = 0;

if calcular_lbp 
%clear all;

% FACE
totalImagens = dir('f_*.bmp');
numeroImagens = length(totalImagens); 

fprintf("\n Calculando LBP frontal:\n");
lbp_f = zeros(size(totalImagens,1), 256);
for i=1:numeroImagens
  imgEncontrada = totalImagens(i).name;
  I = imread(imgEncontrada);
  lbp_f(i,:) = calculaLocalBinaryPattern(I);
  fprintf("Frontal [%i]\n",i);
end
fprintf("\n");

% LEFT
totalImagens = dir('l_*.bmp');
numeroImagens = length(totalImagens); 

fprintf("\n Calculando LBP olho esquerdo:\n");
lbp_l = zeros(size(totalImagens,1), 256);
for i=1:numeroImagens
  imgEncontrada = totalImagens(i).name;
  I = imread(imgEncontrada);
  lbp_l(i,:) = calculaLocalBinaryPattern(I);
  fprintf("Esq [%i]\n",i);
end
fprintf("\n");

% RIGHT
totalImagens = dir('r_*.bmp');
numeroImagens = length(totalImagens); 

fprintf("\n Calculando LBP olho direito:\n");
lbp_r = zeros(size(totalImagens,1), 256);
for i=1:numeroImagens
  imgEncontrada = totalImagens(i).name;
  I = imread(imgEncontrada);
  lbp_r(i,:) = calculaLocalBinaryPattern(I);
  fprintf("Dir [%i]\n",i);
end
fprintf("\n");


% Calcula as medias entre os 3 LBPs
lbp_all = zeros(size(totalImagens,1), 256);
for i=1 : size(totalImagens,1)
    lbp_all(i,:) = uint8(   lbp_f(i,:) + lbp_l(i,:) + lbp_r(i,:)   )/3;
    fprintf("Calculo da media [%i]\n",i);
end

% adiciona na matriz informacoes das imagens para controle


% -> concatena verticalmente
%    adicionando numero da imagem e numero dos fragmentos
% pessoa
for i=1:numeroImagens/7
   pessoa((i*7)-6:i*7,1)=i ;
end
% pose
pose=0;
frag_template = [1;2;3;4;5;6;7];
for i=1:numeroImagens/7
    pose=vertcat(pose,frag_template);
end
pose(1,:) = [];

template = horzcat(pessoa,pose);
lbp_all = horzcat(template, lbp_all);
lbp_f = horzcat(template, lbp_f);
lbp_l = horzcat(template, lbp_l);
lbp_r = horzcat(template, lbp_r);


end %if calcular_lbp



% ALL
matriz_precision_recall = [0,0,0,0,0,0];
for i=1 : numeroImagens/7
     query = buscaClasseDatabase(i,lbp_all);
     matriz_precision_recall = vertcat(matriz_precision_recall, query);
end

matriz_precision_recall(1,:) = [];

% MEDIA DO PRECISIONS RECALL PARA O METODO LBP
pr_media1 = [mean(matriz_precision_recall(:,1)) mean(matriz_precision_recall(:,2)) mean(matriz_precision_recall(:,3)) mean(matriz_precision_recall(:,4)) mean(matriz_precision_recall(:,5)) mean(matriz_precision_recall(:,6)) ];
recall1 = [1/6 2/6 3/6 4/6 5/6 6/6];
LBP1 = vertcat(recall1, pr_media1);

%todos
%plot(LBP(1,:), LBP(2,:), '-bo');
%hold on


% LEFT
matriz_precision_recall = [0,0,0,0,0,0];
for i=1 : numeroImagens/7
     query = buscaClasseDatabase(i,lbp_l);
     matriz_precision_recall = vertcat(matriz_precision_recall, query);
end

matriz_precision_recall(1,:) = [];

% MEDIA DO PRECISIONS RECALL PARA O METODO LBP
pr_media2 = [mean(matriz_precision_recall(:,1)) mean(matriz_precision_recall(:,2)) mean(matriz_precision_recall(:,3)) mean(matriz_precision_recall(:,4)) mean(matriz_precision_recall(:,5)) mean(matriz_precision_recall(:,6)) ];
recall2 = [1/6 2/6 3/6 4/6 5/6 6/6];
LBP2 = vertcat(recall2, pr_media2);

%todos
%plot(LBP(1,:), LBP(2,:), '-ro');
%hold on


% RIGHT
matriz_precision_recall = [0,0,0,0,0,0];
for i=1 : numeroImagens/7
     query = buscaClasseDatabase(i,lbp_r);
     matriz_precision_recall = vertcat(matriz_precision_recall, query);
end

matriz_precision_recall(1,:) = [];

% MEDIA DO PRECISIONS RECALL PARA O METODO LBP
pr_media3 = [mean(matriz_precision_recall(:,1)) mean(matriz_precision_recall(:,2)) mean(matriz_precision_recall(:,3)) mean(matriz_precision_recall(:,4)) mean(matriz_precision_recall(:,5)) mean(matriz_precision_recall(:,6)) ];
recall3 = [1/6 2/6 3/6 4/6 5/6 6/6];
LBP3 = vertcat(recall3, pr_media3);

%todos
%plot(LBP(1,:), LBP(2,:), '-go');
%hold on


% FRONTAL
matriz_precision_recall = [0,0,0,0,0,0];
for i=1 : numeroImagens/7
     query = buscaClasseDatabase(i,lbp_f);
     matriz_precision_recall = vertcat(matriz_precision_recall, query);
end

matriz_precision_recall(1,:) = [];

% MEDIA DO PRECISIONS RECALL PARA O METODO LBP
pr_media4 = [mean(matriz_precision_recall(:,1)) mean(matriz_precision_recall(:,2)) mean(matriz_precision_recall(:,3)) mean(matriz_precision_recall(:,4)) mean(matriz_precision_recall(:,5)) mean(matriz_precision_recall(:,6)) ];
recall4 = [1/6 2/6 3/6 4/6 5/6 6/6];
LBP4 = vertcat(recall4, pr_media4);

%todos
%plot(LBP(1,:), LBP(2,:), '-yo');

figure; hold on
a1 = plot(recall1,pr_media1,'g-','LineWidth',2); M1 = 'TODOS';
a2 = plot(recall2,pr_media2,'r-','LineWidth',2); M2 = 'OLHO ESQUERDO';
a3 = plot(recall3,pr_media3,'k-','LineWidth',2); M3 = 'OLHO DIREITO';
a4 = plot(recall4,pr_media4,'b-','LineWidth',2); M4 = 'FACE';
legend([a1;a2;a3;a4], M1, M2, M3, M4)
axis([0.17 1 0 0.5])





%+-----------------------------------------------------------+
%|              Funcao calculaLocalBinaryPattern()           |
%+-----------------------------------------------------------+
%retorna histo_com_pesos | recebe img
function [histo_com_pesos] = calculaLocalBinaryPattern(img)
[ alt larg ] = size(img);
matriz_saida = zeros(alt,larg) ;
pesos = [ 1 2 4 ; 128 0 8 ; 64 32 16] ;

for x = 2 : alt - 1
    for y = 2 : larg - 1
        %obtem os vizinhos numa escala de 8 (3x3)
        %
        %    [x-1,y+1]   [x,y+1]  [x+1,y+1]    
        %    [ x-1,y ]   [  x  ]  [ x+1,y ]
        %    [x-1,y-1]   [x,y-1]  [x+1,y-1]
        %
        vizinhos_3x3 = img(x-1:x+1,y-1:y+1) ;
        
        %coloca em vizinhos_3x3_processada desde que
        %vizinhos >= a x (central)
        %coloca 1 ou 0
        vizinhos_3x3_processada = vizinhos_3x3 >= vizinhos_3x3(2,2) ;
        
        %multiplica os vizinhos pelos pesos (IPv4 sentido horário)
        vizinhos_3x3_com_pesos = vizinhos_3x3_processada.*pesos ;
        
        %coloca um novo valor na posicao central
        novo_valor_posicao_central = sum(sum(vizinhos_3x3_com_pesos));
        
        %nova matriz de saida
        matriz_saida(x,y) = novo_valor_posicao_central;
    end
end

%calcula o histograma da nova matriz
histo_com_pesos = zeros(1,256) ;

for x = 2 : alt -1
    for y = 2 : larg-1
       histo_com_pesos(matriz_saida(x,y)+1) = histo_com_pesos(matriz_saida(x,y)+1) + 1;
    end
end

%histo_com_pesos = double(histo_com_pesos) / ((alt-2) * (larg-2)) ;

end













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
                %fprintf("ENTREI");
                valor = database(i,3:258) ;%encontra o valor do frag1
            end
        end
    end
    %pause
    %calcula a distancia de cada valor
    for i=1 : size(database,1)
       
       database(i,259) = norm(valor - database(i,3:258));
       %fprintf("database(%i,4) = norm(%f - %i);\n",i,valor,database(i,1))
       %pause
    end
    
    database = sortrows(database,259);

end
