clear
img = load('hall.mat');
[m, n] = size(img.hall_gray);
img.hall_gray = double(img.hall_gray);
a = dct2(img.hall_gray - 128);
b1 = dct2(img.hall_gray);
b2 = dct2(zeros(m, n) + 128);
b = b1 - b2;
err = b - a;
max(max(err))