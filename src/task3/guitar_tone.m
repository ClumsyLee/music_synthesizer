%% guiter_tone: generate a guitar tone of a certain frequency
function signal = guitar_tone(t, t_start, duration, f)
    interval = (t >= t_start);

    wave = [1.0000, 1.4572, 0.9587, 1.0999] * sin(2 * pi * f * [1:4]' * t);
    signal = guitar_tone_shape(t - t_start, duration) .* wave;
