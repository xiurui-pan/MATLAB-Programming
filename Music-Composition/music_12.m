global timbre;
global notes;
global notes_nums;
global volume;

Fs = 8000;
time = 0;

disp(notes_nums);

for i = 1:notes_nums
    time = time + B2T(notes(i).beat);
end

x = 0:1 / Fs:time + 1;

t_now = 0;

for i = 1:notes_nums
    t = B2T(notes(i).beat);
    if i == 1   
        y = sin(2*pi*x * P2F(notes(i).pitch)) .* Envlp(1, 0, t, x);
    else
        y = y + sin(2*pi*(x-t_now) * P2F(notes(i).pitch)) .* Envlp(1, t_now, t, x);
    end
    t_now = t_now + t;
end
volume = 1;

sound(volume * y, Fs);
plot(volume * y);

function env = Envlp(txt, delay, held, x)
    switch txt
    case 1
        env = (x-delay) .^ (1/15) ./ exp(4*(x-delay)) .* (x >= delay);
    case 2
        
    end
end

function freq = P2F(pitch)

    switch pitch

        case 'Ab0'
            freq = 207.65;
        case 'Ao0'
            freq = 220;
        case 'Bb0'
            freq = 233.08;
        case 'Bo0'
            freq = 246.94;
        case 'Co1'
            freq = 261.63;
        case 'Db1'
            freq = 277.18;
        case 'Do1'
            freq = 293.66;
        case 'Eb1'
            freq = 311.13;
        case 'Eo1'
            freq = 329.63;
        case 'Fo1'
            freq = 349.23;
        case 'Gb1'
            freq = 369.99;
        case 'Go1'
            freq = 392;
        case 'Ab1'
            freq = 415.3;
        case 'Ao1'
            freq = 440;
        case 'Bb1'
            freq = 466.16;
        case 'Co2'
            freq = 523.25;
        case 'Db2'
            freq = 554.36;
    end

end

function t = B2T(beat)

    switch beat
        case 1
            t = 2;
        case 2
            t = 1;
        case 4
            t = 0.5;
        case 8
            t = 0.25;
        case 16
            t = 0.125;
        otherwise
            t = 0.5;
    end
end
