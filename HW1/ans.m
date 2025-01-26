% 读取图片
im = imread('peppers.png');  % 替换为你自己的图像文件路径

% 定义 costfunction
costfunction = @(im) sum( imfilter(double(im), [.5 1 .5; 1 -6 1; .5 1 .5]).^2, 3 );

% 计算能量图
E = costfunction(im);

% 显示结果
figure;

% 显示原图
subplot(1, 2, 1);
imshow(im);
title('原图');

% 显示能量图
subplot(1, 2, 2);
imshow(E, []);
title('基于滤波器的能量图');
colorbar;  % 添加颜色条
