function output = c3_hyperbola_fitting(real_im)
% This file presents the c3_algorithm for detecting and fitting hypobola
% form Ground Penetrating Radar (GPR) B-scan images.

% real_im is a greyscale GPR image
% output is a structure storing the (x, y) coordinates of all fitted hyperbolae

% Plese cite the following article if you are using this code in your work:
%   Dou Q, Wei L, Magee D, Cohn A. 2017. 
%   Real-Time Hyperbola Recognition and Fitting in GPR Data. 
%   IEEE Transactions on Geoscience and Remote Sensing. 51-62 55.1 


% 该文件提供了用于检测和拟合双曲线的 c3_algorithm
% 形成探地雷达 (GPR) B 扫描图像。

% real_im 是灰度 GPR 图像
% 输出是一个结构体，存储所有拟合双曲线的 (x, y) 坐标

% 如果您在工作中使用此代码，请引用以下文章：
% 窦Q，魏L，Magee D，Cohn A.2017。
% GPR 数据中的实时双曲线识别和拟合百分比。
% IEEE 地球科学和遥感汇刊。 51-62 55.1  


close all

real_im = double(real_im);

tic
% Step 1: region clustering using C3 alorithm
% 步骤1：使用C3算法进行区域聚类
%% 这一步中所使用的 column_connection_clustering_v2   函数在同个文件夹下  这里只是调用一下 


[xx, yy, xxx, yyy] = column_connection_clustering_v2(real_im,0.25, 2, 1, 0.1);
x = -ones(3,length(xx));

% Step 2: fitting hyperbola
% Extract the ncc value of detected clusters w.r.t. a predefined hyperbola
% 步骤2：拟合双曲线
% 提取检测到的簇的 ncc 值 预定义的双曲线
for i = 1:size(yyy,1)
    [dy1, dy2, ~, ~] = ncc_values_v2(xxx{i,1},yyy{i,1});
    x(1,i) = dy1;
    x(2,i) = dy2;
end

% Change the values of y coordinates into negative
% 将y坐标的值改为负数
for i = 1:size(yy,1)
    yy{i,1} = -yy{i,1};
    yyy{i,1} = -yyy{i,1};
end

% Load the trained Neural Network hyperbola variables of v and w
% 加载训练好的神经网络双曲线变量 v 和 w
load('trained_vectors.mat') 
y = -ones(size(x));
vv = v*x;
y(1:2,:) = 2./(1 + exp(-vv)) - 1;
out_put = 2./(1 + exp(-w*y)) - 1;

subplot(2,3,6);
imagesc(real_im);
colormap gray(256);
title("Final results")

output = {};
ind_plus = find(out_put > 0);
if ~isempty(ind_plus)
    ind_plus = find(out_put > 0);
    xxx = xxx(ind_plus);
    xx = xx(ind_plus);
    yyy = yyy(ind_plus);
    yy = yy(ind_plus);
    out_v = cluster_cleaning(xx, yy);
    out_v = logical(out_v);
    xxx = xxx(out_v);
    xx = xx(out_v);
    yyy = yyy(out_v);
    yy = yy(out_v);

    for i=1:size(xx,1)
        for j=1:length(xx{i,1})
            im_regions(-yy{i,1}(j), xx{i,1}(j))=255;
        end
        subplot(2, 3, 5);
        imagesc(im_regions); 
        colormap gray(256);axis off;
        title('Hyperbola-like regions');
        % Fitting
        subplot(2, 3, 6); hold on;
        [a, b, xc, yc,a_ini, b_ini, xc_ini, yc_ini] = G_N_hyperbola_fitting_v2(xxx{i,1}, yyy{i,1}, 5);
        if ~isreal(a) || ~isreal(b) || a<0 || b<0 || a==inf || b==inf || isnan(a) || isnan(b)
            a = a_ini;
            b = b_ini;
            yc = yc_ini;
            xc = xc_ini;
        end
        if a < 1
            continue
        end
        h_interval = max(abs(xc-xxx{i,1}(1)),abs(xc-xxx{i,1}(end)));
        xs = (xc-h_interval-2):(xc+h_interval+2);
        ys = -a*sqrt(1+(xs-xc).^2/b^2)+yc;
        output(i).xs = xs;
        output(i).ys = ys;
        plot(xs, -ys, 'b-', 'linewidth', 2);
        drawnow
    end
end 


