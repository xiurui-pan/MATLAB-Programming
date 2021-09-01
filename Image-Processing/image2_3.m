clear
img = load('hall.mat');
hall = img.hall_gray(1:100, 1:100);
figure(1);
imshow(hall);
transd = dct2(hall);
transd_ = transd;
transd_(:, end-3:end) = 0;
hall_ = uint8(idct2(transd_));
figure(2);
imshow(hall_);
transd__ = transd;
transd__(:, 1:4) = 0;
hall__ = uint8(idct2(transd__));
figure(3);
imshow(hall__);