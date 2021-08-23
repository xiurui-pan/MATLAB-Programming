clear
F_major = 349.23;
so = F_major * 2 ^ (7/12);
ra = F_major * 2 ^ (9/12);
re = F_major * 2 ^ (2/12);
do = F_major;
down_ra = F_major * 2 ^ (-3/12);
Fs = 8000;
x = 0 : 1/Fs : 4.05; % 4小节，每小节8拍，每拍0.5s

K = 3;
coeff = zeros(10, 8);
% do
coeff(1, 1) = 0.042732 * K;
coeff(2, 1) = 0.00636 * K;
coeff(3, 1) = 0.001196 * K;
coeff(4, 1) = 0.0046037 * K;
coeff(5, 1) = 0.00189706 * K;
coeff(6, 1) = 0.000892 * K;
coeff(7, 1) = 0.000773 * K;

z = zeros(8, length(x));

for i = 1 : 10
    z(1, :) = z(1, :) + coeff(i, 1) * sin(2*i*pi*so*x);
    z(2, :) = z(2, :) + coeff(i, 1) * sin(2*i*pi*so*(x-0.5));
    z(3, :) = z(3, :) + coeff(i, 1) * sin(2*i*pi*ra*(x-0.75));
    z(4, :) = z(4, :) + coeff(i, 1) * sin(2*i*pi*re*(x-1));
    z(5, :) = z(5, :) + coeff(i, 1) * sin(2*i*pi*do*(x-2));
    z(6, :) = z(6, :) + coeff(i, 1) * sin(2*i*pi*do*(x-2.5));
    z(7, :) = z(7, :) + coeff(i, 1) * sin(2*i*pi*down_ra*(x-2.75));
    z(8, :) = z(8, :) + coeff(i, 1) * sin(2*i*pi*re*(x-3));
end

y1 = z(1, :) .* (x.^(1/15)./exp(4*x));
y2 = z(2, :) .* ((x-0.5).^(1/15)./exp(4*(x-0.5))) .* (x >= 0.5);
y3 = z(3, :) .* ((x-0.75).^(1/15)./exp(4*(x-0.75))) .* (x >= 0.75);
y4 = z(4, :) .* ((x-1).^(1/15)./exp(4*(x-1))) .* (x >= 1); 
y5 = z(5, :) .* ((x-2).^(1/15)./exp(4*(x-2))) .* (x >= 2);
y6 = z(6, :) .* ((x-2.5).^(1/15)./exp(4*(x-2.5))) .* (x >= 2.5);
y7 = z(7, :) .* ((x-2.75).^(1/15)./exp(4*(x-2.75))) .* (x >= 2.75);
y8 = z(8, :) .* ((x-3).^(1/15)./exp(4*(x-3))) .* (x >= 3); 

y = y1 + y2 + y3 + y4 + y5 + y6 + y7 + y8;
sound(y, Fs);
plot(y);