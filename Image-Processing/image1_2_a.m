clear
img = load("hall.mat");
[m, n, ~] = size(img.hall_color);
r = min(m, n) / 2;
y = m / 2; x = n / 2;
theta = 0 : pi/200 : 2*pi;

a = max(x + fix(r * cos(theta)), 1);
b = max(y + fix(r * sin(theta)), 1);
[~, tmp] = size(b);

for i = 1 : tmp
    img.hall_color(b(i), a(i), 1:3) = [255, 0, 0];
end
imshow(img.hall_color);
imwrite(img.hall_color, 'image1_2_a.bmp');