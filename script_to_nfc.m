clear all
clc

%definindo a pasta com os arquivos de imagens
outputFolder = fullfile('D:\coloridas')
%definindo a pasta que contem as subpastas para cada classe
rootFolder = fullfile(outputFolder, 'imagem_color');
categories = {'back', 'doenca', 'saudavel'};
%criar um banco de dados das imagens
imds = imageDatastore(fullfile(rootFolder, categories), 'LabelSource', 'foldernames');
%dividir o banco de dados em teste e treino
[trainingSet, testSet] = splitEachLabel(imds, 0.3, 'randomize');

%% dados de treino
%regularizar o número de dados de treino por classe - escolher o menor conjunto
trainbl = countEachLabel(trainingSet)
minSetCount = min(trainbl{:,2}); % determine the smallest amount of images in a category
% Use splitEachLabel method to trim the set.
trainingSet = splitEachLabel(trainingSet, minSetCount, 'randomize');
% Notice that each set now has exactly the same number of images.
countEachLabel(trainingSet)

number_image_train = size(trainingSet.Files,1);

for i= 1:number_image_train
    disp (['Lendo a imagem img_' num2str(i) ' .JPG']);
    img = readimage(trainingSet,i);
    img = rgb2gray(img);    
    texture(i).s = statxture(img);
end
    
textura_treino = vertcat(texture.s);



%% Dados de teste
%regularizar o número de dados de treino por classe - escolher o menor conjunto
testbl = countEachLabel(testSet)
minSetCount = min(testbl{:,2}); % determine the smallest amount of images in a category
% Use splitEachLabel method to trim the set.
testSet = splitEachLabel(testSet, minSetCount, 'randomize');
% Notice that each set now has exactly the same number of images.
countEachLabel(testSet)

number_image_test = size(testSet.Files,1);

for i= 1:number_image_test
    disp (['Lendo a imagem img_' num2str(i) ' .JPG']);
    img = readimage(testSet,i);
    img = rgb2gray(img);    
    texture(i).t = statxture(img);
end
    
textura_teste = vertcat(texture.t);


trainingLabels = trainingSet.Labels;
testLabels = testSet.Labels;

uisave({'textura_treino'});
uisave({'trainingLabels'});

uisave({'textura_teste'});
uisave({'testLabels'});

%first classifier
[fismat,outputs,recog_tr,recog_te,labels,performance]=scg_nfc(textura_treino,trainingLabels,textura_teste,testLabels,100,3,1);
