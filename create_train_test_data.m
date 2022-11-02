clear; clc; close all;
rng(0);

files = dir('featData/*.mat');

trainData = [];
testData = [];

for i = 1 : 13
    clear feat;
    filename = [files(i).folder '/' files(i).name];
    load(filename);
    if i <= 10
        trainData = [trainData; feat];
    else
        testData = [testData; feat];
    end
end

idx = randperm(size(trainData, 1));
trainData = trainData(idx, :);

idx = randperm(size(testData, 1));
testData = testData(idx, :);

%%
% x20 = round(size(trainData, 1)*0.2);
% tstData = trainData(end-x20:end, :);
% trnData = trainData(1:end-x20-1, :);
% 
%% 
% trnData(:, 9:10) = [];
% tstData(:, 9:10) = [];

%%
trainData(:, 9:10) = [];
testData(:, 9:10) = [];
