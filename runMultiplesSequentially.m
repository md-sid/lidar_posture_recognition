clear; clc; close all;

allPathNames = {'D:\Montana Tech\TRM-MSU-MTECH - General\2-11-2021\Subject 1\2021-02-11-11-43-17_Velodyne-VLP-16-Data_(Frames-1-9000)';
    'D:\Montana Tech\TRM-MSU-MTECH - General\2-11-2021\Subject 1\2021-02-11-11-43-17_Velodyne-VLP-16-Data_(Frames-9001-17701)';
    'D:\Montana Tech\TRM-MSU-MTECH - General\2-11-2021\Subject 2\2021-02-11-13-36-15_Velodyne-VLP-16-Data_(Frames-1-9000)';
    'D:\Montana Tech\TRM-MSU-MTECH - General\2-11-2021\Subject 2\2021-02-11-13-36-15_Velodyne-VLP-16-Data_(Frames-9001-17515)';
    'D:\Montana Tech\TRM-MSU-MTECH - General\2-12-2021\2021-02-12-10-05-11_Velodyne-VLP-16-Data_(Frames-1-8000)';
    'D:\Montana Tech\TRM-MSU-MTECH - General\2-12-2021\2021-02-12-10-05-11_Velodyne-VLP-16-Data_(Frames-8001-13810)';
    'D:\Montana Tech\TRM-MSU-MTECH - General\2-18-2021\Subject1\2021-02-18-09-35-15_Velodyne-VLP-16-Data_1';
    'D:\Montana Tech\TRM-MSU-MTECH - General\2-18-2021\Subject1\2021-02-18-09-35-15_Velodyne-VLP-16-Data_2';
    'D:\Montana Tech\TRM-MSU-MTECH - General\2-18-2021\Subject2\2021-02-18-11-02-13_Velodyne-VLP-16-Data_1';
    'D:\Montana Tech\TRM-MSU-MTECH - General\2-18-2021\Subject2\2021-02-18-11-02-13_Velodyne-VLP-16-Data_2';
    'D:\Montana Tech\TRM-MSU-MTECH - General\2-18-2021\Subject3\2021-02-18-13-48-58_Velodyne-VLP-16-Data_1';
    'D:\Montana Tech\TRM-MSU-MTECH - General\2-18-2021\Subject3\2021-02-18-13-48-58_Velodyne-VLP-16-Data_2';
    'D:\Montana Tech\TRM-MSU-MTECH - General\2-18-2021\Subject4\2021-02-18-16-27-53_Velodyne-VLP-16-Data_1';
    'D:\Montana Tech\TRM-MSU-MTECH - General\2-18-2021\Subject4\2021-02-18-16-27-53_Velodyne-VLP-16-Data_2';
    'D:\Montana Tech\TRM-MSU-MTECH - General\2-19-2021\Subject1\2021-02-19-10-04-08_Velodyne-VLP-16-Data_1';
    'D:\Montana Tech\TRM-MSU-MTECH - General\2-19-2021\Subject1\2021-02-19-10-04-08_Velodyne-VLP-16-Data_2';
    'D:\Montana Tech\TRM-MSU-MTECH - General\2-19-2021\Subject2\2021-02-19-10-59-42_Velodyne-VLP-16-Data_1';
    'D:\Montana Tech\TRM-MSU-MTECH - General\2-19-2021\Subject2\2021-02-19-10-59-42_Velodyne-VLP-16-Data_2';
    'D:\Montana Tech\TRM-MSU-MTECH - General\2-19-2021\Subject3\2021-02-19-11-57-01_Velodyne-VLP-16-Data_1';
    'D:\Montana Tech\TRM-MSU-MTECH - General\2-19-2021\Subject3\2021-02-19-11-57-01_Velodyne-VLP-16-Data_2';
    'D:\Montana Tech\TRM-MSU-MTECH - General\2-25-2021\Subject 1\2021-02-25-09-39-12_Velodyne-VLP-16-Data_1';
    'D:\Montana Tech\TRM-MSU-MTECH - General\2-25-2021\Subject 1\2021-02-25-09-39-12_Velodyne-VLP-16-Data_2'};

numFolders = [2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2];

allSaveNames = ["xyzinten/02_11_2021_s1";
    "xyzinten/02_11_2021_s2";
    "xyzinten/02_12_2021_s1";
    "xyzinten/02_18_2021_s1";
    "xyzinten/02_18_2021_s2";
    "xyzinten/02_18_2021_s3";
    "xyzinten/02_18_2021_s4";
    "xyzinten/02_19_2021_s1";
    "xyzinten/02_19_2021_s2";
    "xyzinten/02_19_2021_s3";
    "xyzinten/02_25_2021_s1"];

n = 0;
for a = 1 : length(allSaveNames)
    clear data;
    savename = allSaveNames(a);
    pathnames = allPathNames(n+1 : n+numFolders(a));
    minx = []; maxx = [];
    run("csv2xyzinten.m");
    n = n+numFolders(a);
end