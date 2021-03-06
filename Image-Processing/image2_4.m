clear
img = load('hall.mat');
hall = double(img.hall_gray)-128;
figure(1);
imshow(hall);
transd = dct2(hall);
tranversed = transd.';
rotted90 = rot90(transd);
rotted180 = rot90(rot90(transd));

tran = uint8(idct2(tranversed)+128);
ro90 = uint8(idct2(rotted90)+128);
ro18 = uint8(idct2(rotted180)+128);
figure(1);
subplot(1, 3, 1);
imshow(tran);
subplot(1, 3, 2);
imshow(ro90);
subplot(1, 3, 3);
imshow(ro18);