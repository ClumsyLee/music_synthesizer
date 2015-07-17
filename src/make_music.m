%% make_music: Use certain tone generator to make music.
function music = make_music(generator, f_sample)
    beat = 0.5;
    t_total = 5;
    f = [349.23, 392, 440, 466.16, 523.25, 587.33, 659.25, 698.46];

    t = linspace(0, t_total, t_total * f_sample);

    tones = [f(5), f(5), f(6), f(2), f(1), f(1), f(6) / 2, f(2)];
    beats = [1, 0.5, 0.5, 2, 1, 0.5, 0.5, 2];

    t_now = 0;
    music = zeros(size(t));
    for tone_num = 1:8
        duration = beats(tone_num) * beat;
        music = music + generator(t, t_now, duration, tones(tone_num));
        t_now = t_now + duration;
    end
