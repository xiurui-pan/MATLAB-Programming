clear all;
load('Guitar.MAT');
wave1=wave2proc;%不扩展
wave10=wave2proc;
wave20=wave2proc;
wave100=wave2proc;
for m=1:9%扩展10倍
wave10=[wave10;wave2proc];
end
for m=1:19%扩展20倍
wave20=[wave20;wave2proc];
end
for m=1:99%扩展100倍
wave100=[wave100;wave2proc];
end
w1=0:242;
w1=w1*8000/243;%计算频点
w10=0:2429;
w10=w10*8000/2430;%计算频点
w20=0:4859;
w20=w20*8000/4860;%计算频点
w100=0:24299;
w100=w100*8000/24300;%计算频点
f1=fft(wave1);%快速傅里叶变换
f1=abs(f1);
f1=f1/max(f1);%归一化
figure(1),plot(w1,f1);%绘图
f10=fft(wave10);%快速傅里叶变换
f10=abs(f10);
f10=f10/max(f10);%归一化
figure(2),plot(w10,f10);%绘图
f20=fft(wave20);%快速傅里叶变换
f20=abs(f20);
f20=f20/max(f20);%归一化
figure(3),plot(w20,f20);%绘图
f100=fft(wave100);%快速傅里叶变换
f100=abs(f100);
f100=f100/max(f100);%归一化
figure(4),plot(w100,f100);%绘图