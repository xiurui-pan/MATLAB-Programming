% clear
load('v.mat');
% load('pre_img4_2.mat');
img0 = imread('faces.bmp');
epsilon = 0.35;

height = 35; width = 25;
wd_area = height * width;
[m, n, ~] = size(img0);
img = floor(double(img0)/(2^(8-L)));

% pres = zeros(m+1, n+1, 2^(3*L));
% for i = 2:m+1
%     for j = 2:n+1
%         incode = 1;
%         for c = 1:3
%             incode = incode + img(i-1, j-1, c) * 2^((c-1)*L);
%         end 
%         pres(i, j, incode) = 1;
%         pres(i, j, :) = pres(i-1, j, :) + pres(i, j-1, :) - pres(i-1, j-1, :) + pres(i, j, :);

%     end
% end

diss = ones((m-height)*(n-width), 1);
v1 = sqrt(v);
resol = round(min(m, n) / 100);
for i = 1:resol:m-height
    for j = 1:resol:n-width
        i2 = i+height-1; j2 = j+width-1;
        f = pres(i2+1, j2+1, :)+pres(i, j, :)-pres(i, j2+1, :)-pres(i2+1, j, :);
        f = f / wd_area;
        u1 = reshape(sqrt(f), length(v1), 1);
        rou = sum(u1 .* v1, 1);
        diss((i-1)*(n-width)+j, 1) = 1-rou;
        if (1-rou) < epsilon
            for a = i:i2
                img0(a, j, :) = [255, 0, 0];
                img0(a, j2, :) = [255, 0, 0];
            end
            for b = j:j2
                img0(i, b, :) = [255, 0, 0];
                img0(i2, b, :) = [255, 0, 0];
            end
        end
    end
end

imshow(img0)
