clear
load('jpegcodes.mat');
load('JpegCoeff.mat');
load('hall.mat');

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
    if (i < AClen - 10) & (ACcode(i:i+10) == ZRL)
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

recover = zeros(height, width);
for i = 1:height/8
    for j = 1:width/8
        block = izigzag(DCT(:, width/8*(i-1)+j));
        block = block .* QTAB;
        block = idct2(block) + 128;
        recover((i-1)*8+1:i*8, (j-1)*8+1:j*8) = block;
    end
end
recover = uint8(recover);
imshow(recover);

err = double(hall_gray) - double(recover);
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

