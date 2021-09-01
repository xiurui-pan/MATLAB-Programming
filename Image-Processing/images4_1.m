clear

L = 3;
v = zeros(2^(3*L), 1);
for k = 1:33
    img_path = cat(2, 'Faces/', num2str(k), '.bmp');
    img = imread(img_path);
    [m, n, ~] = size(img);
    img = floor(double(img)/(2^(8-L)));

    u = zeros(2^(3*L), 1);
    for i = 1:m
        for j = 1:n
            N = 1;
            for a = 1:3
                N = N + img(i, j, a) * 2^((a-1)*L);
            end
            u(N) = u(N) + 1;
        end
    end
    u = u / (m*n);
    v = v + u;
end
v = v / 33;

save('v.mat', 'v', 'L');