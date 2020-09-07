close all
clear all
clc

% |imageDatastore| automatically labels the images based on folder names and stores the data as an |ImageDatastore| 
% object. An image datastore lets you store large image data, including data that 
% does not fit in memory. Split the data into 80% training and 20% test data.

dataset_path = 'D:\RnD\Frameworks\Dataset\NEOMchallenge\dataset';
imds = imageDatastore(dataset_path,'IncludeSubfolders',true,'LabelSource','foldernames');
[imdsTrain,imdsTest] = splitEachLabel(imds,0.8,'randomized');

%Display some sample images.

numTrainImages = numel(imdsTrain.Labels);
idx = randperm(numTrainImages,16);
figure
for i = 1:16
    subplot(4,4,i)
    I = readimage(imdsTrain,idx(i));
    imshow(I)
end

% Load Pretrained Network
% Load a pretrained ResNet-18 network. If the Deep Learning Toolbox Model _for 
% ResNet-18 Network_ support package is not installed, then the software provides 
% a download link. ResNet-18 is trained on more than a million images and can 
% classify images into 1000 object categories, such as keyboard, mouse, pencil, 
% and many animals. As a result, the model has learned rich feature representations 
% for a wide range of images.

net = squeezenet%resnet18

% 
% Analyze the network architecture. The first layer, the image input layer, 
% requires input images of size 224-by-224-by-3 (resnet), 227-by-227-by-3 (squeezenet)

inputSize = net.Layers(1).InputSize;
analyzeNetwork(net)

% Extract Image Features
% The network requires input images of size 224-by-224-by-3, but the images 
% in the image datastores have different sizes. To automatically resize the training 
% and test images before they are input to the network, create augmented image 
% datastores, specify the desired image size, and use these datastores as input 
% arguments to |activations|.

augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain);
augimdsTest = augmentedImageDatastore(inputSize(1:2),imdsTest);
 
% The network constructs a hierarchical representation of input images. Deeper 
% layers contain higher-level features, constructed using the lower-level features 
% of earlier layers. To get the feature representations of the training and test 
% images, use |activations| on the global pooling layer, |'pool5',| at the end 
% of the network. The global pooling layer pools the input features over all spatial 
% locations, giving 512 features in total.

layer = 'pool10';%Transfer Learning
% OutputAs rows not supported by codegen. Hence changed it to channels.
% featuresTrain2 = activations(net,augimdsTrain,layer,'OutputAs','rows');
% featuresTest2 = activations(net,augimdsTest,layer,'OutputAs','rows');

featuresTrain = activations(net,augimdsTrain,layer,'OutputAs','channels');
featuresTest = activations(net,augimdsTest,layer,'OutputAs','channels');
featuresTrain = featuresTrain(:);
featuresTrain = reshape(featuresTrain,1000,[])';
featuresTest = featuresTest(:);
featuresTest = reshape(featuresTest,1000,[])';
% return

whos featuresTrain

% Extract the class labels from the training and test data.

YTrain = grp2idx(imdsTrain.Labels);
YTest = grp2idx(imdsTest.Labels);
% Fit Image Classifier
% Use the features extracted from the training images as predictor variables 
% and fit a multiclass support vector machine (SVM) using |fitcecoc| (Statistics 
% and Machine Learning Toolbox).

classifier = fitcecoc(featuresTrain,YTrain);

% Classify Test Images
% Classify the test images using the trained SVM model using the features extracted 
% from the test images.

YPred = predict(classifier,featuresTest);
% YPred_CNN = net.predict(augimdsTrain);

% Display four sample test images with their predicted labels.

idx = [21 23 26 29];
figure
for i = 1:numel(idx)
    subplot(2,2,i)
    I = readimage(imdsTest,idx(i));
    label = YPred(idx(i));
    imshow(I)
    title(char(label))
end
 
% Calculate the classification accuracy on the test set. Accuracy is the fraction 
% of labels that the network predicts correctly.

accuracy1 = mean(YPred == YTest)

save('svm_classifier','classifier');
