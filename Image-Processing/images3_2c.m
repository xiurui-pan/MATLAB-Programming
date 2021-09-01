clear
load('hall.mat');
load('JpegCoeff.mat');
img = double(hall_gray);
msg = dec2bin('xinhaoyuxitonghenyouqu');
[m0, n0] = size(msg);
[m, n] = size(img);
DCT = zeros(64, m*n/64);

for i = 1:m/8
    for j = 1:n/8
        block = img((i-1)*8+1:i*8, (j-1)*8+1:j*8);
        block = dct2(double(block) - 128);
        block = round(block ./ QTAB);
        img((i-1)*8+1:i*8, (j-1)*8+1:j*8) = block;
    end
end

% zigzag扫描
for i = 1:m/8
    for j = 1:n/8
        vec = image2_7(img((i-1)*8+1:i*8, (j-1)*8+1:j*8)); % 自己编写的zigzag函数
        % 信息嵌入
        x = mod(ceil(((i-1)*n/8+j)/n0), m0);
        if x == 0
            x = m0;
        end
        y = mod((i-1)*n/8+j, n0);
        if y == 0
            y = n0;
        end
        if msg(x, y) == '0'
            hid = -1;
        else
            hid = 1;
        end
        stamp = 0;
        for k = 1:length(vec)
            if vec(k) ~= 0
                stamp = k;
            end
        end
        if stamp == length(vec)
            vec(end) = hid;
        else
            vec(stamp+1) = hid;  
        end
        DCT(:, (i-1)*n/8+j) = vec;
    end
end

DCcode = [];

diff_coding = zeros(1, m*n/64);
diff_coding(1) = DCT(1, 1);
diff_coding(2:end) = DCT(1, 1:end-1) - DCT(1, 2:end);
for i = 1:length(diff_coding)
    cate = image2_6(diff_coding(i)); % 自己实现的category映射
    len = DCTAB(cate+1, 1);
    huffman = DCTAB(cate+1, 2:len+1);
    if diff_coding(i) >= 0
        magn = dec2bin(diff_coding(i)) - '0';
    else
        magn = ~(dec2bin(abs(diff_coding(i)))-'0');
    end
    DCcode = cat(2, DCcode, huffman, magn);
end

ACcode = [];
ZRL = [1 1 1 1 1 1 1 1 0 0 1];
EOB = [1 0 1 0];
for i = 1:length(diff_coding)
    AC = DCT(2:64, i);
    cnt_zero = 0;
    ZRL_size = 0;
    for j = 1:63
        if AC(j) ~= 0
            for n = 1:ZRL_size
                ACcode = cat(2, ACcode, ZRL);
            end
            ZRL_size = 0;
            Size = image2_6(AC(j));
            Run = cnt_zero;
            huff_len = ACTAB(Run*10+Size, 3);
            huffman = ACTAB(Run*10+Size, 4:huff_len+3);
            if AC(j) >= 0
                Amplitude = dec2bin(AC(j)) - '0';
            else
                Amplitude = ~(dec2bin(abs(AC(j)))-'0');
            end
            ACcode = cat(2, ACcode, huffman, Amplitude);
            cnt_zero = 0;
        else
            if cnt_zero < 15
                cnt_zero = cnt_zero + 1;
            else
                ZRL_size = ZRL_size + 1;
                cnt_zero = 0;
            end
        end
    end
    ACcode = cat(2, ACcode, EOB);
end

height = 120;
width = 168;

DCT = zeros(64, height*width/64);
DClen = length(DCcode);
DC = zeros(1, height*width/64);
i = 1; % DC编码的迭代器
j = 1; % 解码后位置
while i < DClen
    for k = 1 : 12
        huff_len = DCTAB(k, 1);
        if DCcode(i:i+huff_len-1) == DCTAB(k, 2:1+huff_len)
            huffman = DCcode(i:i+huff_len-1);
            i = i + huff_len;
            break;
        end
    end
    magn_len = k - 1;
    if magn_len == 0
        DC(j) = 0;
        j = j + 1;
        i = i + 1;
        continue;
    end
    magn = DCcode(i:i+magn_len-1);
    i = i + magn_len;
    neg = 0;
    if magn(1) == 0
        magn = ~magn;
        neg = 1;
    end
    magn = char(magn + '0');
    magn = bin2dec(magn);
    if neg == 1
        magn = -1 * magn;
    end
    DC(j) = magn;
    j = j + 1;
