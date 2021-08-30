clear
load('hall.mat')
img = hall_gray;
msg = dec2bin('xinhaoyuxitonghenyouqu');
[m, n] = size(msg);
figure;
subplot(2, 1, 1);
imshow(img);
for i = 1:120
    for j = 1:168
        org = dec2bin(img(i, j));
        org(end) = msg(mod(i-1, m)+1, mod(j-1, n)+1);
        img(i, j) = bin2dec(org);
    end
end
subplot(2, 1, 2);
imshow(img);

msg_decoded = zeros(m, n);
for i = 1:m
    for j = 1:n
        org = dec2bin(img(i, j));
        msg_decoded(i, j) = org(end);
    end
end
msg_decoded = char(bin2dec(char(msg_decoded)))