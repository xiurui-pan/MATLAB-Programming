global timbre;
global notes;
global notes_nums;
global volume;

Fs = 8000;
time = 0;

c = struct("Ab0", ones(1:10), "Ao0", ones(1:10), "Bb0", ones(1:10), "Bo0", ones(1:10), "Co1", ones(1:10), "Db1", ones(1:10), "Do1", ones(1:10), "Eb1", ones(1:10), "Eo1", ones(1:10), "Fo1", ones(1:10), "Gb1", ones(1:10), "Go1", ones(1:10), "Ab1", ones(1:10), "Ao1", ones(1:10), "Bb1", ones(1, 10), "Bo1", ones(1:10), "Co2", ones(1:10), "Db2", ones(1:10), "Do2", ones(1:10), "Eb2", ones(1:10), "Eo2", ones(1:10));

c.("Ab0") = 2 * [0.0310599, 0.00802654, 0.0119795, 0.00994809, 0.0005, 0.00058, 0.0022, 0, 0, 0];
c.("Ao0") = 2.4 * [0.02888, 0.007, 0.0042438, 0.00254, 0.00064, 0.002, 0.00049, 0.00052, 0.00032, 0];
c.("Bb0") = [0.0650462, 0.029072, 0.0069, 0.0074, 0.0008, 0.00661, 0.00413, 0, 0.0012271, 0];
c.("Bo0") = c.("Bb0");
c.("Co1") = 2 * [0.0306495, 0.0140906, 0.005289, 0.001, 0.00436, 0.00126, 0.00356, 0.0003, 0, 0];
c.("Db1") = [0.0545663, 0.0359774, 0.004341, 0.004601, 0.00459, 0.0108072, 0.0014, 0, 0.004, 0.00658];
c.("Do1") = c.("Db1");
c.("Eb1") = 0.9 * [0.03362, 0.029, 0.014, 0.0224, 0.00296, 0.00188, 0.022, 0.005926, 0.00701, 0.001037];
c.("Eo1") = c.("Eb1");
c.("Fo1") = 3 * [0.019235, 0.006, 0.00134, 0.002709, 0.002163, 0.001087, 0.00128, 0, 0, 0];
c.("Gb1") = [0.0580474, 0.0183263, 0.00441, 0.004429, 0.003079, 0.0027766, 0.001, 0, 0, 0];
c.("Go1") = c.("Gb1");
c.("Ab1") = 1.4 * [0.048694, 0.00349, 0.018392, 0.00139, 0.00215, 0.00148, 0, 0, 0, 0];
c.("Ao1") = c.("Ab1");
c.("Bb1") = c.("Ao1");
c.("Bo1") = c.("Ao1");
c.("Co2") = c.("Bo1");
c.("Db2") = c.("Co2");
c.("Do2") = c.("Db2");
c.("Eb2") = c.("Do2");
c.("Eo2") = c.("Eb2");


for i = 1:notes_nums
    time = time + B2T(notes(i).beat);
end
x = 0:1 / Fs:time + 1;
t_now = 0;
for i = 1:notes_nums
    t = B2T(notes(i).beat);
    if notes(i).pitch == "000"
        t_now = t_now + t;
        continue;
    end 
    z = zeros(1, length(x));
    for j = 1:10
        z = z + c.(notes(i).pitch)(j) * sin(2*pi*j*(x-t_now) * P2F(notes(i).pitch));
    end
    if i == 1
        y = z .* Envlp(timbre, 0, t, x);
    else
        y = y + z .* Envlp(timbre, t_now, t, x);
    end
    t_now = t_now + t;
    audiowrite('music.wav', volume * y, Fs);
end

sound(volume * y, Fs);
plot(volume * y);

function env = Envlp(texture, delay, held, x)
    switch texture
    case 1
        env = (x-delay) .^ (1/15) ./ exp((2/held)*(x-delay)) .* (x >= delay);
    case 2
        env = (exp(9.1629*0.5/held * (x-delay))-1).*(x>=delay & x<delay+held/5) + 1.5*exp(-4.05465*0.5/held * (x-delay-held/5)).*(x>=delay+held/5 & x<delay+held/5*2) + 1.*(x>=delay+held/5*2 & x<delay+held/5*4) + (1.5*exp(-7.3241*0.5/held * (x-delay-held/5*4))-0.5).*(x>=delay+held/5*4 & x<delay+max(held/5*6, 0.05));
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
        case 'Bo1'
            freq = 493.88;
        case 'Co2'
            freq = 523.25;
        case 'Db2'
            freq = 554.36;
        case 'Do2'
            freq = 587.33;
        case 'Eb2'
            freq = 622.25;
        case 'Eo2'
            freq = 659.25;
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
        otherwise
            t = 0.5;
    end
end
