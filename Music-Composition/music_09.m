clear
[x, Fs] = audioread('fmt.wav');
figure(1);
subplot(2, 1, 1);
plot(x);
title('原始波形');

y1 = x .* x;
% subplot(2, 1, 2);
% plot(y1);
% title('幅度平方求能量');

L = 1000;
w = hamming(L);
y2 = fftfilt(w, y1);
% figure(2);
% subplot(2, 1, 1);
% plot(y2);
% title('加窗平滑求包络');

y3 = diff(y2);
% subplot(2, 1, 2);
% plot(y3);
% title('差分提取变化点');

y4 = max(y3, 0);
subplot(2, 1, 2);
plot(y4);

hold on;
% 对所有峰值进行排序
len = length(y4);
width_w = 1000;
i_ = (1:len)';
pair = [i_ y4];
pair_ = sortrows(pair, 2);
pos = pair_(:, 1);

% 使用非极大值抑制算法 NMS 进行节奏点选定
iter_time = fix(len / 4300);
notes = zeros(iter_time, 1);

for i = 1:iter_time
    len = length(pos);
    value = pos(len);
    notes(i) = value;
    pos = pos((pos > value + width_w) | (pos < value - width_w));
end

notes_value = y4(notes);
%subplot(2, 1, 2);
plot(notes, notes_value, 'o');
title('半波整流取正值 + 自动选峰定节奏');
hold off;

% 下面对每一节拍进行FFT，分析音调频率
% 切分每个音符
EPS = 550;
notes = sort(notes);
metre = zeros(12000, length(notes));
metre(1:notes(2) - EPS, 1) = x(1:notes(2) - EPS);

for i = 2:(length(notes) - 1)
    metre(1:notes(i + 1) - notes(i) + 1, i) = x(notes(i) - EPS:notes(i + 1) - EPS);
end

metre(1:length(x) - notes(end) + 1, i + 1) = x(notes(end) - EPS:end - EPS);

for i = length(notes):-1:1
    if i == 1
        LL = notes(2) - EPS;
    elseif i == length(notes)
        LL = length(x) - notes(end);
    else
        LL = notes(i + 1) - notes(i);
    end

    wave = metre(1:LL, i);
    % sound(wave, Fs);
    % pause(2);
    % figure(i);
    % subplot(2, 1, 1);
    % plot(wave);

    % 10次重复
    wave_10times = zeros(LL * 10, 1);

    for j = 1:10
        wave_10times((LL * (j - 1) + 1):LL * j) = wave;
    end

    spec = fft(wave_10times);
    % spec = spec / max(spec);
    mmm = max(spec);
    for a = 1:length(spec)
        if(spec(a) < 0.01*mmm)
            spec(a) = 0;
        end
    end

    P2 = abs(spec / LL / 10);
    P1 = P2(1:fix(LL * 10/2) + 1);
    P1(2:end - 1) = 2 * P1(2:end - 1);
    f = Fs * (0:LL * 10/2) / LL / 10;
    % subplot(2, 1, 2);
    % plot(fix(f), P1);
end
