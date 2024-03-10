%% This is an example to demonstrate how to use the C3 hyperbola 
% detection and fitting algorithm 
%% ������ʾ���ʹ�� C3 ˫���ߵ�ʾ��
% ��������㷨
addpath('c3_algorithms/')  


%% ��ȡ ͼ��
% load a GPR image
%����̽���״�ͼ��
real_im = imread('17-2.png');

%% �ҶȻ�
real_im = rgb2gray(real_im);

%% detect and fit hyperbolae using the proposed C3 algorithm;
% the ouput is a list of the coordinates of fitted hyperbolae
% ʹ�ý���� C3 �㷨�������˫���ߣ�   ����� C3  �㷨  �������������˫���ߵ�  ������� ���˫���ߵ������б�
% ��������˫���ߵ������б�

hyperbolae = c3_hyperbola_fitting(real_im); 


%% ����ʹ�õĺ���ֻ��  c3_hyperbola_fitting  