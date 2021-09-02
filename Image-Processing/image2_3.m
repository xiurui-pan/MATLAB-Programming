clear
img = load('hall.mat');
hall = double(img.hall_gray) - 128;
figure(1);
imshow(uint8(hall+128));
transd = dct2(hall);
transd_ = transd;
transd_(:, end-3:end) = 0;
hall_ = uint8(idct2(transd_)+128);
figure(2);
imshow(hall_);
transd__ = transd;
transd__(:, 1:4) = 0;
hall__ = uint8(idct2(transd__)+128);
figure(3);
imshow(hall__);