clear
load('hall.mat');
load('JpegCoeff.mat');
img = double(hall_gray);

[m, n] = size(img);
DCT = zeros(64, m*n/64);
for i = 1:m/8
    for j = 1:n/8
        block = img((i-1)*8+1:i*8, (j-1)*8+1:j*8);
        block = dct2(block - 128);
        block = round(block ./ QTAB);
        vec = image2_7(block); % 自己编写的zigzag函数
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
    j = 1;
    while j <= 63
        cnt_zero = 0;
        ZRL_size = 0;
        while AC(j) == 0
            if j == 63
                ACcode = cat(2, ACcode, EOB);
                break;
            end
            j = j + 1;
            cnt_zero = cnt_zero + 1;
            if cnt_zero == 16
                ZRL_size = ZRL_size + 1;
                cnt_zero = 0;
            end
        end
        if j == 63
            break;
        end
        for k = 1:ZRL_size
            ACcode = cat(2, ACcode, ZRL);
        end
        Run = cnt_zero;
        Size = image2_6(AC(j));
        
        len = ACTAB(Run*10+Size, 3);
        huffman = ACTAB(Run*10+Size, 4:len+3);
        if AC(j) >= 0
            Amplitude = dec2bin(AC(j)) - '0';
        else
            Amplitude = ~(dec2bin(abs(AC(j)))-'0');
        end
        ACcode = cat(2, ACcode, huffman, Amplitude);
        if j == 63
            ACcode = cat(2, ACcode, EOB);
        end
        j = j + 1;
    end
end

height = 120;
width = 168;

save('jpegcodes.mat', 'DCcode', 'ACcode', 'height', 'width');
