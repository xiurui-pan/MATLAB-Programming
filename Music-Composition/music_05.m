% 莫扎特k265/300e 小星星变奏曲 第一句

high_do = 440;
high_so = high_do * 2 ^ (7/12);
high_la = high_do * 2 ^ (9/12);
high_fa = high_do * 2 ^ (5/12);
high_mi = high_do * 2 ^ (4/12);
high_re = high_do * 2 ^ (2/12);

Fs = 8000;
x = 0 : 1/Fs : 4.05;

y1 = sin(2*pi*high_do*x) + 0.2*sin(2*2*pi*high_do*x) + 0.05*sin(2*3*pi*high_do*x) + 0.005*sin(2*4*pi*high_do*x);
y2 = sin(2*pi*high_do*(x-0.5)) + 0.2*sin(2*2*pi*high_do*(x-0.5)) + 0.05*sin(2*3*pi*high_do*(x-0.5)) + 0.005*sin(2*4*pi*high_do*(x-0.5));
y3 = sin(2*pi*high_so*(x-1)) + 0.2*sin(2*2*pi*high_so*(x-1)) + 0.05*sin(2*3*pi*high_so*(x-1)) + 0.005*sin(2*4*pi*high_so*(x-1));
y4 = sin(2*pi*high_so*(x-1.5)) + 0.2*sin(2*2*pi*high_so*(x-1.5)) + 0.05*sin(2*3*pi*high_so*(x-1.5)) + 0.005*sin(2*4*pi*high_so*(x-1.5));
y5 = sin(2*pi*high_la*(x-2)) + 0.2*sin(2*2*pi*high_la*(x-2)) + 0.05*sin(2*3*pi*high_la*(x-2)) + 0.005*sin(2*4*pi*high_la*(x-2));
y6 = sin(2*pi*high_la*(x-2.5)) + 0.2*sin(2*2*pi*high_la*(x-2.5)) + 0.05*sin(2*3*pi*high_la*(x-2.5)) + 0.005*sin(2*4*pi*high_la*(x-2.5));
y7 = sin(2*pi*high_so*(x-3)) + 0.2*sin(2*2*pi*high_so*(x-3)) + 0.05*sin(2*3*pi*high_so*(x-3)) + 0.005*sin(2*4*pi*high_so*(x-3));
y8 = sin(2*pi*high_so*(x-3.5)) + 0.2*sin(2*2*pi*high_so*(x-3.5)) + 0.05*sin(2*3*pi*high_so*(x-3.5)) + 0.005*sin(2*4*pi*high_so*(x-3.5));

z1 = y1 .* ((exp(9.1629*x)-1).*(x>=0&x<0.1) + 1.5*exp(-4.05465*(x-0.1)).*(x>=0.1&x<0.2) + 1.*(x>=0.2&x<0.4) + (1.5*exp(-7.3241*(x-0.4))-0.5).*(x>=0.4&x<0.55));
z2 = y2 .* ((exp(9.1629*(x-0.5))-1).*(x>=0.5&x<0.6) + 1.5*exp(-4.05465*(x-0.6)).*(x>=0.6&x<0.7) + 1.*(x>=0.7&x<0.9) + (1.5*exp(-7.3241*(x-0.9))-0.5).*(x>=0.9&x<1.05));
z3 = y3 .* ((exp(9.1629*(x-1))-1).*(x>=1&x<1.1) + 1.5*exp(-4.05465*(x-1.1)).*(x>=1.1&x<1.2) + 1.*(x>=1.2&x<1.4) + (1.5*exp(-7.3241*(x-1.4))-0.5).*(x>=1.4&x<1.55));
z4 = y4 .* ((exp(9.1629*(x-1.5))-1).*(x>=1.5&x<1.6) + 1.5*exp(-4.05465*(x-1.6)).*(x>=1.6&x<1.7) + 1.*(x>=1.7&x<1.9) + (1.5*exp(-7.3241*(x-1.9))-0.5).*(x>=1.9&x<2.05));
z5 = y5 .* ((exp(9.1629*(x-2))-1).*(x>=2&x<2.1) + 1.5*exp(-4.05465*(x-2.1)).*(x>=2.1&x<2.2) + 1.*(x>=2.2&x<2.4) + (1.5*exp(-7.3241*(x-2.4))-0.5).*(x>=2.4&x<2.55));
z6 = y6 .* ((exp(9.1629*(x-2.5))-1).*(x>=2.5&x<2.6) + 1.5*exp(-4.05465*(x-2.6)).*(x>=2.6&x<2.7) + 1.*(x>=2.7&x<2.9) + (1.5*exp(-7.3241*(x-2.9))-0.5).*(x>=2.9&x<3.05));
z7 = y7 .* ((exp(9.1629*(x-3))-1).*(x>=3&x<3.1) + 1.5*exp(-4.05465*(x-3.1)).*(x>=3.1&x<3.2) + 1.*(x>=3.2&x<3.4) + (1.5*exp(-7.3241*(x-3.4))-0.5).*(x>=3.4&x<3.55)); 
z8 = y8 .* ((exp(9.1629*(x-3.5))-1).*(x>=3.5&x<3.6) + 1.5*exp(-4.05465*(x-3.6)).*(x>=3.6&x<3.7) + 1.*(x>=3.7&x<3.9) + (1.5*exp(-7.3241*(x-3.9))-0.5).*(x>=3.9&x<4.05));

z = z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8;
sound(z, Fs);