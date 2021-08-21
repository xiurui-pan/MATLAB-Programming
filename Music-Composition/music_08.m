% 先运行 music_07.m，因为使用了处理后的 wave 变量

% 首先尝试 直接对整个波形使用FFT来求傅里叶变换，这相当于近似10个周期
spec = fft(wave);
P2 = abs(spec / 243);
P1 = P2(1:fix(243/2)+1);
P1(2:end-1) = 2 * P1(2:end-1);
f = Fs*(0:243/2)/243;

% 再尝试将信号重复10次后使用FFT求傅里叶变换，这相当于近似100个周期
wave_10times = zeros(2430, 1);
for i = 1:10
    wave_10times((243*(i-1)+1):243*i) = wave;
end
spce_10x = fft(wave_10times);
P4 = abs(spce_10x / 2430);
P3 = P4(1:2430/2+1);
P3(2:end-1) = 2 * P3(2:end-1);
f_10x = Fs*10*(0:2430/2)/24300;

figure(8);
subplot(2, 1, 1), box on, hold on;
plot(fix(f), P1);
title("spectrum of original wave");

subplot(2, 1, 2), box on, hold on;
plot(f_10x, P3);
title("spectrum of 10x-repeated wave");


% plot(fix(f), P1);