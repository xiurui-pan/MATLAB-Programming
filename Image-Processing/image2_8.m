clear
load('hall.mat');
load('JpegCoeff.mat');

[m, n] = size(hall_gray);
DCT = zeros(64, m*n/64);
for i = 1:m/8
    for j = 1:n/8
        block = hall_gray((i-1)*8+1:i*8, (j-1)*8+1:j*8);

        block = dct2(double(block) - 128);
        block = round(block ./ QTAB);
        vec = image2_7(block); % 自己编写的zigzag函数
        DCT(:, (i-1)*8+j) = vec;
    end
end