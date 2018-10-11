% +-----------------------------------------+
% | Atividade do Prof. Ap. Nilceu Marana    |
% | PPGCC - Unesp - 2018/2nd semestre       |
% | Discente: Thiago José Lucas             |
% | thiago@fatecourinhos.edu.br             |
% +-----------------------------------------+
% | Detecta bordas com filtro de sobel      |
% | Encontra o espaco de Hough              |
% | Identifica os picos na transformada     |
% | Encontra as retas da imagem e as plota  |
% +-----------------------------------------+

clear all
close all
% imagem escolhida
img = imread('quadrados_coloridos.jpg');
imgc = img;

% transformacao da imagem em 8 bits
img = rgb2gray(img);

% filtro sobel vertical
sobel_vertical = [-1 0 1; -2 0 2; -1 0 1];
% convolucao com a imagem - p/ detectar bordas verticais
linhas_verticais = conv2(sobel_vertical,img);

% filtro sobel horizontal
sobel_horizontal = [1 2 1; 0 0 0; -1 -2 -1];
% convolucao com a imagem - p/ detectar bordas horizontais
linhas_horizontais = conv2(sobel_horizontal,img);

% somar as imagens e retirar valores negativos (sem retirar negativos p/ teste)
img = 255-(linhas_verticais + linhas_horizontais);

% inverte as cores para obter o negativo
for i=1 : size(img,1)
    for j=1 : size(img,2)
        if img(i,j) == 255
            img(i,j) = 0;
        else
            img(i,j) = 255;
        end
    end
end
figure(1)
imshow(img)

% encontra os valores da transformada de hough
[H,theta,rho] = hough(img) ;
% - theta eh o angulo no sentido horario entre a projecao e o eixo x
% - rho eh o comprimento da projecao theta

% plota a transformada de hough
figure(2)
imshow(imadjust(rescale(H)),[],'XData',theta,'YData',rho,'InitialMagnification','fit');
xlabel('Valor de \theta')
ylabel('Valor de \rho')
axis on
axis normal
hold on

% encontra os picos
P = houghpeaks(H,100,'Threshold',2);
% busca por 100 picos na imagem
% tive melhor resultado com threshold 2
plot(theta(P(:,2)),rho(P(:,1)),'s','color','red');

% encontra as linhas
lines = houghlines(img,theta,rho,P,'FillGap',5,'MinLength',7);
% funcao para buscar as linhas correspondentes aos picos no espaco de hough

% laco para desenhar as linhas na imagem
% e tb para gerar a tabela de retas solicitadas pelo prof. Nilceu no item i
figure(3), imshow(imgc), hold on
for i=1 : length(lines)
   xy = [lines(i).point1; lines(i).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % desenha na imagem os inicios e finais das retas
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % gera a tabela de retas solicitadas pelo prof. Nilceu no item i
   fprintf("Linha [%i]\tPonto A [x: %i, y: %i]\tPonto B [x: %i, y: %i]\n",i, xy(1,1), xy(1,2), xy(2,1), xy(2,2))
   

end

