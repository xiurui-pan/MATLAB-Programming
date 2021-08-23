w = dir('*.wav'); %建立wav文件表
sec = zeros(29, 1);
fre = zeros(29, 5);

for i = 1:29
    wave = wavread(w(i).name); %读取文件
    y = wave;
    [m, n] = size(wave);

    if m <= 2400
        sec(i, 1) = 8; %八分音符
    elseif m <= 4800
        sec(i, 1) = 4; %四分音符
    elseif m <= 8000
        sec(i, 1) = 2; %二分音符
    elseif m > 8000
        sec(i, 1) = 1; %整音符
    end

    for m = 1:199
        wave = [wave; y]; %200倍扩展
    end

    [m, n] = size(wave); %获得长度信息
    n = 0:m - 1;
    n = n * 8000 / m; %获得变换后横坐标信息
    wave = fft(wave); %快速傅里叶变换
    wave = abs(wave);
    wave = wave / max(wave); %归一化

    for a = 1:m

        if wave(a) < 0.3 %阀值量化
            wave(a) = 0;
        end

    end

    j = 1;

    for a = 1:ceil(m / 2)

        if wave(a) ~= 0
            fre(i, j) = a * 8000 / m; %寻找分量
            j = j + 1;
            b = a * 8000 / m;
            b = ceil(b * 1.05); %避免全读入一个密集处
            a = ceil(b * m / 8000);
        end

        if j == 6
            break
        end

    end

    figure(i);
    plot(n, wave); %绘图
end

sec
fre
