clear
img = load('hall.mat'); 
p = double(img.hall_gray(1:100, 1:100));
ans1 = DCT2(p);
ans2 = dct2(p);

function C = DCT2(P)

    [~, N] = size(P);
    D = zeros(N, N);
    D(1, :) = 1/sqrt(2);
    for i = 1:N-1
        for j = 0:N-1
            D(i+1, j+1) = cos((2*j+1)*i*pi/(2*N));
        end
    end
    C = 2/N * D * P * D.';

end