clear
[x, Fs] = audioread('fmt.wav');
figure(1);
subplot(2, 1, 1);
plot(x);
title('原始波形');

y1 = x .* x;
subplot(2, 1, 2);
plot(y1);
title('幅度平方求能量');

L = 1000;
w = hamming(L);
y2 = fftfilt(w, y1);
figure(2);
subplot(2, 1, 1);
plot(y2);
title('加窗平滑求包络');

y3 = diff(y2);
subplot(2, 1, 2);
plot(y3);
title('差分提取变化点');

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
