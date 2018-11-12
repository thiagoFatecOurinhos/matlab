% @author  thiago@fatecourinhos.edu.br
% @since   2018-11
% @version v1.3
%
% PID - Prof. Ap. Nilceu Marana
% PPGCC Unesp SJRP/Bauru
%
% Código em MATLAB que gera faz as consultas na bases
% criadas no lbp_arface_multibiometria.m 
% e gera os valores de GAR e FAR
%
% Escrito e testado no MATLAB R2017b


%buscaClasseDatabase(10,lbp_f,2)
%pause

%--------

% busca numa amostra de 1
gar_far_1 = [0 0];
for i=1 : 70
  [gar far] = buscaClasseDatabase(i,lbp_f,1);
  gar_far_1(i+1,1) = gar;
  gar_far_1(i+1,2) = far;
end

gar_far_1(1,:) = [];




% busca numa amostra de 2
gar_far_2 = [0 0];
for i=1 : 70
  [gar far] = buscaClasseDatabase(i,lbp_f,2);
  gar_far_2(i+1,1) = gar;
  gar_far_2(i+1,2) = far;
end

gar_far_2(1,:) = [];




% busca numa amostra de 3
gar_far_3 = [0 0];
for i=1 : 70
  [gar far] = buscaClasseDatabase(i,lbp_f,3);
  gar_far_3(i+1,1) = gar;
  gar_far_3(i+1,2) = far;
end

gar_far_3(1,:) = [];




% busca numa amostra de 4
gar_far_4 = [0 0];
for i=1 : 70
  [gar far] = buscaClasseDatabase(i,lbp_f,4);
  gar_far_4(i+1,1) = gar;
  gar_far_4(i+1,2) = far;
end

gar_far_4(1,:) = [];




% busca numa amostra de 5
gar_far_5 = [0 0];
for i=1 : 70
  [gar far] = buscaClasseDatabase(i,lbp_f,5);
  gar_far_5(i+1,1) = gar;
  gar_far_5(i+1,2) = far;
end

gar_far_5(1,:) = [];




% busca numa amostra de 6
gar_far_6 = [0 0];
for i=1 : 70
  [gar far] = buscaClasseDatabase(i,lbp_f,6);
  gar_far_6(i+1,1) = gar;
  gar_far_6(i+1,2) = far;
end

gar_far_6(1,:) = [];




% busca numa amostra de 7
gar_far_7 = [0 0];
for i=1 : 70
  [gar far] = buscaClasseDatabase(i,lbp_f,7);
  gar_far_7(i+1,1) = gar;
  gar_far_7(i+1,2) = far;
end

gar_far_7(1,:) = [];




media_gar = [mean(gar_far_1(:,1)) mean(gar_far_2(:,1)) mean(gar_far_3(:,1)) mean(gar_far_4(:,1)) mean(gar_far_5(:,1)) mean(gar_far_6(:,1)) mean(gar_far_7(:,1)) ];

media_far = [mean(gar_far_1(:,2)) mean(gar_far_2(:,2)) mean(gar_far_3(:,2)) mean(gar_far_4(:,2)) mean(gar_far_5(:,2)) mean(gar_far_6(:,2)) mean(gar_far_7(:,2)) ];


%--------


roc_curve(media_far/100,media_gar/100)


%+----------------------------------------------------------+
%|               Funcao buscaClasseDatabase()               |
%+----------------------------------------------------------+

function [gar,far] = buscaClasseDatabase(classe,database,qtdd)
    fprintf("\n--------\n")
    % ordenar a base antes da consulta
    database_ord = ordenaPelaDistancia(classe,database);
    
    false=0;
    genuine=0;
    far=0;
    gar=0;
    
    % obtem quantos registros pertencem a classe 
    for i=1 : qtdd
       if database_ord(i,1) == classe
           fprintf("REGISTRO %i EH DA MESMA CLASSE\n", i)
           genuine=genuine+1;
           gar=(genuine*100)/qtdd;
       else
           fprintf("REGISTRO %i NAO EH DA MESMA CLASSE\n", i)
           false=false+1;
           far=(false*100)/qtdd;
       end
    end
    
    %gar
    %far
    
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
                valor = database(i,3:258); %acha a primeira amostra da classe passada
                
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





