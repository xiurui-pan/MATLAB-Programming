function category = GetCategory(DCerr)
    if DCerr == 0
        category = 0;
    else
        category = floor(log2(abs(DCerr))) + 1;
    end
end