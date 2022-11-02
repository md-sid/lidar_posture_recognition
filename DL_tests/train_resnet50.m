clear; clc; close all;

rng(0);

imds = imageDatastore('train/', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

imds.ReadFcn = @customReadDatstoreImage;

[imTrain, imValid, imTest] = splitEachLabel(imds, 0.65, 0.15, 0.20, 'randomized');
% [imTrain, imValid] = splitEachLabel(imds, 0.8, 0.2, 'randomized');

numClasses = numel(categories(imds.Labels));

%% modify network and set options
net = resnet50;
lgraph = layerGraph(net);

newin = imageInputLayer([16 128 3], 'Name', 'input_fixed');
lgraph = replaceLayer(lgraph, 'input_1', newin);

newFc = fullyConnectedLayer(numClasses,"Name","new_fc");
lgraph = replaceLayer(lgraph,"fc1000",newFc);

newOut = classificationLayer("Name","new_out");

lgraph = replaceLayer(lgraph,"ClassificationLayer_fc1000",newOut);

options = trainingOptions("sgdm","InitialLearnRate", 0.001, 'ValidationData', imValid, ...
    'MaxEpochs', 2, 'MiniBatchSize', 32);

%% perform training
[lid_resnet50,info] = trainNetwork(imTrain, lgraph, options);

%% classify test images
% imTest = imageDatastore('test/', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
% imTest.ReadFcn = @customReadDatstoreImage;
testpreds = classify(lid_resnet50,imTest);

%% evaluate result
nnz(testpreds == imTest.Labels)/numel(testpreds)

confusionchart(imTest.Labels,testpreds);
