clear
load('Guitar.MAT')
Fs = 8000;
x = 0 : 1/Fs : 1/Fs*242;
x_ = 0 : 1/Fs/10 : 1/Fs/10*2429;

% 观察得到共有10个周期，因此拟在时域上对每个周期求平均来消噪
% 由于243不是10的倍数，因此使用resample进行10倍采样

wave_10x = resample(realwave, 10, 1);
wave_processed = zeros(243, 1);
for i = 1:10
    wave_processed = wave_processed + wave_10x((243*(i-1)+1):243*i);
end
wave_processed = wave_processed / 10;
for i = 1:10
    wave_10x((243*(i-1)+1):243*i) = wave_processed;
end
wave = resample(wave_10x, 1, 10);

figure(7);
subplot(3, 1, 1), box on, hold on;
plot(x, wave2proc);
title("wave2proc");

subplot(3, 1, 2), box on, hold on;
plot(x, realwave);
title("realwave");

subplot(3, 1, 3), box on, hold on;
plot(x, wave);
title("processed wave");