end
DCT(1, 1) = DC(1);
for i = 2:height*width/64
    DCT(1, i) = DCT(1, i-1) - DC(i);
end

ZRL = [1 1 1 1 1 1 1 1 0 0 1];
EOB = [1 0 1 0];
AC = zeros(63,height*width/64);
AClen = length(ACcode);
i = 1; % AC编码的迭代器
j = 1; % 解码后的块号
k = 1; % 在块中的位置
while i <= AClen
    if (i <= AClen - 3) & (ACcode(i:i+3) == EOB)
        j = j + 1;
        i = i + 4;
        k = 1;
        continue;
    end
    if (i <= AClen - 10) & (ACcode(i:i+10) == ZRL)
        AC(k:k+15, j) = zeros(16, 1);
        k = k + 16;
        i = i + 11;
        continue;
    end
    for m = 1:160
        huff_len = ACTAB(m, 3);
        if i+huff_len >= AClen
            continue;
        end
        if ACcode(i:i+huff_len-1) == ACTAB(m, 4:3+huff_len)
            Run = ACTAB(m, 1);
            Size = ACTAB(m, 2);
            i = i + huff_len;
            break;
        end
    end
    Amplitude = ACcode(i:i+Size-1);
    neg = 0;
    if Amplitude(1) == 0
        neg = 1;
        Amplitude = ~Amplitude;
    end
    Amplitude = char(Amplitude + '0');
    Amplitude = bin2dec(Amplitude);
    if neg
        Amplitude = -1*Amplitude; 
    end
    i = i + Size;
    AC(k:k+Run-1, j) = zeros(Run, 1);
    AC(k+Run, j) = Amplitude;
    k = k + Run + 1;
    
end
DCT(2:64, :) = AC;  

msg_decoded = zeros(m0, n0);
m00 = 1; n00 = 1;
recover = zeros(height, width);
for i = 1:height/8
    for j = 1:width/8
        vec = DCT(:, width/8*(i-1)+j);
        % 信息提取
        stamp = 0;
        for k = 1:length(vec)
            if vec(k) ~= 0
                stamp = k;
            end
        end
        msg_decoded(m00, n00) = (vec(stamp)+1) / 2;
        vec(stamp) = 0;
        n00 = n00 + 1;
        if n00 == n0 + 1
            n00 = 1;
            m00 = m00 + 1;
        end
        if m00 == m0 + 1
            m00 = 1;
        end
        block = izigzag(vec);
        recover((i-1)*8+1:i*8, (j-1)*8+1:j*8) = block;
    end
end
msg_decoded = char(bin2dec(char(msg_decoded+'0')))

for i = 1:height/8
    for j = 1:width/8
        block = recover((i-1)*8+1:i*8, (j-1)*8+1:j*8);
        block = block .* QTAB;
        block = idct2(block) + 128;
        recover((i-1)*8+1:i*8, (j-1)*8+1:j*8) = block;
    end
end

recover = uint8(recover);
imshow(recover);

err = double(img) - double(recover);
MSE = mean(mean(err .* err));
PSNR = 10 * log10(255 * 255 / MSE)

function [b] = izigzag(a)
    ord = [1,2,6,7,15,16,28,29;
        3,5,8,14,17,27,30,43;
        4,9,13,18,26,31,42,44;
        10,12,19,25,32,41,45,54;
        11,20,24,33,40,46,53,55;
        21,23,34,39,47,52,56,61;
        22,35,38,48,51,57,60,62;
        36,37,49,50,58,59,63,64];

    a = reshape(a,8,8);
    b = a(ord);
end

