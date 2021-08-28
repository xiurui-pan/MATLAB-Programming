function category = GetCategory(DCerr)
    if DCerr == 0
        category = 0;
    else
        category = uint8(log2(DCerr)) + 1;
    end
end