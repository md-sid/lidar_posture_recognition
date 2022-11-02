clear; clc; close all;

files = dir('xyzinten/*.mat');

k = 3;
fileName = [files(k).folder '/' files(k).name];
saveName = ['featData' fileName(63:end)];

load(fileName);

%%
% 0 - valid, 1 - invalid, 2 - empty bed, 3 - side
labels = zeros(17701,1);

%2 is empty bed 1 is invalid
labels(1:520) = 2;
labels(521:545) = 1;
labels(546:730) = 2;
labels(731:740) = 1;
labels(741:1146) = 2;
labels(1147:1162) = 1;
labels(1163:1176) = 2;
labels(1177:1221) = 1;
labels(1222:1283) = 2;
labels(1284:2016) = 1;
labels(2288:2387) = 1;
labels(2515:3289) = 1;
labels(3892:3951)=1;
labels(6830:7889) = 1;
labels(9786:10355)= 1;
labels(10845:10876)=1;
labels(11023:11053)=1;
labels(12395:12754)=1;
labels(14664:15195)=1;
labels(15296:17144)=3;
labels(17145:17624)=1;
labels(17625:17701)=2;

%%
numFrames = length(fieldnames(data));

tmp = 1 : numFrames;
windowMatrix = tmp((0:13:numFrames-25)' + (1:25));

feat = zeros(size(windowMatrix, 1), 11);

for i = 1 : size(windowMatrix, 1)
    feat(i, 11) = mode(labels(windowMatrix(i, :)));
    totX = []; totY = []; totZ = []; totInten = []; totHeight = [];
    for j = 1 : 25
        curFrame = windowMatrix(i, j);
        totX = [totX; data.(['frame_' num2str(curFrame, '%04.f')]).x];
        totY = [totY; data.(['frame_' num2str(curFrame, '%04.f')]).y];
        totZ = [totZ; data.(['frame_' num2str(curFrame, '%04.f')]).z];
        totInten = [totInten; data.(['frame_' num2str(curFrame, '%04.f')]).intensity];
        
        height = data.(['frame_' num2str(curFrame, '%04.f')]).height;
        if size(height, 1) ~= 16
            height(size(height, 1)+1 : 16, 1:end) = nan;
        end
        totHeight = cat(3, totHeight, height);
    end
    feat(i, 1) = mean(totX); feat(i, 2) = std(totX);
    feat(i, 3) = mean(totY); feat(i, 4) = std(totY);
    feat(i, 5) = mean(totZ); feat(i, 6) = std(totZ);
    feat(i, 7) = mean(totInten); feat(i, 8) = std(totInten);
    
    framediff = zeros(16, 128, 24);
    for m = 1 : 24
        framediff(:, :, m) = totHeight(:, :, m+1) - totHeight(:, :, m);
    end
    framediff(isnan(framediff)) = [];
    feat(i, 9) = mean(framediff(:)); feat(i, 10) = std(framediff(:));
end

save(saveName, 'feat', '-v7.3');
