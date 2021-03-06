% clear
load('v.mat');
% load('pre_img4_2.mat');
img0 = imread('faces.bmp');
epsilon = 0.62;

height = 30; width = 20;
wd_area = height * width;
[m, n, ~] = size(img0);
img = floor(double(img0)/(2^(8-L)));

diss = ones((m-height)*(n-width), 1);
v1 = sqrt(v);
resol = round(min(m, n) / 100);
nums = 0;
MAXNUM = 100;
x1 = zeros(MAXNUM, 1);
x2 = zeros(MAXNUM, 1);
y1 = zeros(MAXNUM, 1);
y2 = zeros(MAXNUM, 1);
s = zeros(MAXNUM, 1);
for i = 1:resol:m-height
    for j = 1:resol:n-width
        i2 = i+height-1; j2 = j+width-1;
        f = pres(i2+1, j2+1, :)+pres(i, j, :)-pres(i, j2+1, :)-pres(i2+1, j, :);
        f = double(f) / wd_area;
        u1 = reshape(sqrt(f), length(v1), 1);
        rou = sum(u1 .* v1, 1);
        diss((i-1)*(n-width)+j, 1) = 1-rou;
        if (1-rou) < epsilon
            nums = nums + 1;
            x1(nums) = i;
            y1(nums) = j;
            x2(nums) = i2;
            y2(nums) = j2;
            s(nums) = 1-rou;
        end
    end
end

[vals, I] = sort(s);
pick = s*0;
counter = 1;
threshold = 0.001;
while ~isempty(I)
    last = length(I); %当前剩余框的数量
    i = I(last);%选中最后一个，即得分最高的框
    pick(counter) = i;
    counter = counter + 1;  

    %计算相交面积
    xx1 = max(x1(i), x1(I(1:last-1)));
    yy1 = max(y1(i), y1(I(1:last-1)));
    xx2 = min(x2(i), x2(I(1:last-1)));
    yy2 = min(y2(i), y2(I(1:last-1)));  
    w = max(0.0, xx2-xx1+1);
    h = max(0.0, yy2-yy1+1); 
    inter = w.*h;
    o = inter ./ wd_area;
    I = I(o<=threshold);
end
pick = pick(1:(counter-1));
for i = 1:length(pick)
    for a = x1(pick(i)):x2(pick(i))
        if a == 0
            break;
        end
        img0(a, y1(pick(i)), :) = [255, 0, 0];
        img0(a, y2(pick(i)), :) = [255, 0, 0];
    end
    for b = y1(pick(i)):y2(pick(i))
        if b == 0 
            break
        end
        img0(x1(pick(i)), b, :) = [255, 0, 0];
        img0(x2(pick(i)), b, :) = [255, 0, 0];
    end 
end

imshow(img0)
