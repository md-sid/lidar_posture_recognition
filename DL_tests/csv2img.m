clear; clc; close all;

baseName = '2_25_s1/';

% 0 - valid, 1 - invalid, 2 - empty bed, 3 - side
labels = zeros(12345,1); labels(1:398)=2; labels(399:1983)=1; labels(3045:3099)=1;
labels(5403:5995)=1; labels(7934:8204)=1; labels(8787:8817)=1; labels(10079:10391)=1;
% labels(10392:12336)=3; labels(10336:12345)=1;
labels(10392:12336)=3; labels(12337:12345)=1;
%%
tic
pathnames = dir(['../../TRM data/' baseName '*Velodyne*']);

% validImages = ['./train/valid/' baseName(1:end-1)];
% invalidImages = ['./train/invalid/' baseName(1:end-1)];
% bedImages = ['./train/bed/' baseName(1:end-1)];
% sideImages = ['./train/side/' baseName(1:end-1)];

validImages = ['./test/valid/' baseName(1:end-1)];
invalidImages = ['./test/invalid/' baseName(1:end-1)];
bedImages = ['./test/bed/' baseName(1:end-1)];
sideImages = ['./test/side/' baseName(1:end-1)];
imgName = ['./testDatabyDate/' baseName];

minx = []; maxx = [];
for j = 1 : length(pathnames)
    pathname = [pathnames(j).folder '/' pathnames(j).name];
    files = dir([pathname '/*.csv']);
    
    if j == 1 
        bdata = csvread([pathname '/' files(1).name], 1);
        [x, y, z] = pol2cart(bdata(:, 9)*pi/180/100, bdata(:, 10), ...
            (bdata(:, 13))*pi/180);
        intensity = bdata(:, 7);

        loc1 = [x(:),y(:),z(:)];
        ptCloud = pointCloud(loc1);

        minDistance = 0.19;
        [label,numClusters] = pcsegdist(ptCloud,minDistance);
        numLabels = zeros(1, numClusters);
        for i = 1 : numClusters
            numLabels(i) = numel(find(label == i));
        end
        num = find(numLabels == max(numLabels));

        x = x(label == num);
        y = y(label == num);
        z = z(label == num);
        intensity = intensity(label == num);

        zbins = unique(z);
        lenZ = length(zbins);
        newx = cell(1, lenZ); newy = cell(1, lenZ);
        newz = cell(1, lenZ); newintensity = cell(1, lenZ);
        for i = 1 : lenZ
            tmp = find(z == zbins(i));
            newx{i} = x(tmp);
        end
        
        if length(minx) < 1
            for i = 1 : lenZ
                minx = cat(2, minx, min(newx{i}));
                maxx = cat(2, maxx, max(newx{i}));
            end

            minx = max(minx) - 0.2;
            maxx = min(maxx) + 0.2;
            xbins = linspace(minx, maxx, 128);
        end    
    end
    
    parfor k = 1 : length(files)
        tmp = strfind(files(k).name, '(');
        framenum = files(k).name(tmp(end)+7:end-5);
        fprintf('Computing Frame %s\n', framenum);
        
        bdata = csvread([pathname '/' files(k).name], 1);
        [x, y, z] = pol2cart(bdata(:, 9)*pi/180/100, bdata(:, 10), ...
            (bdata(:, 13))*pi/180);
        intensity = bdata(:, 7);
        
        loc1 = [x(:),y(:),z(:)];
        ptCloud = pointCloud(loc1);
        
        minDistance = 0.19;
        [label,numClusters] = pcsegdist(ptCloud,minDistance);
        numLabels = zeros(1, numClusters);
        for i = 1 : numClusters
            numLabels(i) = numel(find(label == i));
        end
        num = find(numLabels == max(numLabels));
        
        x = x(label == num);
        y = y(label == num);
        z = z(label == num);
        intensity = intensity(label == num);
        
        zbins = unique(z);
        lenZ = length(zbins);
        newx = cell(1, lenZ); newy = cell(1, lenZ);
        newz = cell(1, lenZ); newintensity = cell(1, lenZ);
        for i = 1 : lenZ
            tmp = find(z == zbins(i));
            newx{i} = x(tmp);
            newy{i} = y(tmp);
            newz{i} = z(tmp);
            newintensity{i} = intensity(tmp);
        end
        
        data = zeros(lenZ, length(xbins));
        count = zeros(lenZ, length(xbins));

        for i = 1 : length(x)
            [~, zloc] = min(abs(zbins - z(i)));
            [~, xloc] = min(abs(xbins - x(i)));
            count(zloc, xloc) = count(zloc, xloc) + 1;
            data(zloc, xloc) = data(zloc, xloc, 1) + y(i);
        end
        data = mat2gray(data./count);
        
        ll = labels(str2double(framenum));
        if ll == 0
            imwrite(data, [validImages '_' framenum '.png']);
        elseif ll == 1
            imwrite(data, [invalidImages '_' framenum '.png']);
        elseif ll == 2
            imwrite(data, [bedImages '_' framenum '.png']);
        elseif ll == 3
            imwrite(data, [sideImages '_' framenum '.png']);
        end
        
        imwrite(data, [imgName framenum '.png']);
    end
end

fprintf('Task Completed.\n'); 
toc
