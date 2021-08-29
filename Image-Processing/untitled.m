clear all;
load('JpegCoeff.mat');
load('hall.mat');
hall_gray = double(hall_gray);

x = 15;
y = 21;
a = zeros(64,x*y);  % 120*168��ͼ�񹲷�Ϊ15*21��

for i = 1:x
    for j = 1:y
        block = hall_gray(8*i-7:8*i, 8*j-7:8*j);
        block = dct2(double(block)-128);
        block = round(block./QTAB);
        block = zigzag(block);
        a(:, y*(i-1)+j) = block;
    end
end

% DC����
DC = zeros(1,x*y);
DC(1) = a(1,1);
for i = 2:x*y
    DC(i) = a(1,i-1) - a(1,i);
end
DCcode=[];
for i = 1:x*y
    Category = ceil(log2(abs(DC(i))+1));
    length = DCTAB(Category+1,1);
    Huffman = DCTAB(Category+1,2:length+1); % ���
    if DC(i) < 0
        Magnitude = ~(dec2bin(abs(DC(i)))-48);
    else
        Magnitude = dec2bin(DC(i))-48;
    end
    DCcode = cat(2,DCcode,Huffman,Magnitude);
end

% AC����
ZRL = [1,1,1,1,1,1,1,1,0,0,1];
EOB = [1,0,1,0];
ACcode=[];
for i = 1:x*y
    AC = a(2:64,i);
    Run = 0;
    ZRL_buf = 0; % ��¼���㣬������һ������ϵ��ʱ��д��
    for j = 1:63
        if AC(j) ~= 0
            for n = 1:ZRL_buf
                ACcode = cat(2,ACcode,ZRL);
            end
            ZRL_buf = 0;
            Size = ceil(log2(abs(AC(j))+1));
            length = ACTAB(Run*10+Size,3);
            Huffman = ACTAB(Run*10+Size,4:length+3); % ���
            if AC(j) < 0
                Amplitude = ~(dec2bin(abs(AC(j)))-48);
            else
                Amplitude = dec2bin(AC(j))-48;
            end
            ACcode = cat(2,ACcode,Huffman,Amplitude);
            Run = 0;
        else
            if Run < 15
                Run = Run + 1;
            else
                ZRL_buf = ZRL_buf + 1;
                Run = 0;
            end
        end
    end
    ACcode = cat(2,ACcode,EOB);
end

height = 120;
width = 168;
save('jpegcodes.mat','DCcode','ACcode','height','width');
