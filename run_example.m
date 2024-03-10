%% This is an example to demonstrate how to use the C3 hyperbola 
% detection and fitting algorithm 
%% 这是演示如何使用 C3 双曲线的示例
% 检测和拟合算法
addpath('c3_algorithms/')  


%% 读取 图像
% load a GPR image
%加载探地雷达图像
real_im = imread('17-2.png');

%% 灰度化
real_im = rgb2gray(real_im);

%% detect and fit hyperbolae using the proposed C3 algorithm;
% the ouput is a list of the coordinates of fitted hyperbolae
% 使用建议的 C3 算法检测和拟合双曲线；   这里的 C3  算法  是用来检测和拟合双曲线的  输出的是 拟合双曲线的坐标列表
% 输出是拟合双曲线的坐标列表

hyperbolae = c3_hyperbola_fitting(real_im); 


%% 这里使用的函数只有  c3_hyperbola_fitting  