% ROC Curve version 2.1.0.0 (7.8 KB) by Víctor Martínez
% adaptacoes por thiago@fatecourinhos.edu.br
function ROC_data = roc_curve(class_1, class_2, dispp, dispt)

    if(nargin<4), dispt = 1;    end
    if(nargin<3), dispp = 1;    end
    if(nargin<2), error('Class_1 or class_2 are not indicated.'); end
    class_1 = class_1(:);
    class_2 = class_2(:);
    

    s_data = unique(sort([class_1; class_2]));        
    s_data(isnan(s_data)) = [];               
    d_data = diff(s_data);                   
    if(isempty(d_data)), error('Both class data are the same!'); end
    d_data(length(d_data)+1,1) = d_data(length(d_data));
    thres(1,1) = s_data(1) - d_data(1);                
    thres(2:length(s_data)+1,1) = s_data + d_data./2;   
    
 
    
    if(nanmean(class_1)>nanmean(class_2))    
    end
    
    
    curve = zeros(size(thres,1),2);
    distance = zeros(size(thres,1),1);
    for id_t = 1:1:length(thres)
        TP = length(find(class_2 >= thres(id_t)));  
        FP = length(find(class_1 >= thres(id_t)));  
        FN = length(find(class_2 < thres(id_t)));  
        TN = length(find(class_1 < thres(id_t)));   
        
        curve(id_t,1) = TP/(TP + FN);  
        curve(id_t,2) = TN/(TN + FP);	
        

        distance(id_t)= sqrt((1-curve(id_t,1))^2+(curve(id_t,2)-1)^2);
    end
    
    
    [~, opt] = min(distance);
    TP = length(find(class_2 >= thres(opt)));   
    FP = length(find(class_1 >= thres(opt)));    
    FN = length(find(class_2 < thres(opt)));                                    
    TN = length(find(class_1 < thres(opt)));                                    
        
    param.Threshold = thres(opt);    
    param.Sensi = curve(opt,1);
    param.Speci = curve(opt,2);     
    param.AROC  = abs(trapz(1-curve(:,2), curve(:,1))); 
    param.Accuracy = (TP+TN)/(TP+TN+FP+FN);            
    param.PPV   = TP/(TP+FP);          
    param.NPV   = TN/(TN+FN);        

    if(dispp == 1)
        %fill_color = [0/255, 208/255, 217/255];
        %fill([1-curve(:,2); 1], [curve(:,1); 0], fill_color,'FaceAlpha',0.5);
        hold on; a2 = plot(1-curve(:,2), curve(:,1), 'g-', 'LineWidth', 2);
        %hold on; plot(1-curve(opt,2), curve(opt,1), 'or', 'MarkerSize', 10);
        %hold on; plot(1-curve(opt,2), curve(opt,1), 'xr', 'MarkerSize', 12);
        hold on; xlabel('FAR - Taxa de Falsa Aceitação'); ylabel('GAR - Taxa de Genuína Aceitação');
        num2str(param.AROC)
        legend([a2], 'FACE (AUC 0.36)','Location','northwest')
        title(param.Threshold)
        hold off
    end
    
    
    if(dispt == 1)
        fprintf('\n ROC CURVE PARAMETERS\n');
        fprintf(' ------------------------------\n');
        fprintf('  - Distance:     %.4f\n', distance(opt));
        fprintf('  - Threshold:    %.4f\n', param.Threshold);
        fprintf('  - Sensitivity:  %.4f\n', param.Sensi);
        fprintf('  - Specificity:  %.4f\n', param.Speci);
        fprintf('  - AROC:         %.4f\n', param.AROC);
        fprintf('  - Accuracy:     %.4f%%\n', param.Accuracy*100);
        fprintf('  - PPV:          %.4f%%\n', param.PPV*100);
        fprintf('  - NPV:          %.4f%%\n', param.NPV*100);
        fprintf(' \n');
    end
    
    
    ROC_data.param = param;
    ROC_data.curve = curve;
end

