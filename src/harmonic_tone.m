%% tone: generate a tone of a certain frequency
function signal = harmonic_tone(t, t_start, duration, f)
    interval = (t >= t_start);

    signal = zeros(size(t));
    signal = sin(2 * pi * f * t) + ...
       0.2 * sin(4 * pi * f * t) + ...
       0.3 * sin(3 * pi * f * t);
    signal = tone_shape(t - t_start, duration) .* signal;
