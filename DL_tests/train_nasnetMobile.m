clear; clc; close all;

rng(0);

imds = imageDatastore('train/', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

imds.ReadFcn = @customReadDatstoreImage;

[imTrain, imValid, imTest] = splitEachLabel(imds, 0.65, 0.15, 0.20, 'randomized');
% [imTrain, imValid] = splitEachLabel(imds, 0.8, 0.2, 'randomized');

numClasses = numel(categories(imds.Labels));

%% modify network and set options
net = nasnetmobile;
lgraph = layerGraph(net);

newin = imageInputLayer([16 128 3], 'Name', 'input_fixed');
lgraph = replaceLayer(lgraph, 'input_1', newin);

newFc = fullyConnectedLayer(numClasses,"Name","new_fc");
lgraph = replaceLayer(lgraph,"predictions",newFc);

newOut = classificationLayer("Name","new_out");
lgraph = replaceLayer(lgraph,"ClassificationLayer_predictions",newOut);

options = trainingOptions("sgdm","InitialLearnRate", 0.001, 'ValidationData', imValid, ...
    'MaxEpochs', 2, 'MiniBatchSize', 32, 'ExecutionEnvironment', 'cpu');

%% perform training
[lid_nasmobile,info] = trainNetwork(imTrain, lgraph, options);

%% classify test images
% imTest = imageDatastore('test/', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
% imTest.ReadFcn = @customReadDatstoreImage;
testpreds = classify(lid_nasmobile,imTest);

%% evaluate result
nnz(testpreds == imTest.Labels)/numel(testpreds)

confusionchart(imTest.Labels,testpreds);
