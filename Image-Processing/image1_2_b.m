clear
img = load("hall.mat");
[m, n, ~] = size(img.hall_color);

a = m / 24; b = n / 24;
flag1 = 1; flag2 = 1;
for i = 1 : m
    if mod(i, 24) == 0
        flag1 = ~flag1;
    end
    flag2 = 1;
    for j = 1 : n
        if mod(j, 24) == 0
            flag2 = ~flag2;
        end
        if xor(flag1, flag2) == 1
            img.hall_color(i, j, 1:3) = [0, 0, 0];
        end
    end
end
imshow(img.hall_color);
imwrite(img.hall_color, 'image1_2_b.bmp')