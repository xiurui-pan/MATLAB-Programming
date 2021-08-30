ACcode = [];
ZRL = [1 1 1 1 1 1 1 1 0 0 1];
EOB = [1 0 1 0];
for i = 1:length(diff_coding)
    AC = DCT(2:64, i);
    cnt_zero = 0;
    ZRL_size = 0;
    for j = 1:63
        if AC(j) ~= 0
            for n = 1:ZRL_size
                ACcode = cat(2, ACcode, ZRL);
            end
            ZRL_size = 0;
            Size = image2_6(AC(j));
            Run = cnt_zero;
            huff_len = ACTAB(Run*10+Size, 3);
            huffman = ACTAB(Run*10+Size, 4:huff_len+3);
            if AC(j) >= 0
                Amplitude = dec2bin(AC(j)) - '0';
            else
                Amplitude = ~(dec2bin(abs(AC(j)))-'0');
            end
            ACcode = cat(2, ACcode, huffman, Amplitude);
            cnt_zero = 0;
        else
            if cnt_zero < 15
                cnt_zero = cnt_zero + 1;
            else
                ZRL_size = ZRL_size + 1;
                cnt_zero = 0;
            end
        end
    end
    ACcode = cat(2, ACcode, EOB);
end