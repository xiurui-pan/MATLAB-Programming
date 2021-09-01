clear
load('v.mat');

img0 = imread('faces.bmp');

[m, n, ~] = size(img0);
img = floor(double(img0)/(2^(8-L)));

pres = zeros(m+5, n+5, 2^(3*L));
for i = 2:m+1
    for j = 2:n+1
        incode = 1;
        for c = 1:3
            incode = incode + img(i-1, j-1, c) * 2^((c-1)*L);
        end 
        pres(i, j, incode) = 1;
        pres(i, j, :) = pres(i-1, j, :) + pres(i, j-1, :) - pres(i-1, j-1, :) + pres(i, j, :);

    end
end
