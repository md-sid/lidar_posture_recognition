% clear; clc; close all;
% 
% pathnames = {['D:\Montana Tech\TRM-MSU-MTECH - General\2-4-2021\' ...
%     '2021-02-04-14-02-50_Velodyne-VLP-16-Data_(Frames-1-8000)'], ...
%     ['D:\Montana Tech\TRM-MSU-MTECH - General\2-4-2021\' ...
%     '2021-02-04-14-02-50_Velodyne-VLP-16-Data_(Frames-8001-16002)']};
% 
% savename = 'xyzinten/02_04_2021_s1';
% 
% minx = []; maxx = [];

for i = 1 : length(pathnames)
    pathname = pathnames{i};
    files = dir([pathname '/*.csv']);

    for j = 1 : length(files)
        tmp = strfind(files(j).name, '(');
        framenum = files(j).name(tmp(end) + 7 : end - 5);
        fprintf('Computing Frame %s\n', framenum);

        bdata = csvread([pathname '/' files(j).name], 1);
        [x, y, z] = pol2cart(bdata(:, 9)*pi/180/100, bdata(:, 10), ...
            (bdata(:, 13))*pi/180);
        intensity = bdata(:, 7);

        loc = [x(:),y(:),z(:)];
        ptCloud = pointCloud(loc);
        minDistance = 0.15;
        [labels,numClusters] = pcsegdist(ptCloud,minDistance);
        numLabels = zeros;
        for k = 1 : numClusters
            numLabels(k) = numel(find(labels == k));
        end
        num = find(numLabels == max(numLabels));
        
        x = x(labels == num);
        y = y(labels == num);
        z = z(labels == num);
        intensity = intensity(labels == num);

        saveField = ['frame_' framenum];
        data.(saveField).x = x;
        data.(saveField).y = y;
        data.(saveField).z = z;
        data.(saveField).intensity = intensity;

        zbins = unique(z);
        for k = 1 : length(zbins)
            tmp = find(z == zbins(k));
            newx{k} = x(tmp);
            newy{k} = y(tmp);
            newz{k} = z(tmp);
            newintensity{k} = intensity(tmp);
        end

        if length(minx) < 1
            for k = 1 : length(zbins)
                minx(k) = min(newx{k});
                maxx(k) = max(newx{k});
            end

            minx = max(minx) - 0.2;
            maxx = min(maxx) + 0.2;
            xbins = linspace(minx, maxx, 128);
        end

        x = [];
        y = [];
        z = [];
        inten = [];

        for k = 1 : length(zbins)
            x = [x, newx{k}'];
            y = [y, newy{k}'];
            z = [z, newz{k}'];
            inten = [inten, newintensity{k}'];
        end

        height_img = zeros(length(zbins), length(xbins));
        count = zeros(length(zbins), length(xbins));

        for k = 1 : length(x)
            [~, zloc] = min(abs(zbins - z(k)));
            [~, xloc] = min(abs(xbins - x(k)));
            count(zloc, xloc) = count(zloc, xloc) + 1;
            height_img(zloc, xloc) = height_img(zloc, xloc, 1) + y(k);
        end
        
        height_img = height_img./count;
        height_img(isnan(height_img)) = 0;
        data.(saveField).height = height_img;

    end

end

save(savename, 'data', '-v7.3');
