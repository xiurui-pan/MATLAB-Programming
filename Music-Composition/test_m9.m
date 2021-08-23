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
figure(3);
plot(y4);
title('半波整流取正值 + 自动选峰定节奏');

hold on;
% 对所有峰值进行排序
len = length(y4);
width_w = 1000;
i_ = (1 : len)';
pair = [i_ y4];
pair_ = sortrows(pair, 2);
pos = pair_(:, 1);

% 使用非极大值抑制算法 NMS 进行节奏点选定
iter_time = fix(len/4300);
notes = zeros(iter_time, 1);
for i = 1:iter_time
    len = length(pos);
    value = pos(len);
    notes(i) = value;
    pos = pos((pos > value+width_w)|(pos < value-width_w));
end

notes_value = y4(notes);
plot(notes, notes_value, 'o');
hold off;

% 下面对每一节拍进行FFT，分析音调频率
% 切分每个音符
EPS = 700;
notes = sort(notes);
metre = zeros(12000, length(notes));
metre(1:notes(2)-EPS, 1) = x(1:notes(2)-EPS);
for i = 2:(length(notes)-1)
    metre(1:notes(i+1)-notes(i)+1, i) = x(notes(i)-EPS:notes(i+1)-EPS);
end
metre(1:length(x)-notes(end)+1, i+1) = x(notes(end)-EPS:end-EPS);

LL = notes(6) - notes(5);
wave = metre(1:LL, 5);


% % 10次重复
% wave_10times = zeros(LL*100, 1);
% for i = 1:100
%     wave_10times((LL*(i-1)+1):LL*i) = wave;
% end

% wave = wave_10times;
[m, n] = size(wave);
n = 0:m-1;
n = n * 8000 / m;
wave = abs(fft(wave));
wave = wave / max(wave);
for a = 1:m
    if wave(a) < 0.3
        wave(a) = 0;
    end
end
figure(4);
plot(wave);