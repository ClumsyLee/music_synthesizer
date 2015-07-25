%% refined_guitar_tone: generate a refined guitar tone of a certain frequency
function signal = refined_guitar_tone(t, t_start, duration, f)
    interval = (t >= t_start);

    load guitar
    [value, index] = min(abs(baseband - f));  % Find the closest tone.

    wave = band_wights(index, :) * sin(2 * pi * f * [1:4]' * t);
    signal = guitar_tone_shape(t - t_start, duration) .* wave;
