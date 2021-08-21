F_major = 349.23;
so = F_major * 2 ^ (7/12);
ra = F_major * 2 ^ (9/12);
re = F_major * 2 ^ (2/12);
do = F_major;
down_ra = F_major * 2 ^ (-3/12);
Fs = 8000;
x = 0 : 1/Fs : 4; % 4小节，每小节8拍，每拍0.5s

y1 = sin(2*pi*so*x).*(x>=0&x<0.5) + sin(2*pi*so*x).*(x>=0.51&x<0.75) + sin(2*pi*ra*x).*(x>=0.75&x<1);
y2 = sin(2*pi*re*x).*(x>=1.01&x<2);
y3 = sin(2*pi*do*x).*(x>=2.01&x<2.5) + sin(2*pi*do*x).*(x>=2.51&x<2.75) + sin(2*pi*down_ra*x).*(x>=2.75&x<3);
y4 = sin(2*pi*re*x).*(x>=3.01&x<4);

y = y1 + y2 + y3 + y4;
sound(y, Fs);
