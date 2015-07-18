%% refined_tone: Generate a tone of a certain frequency with refined shape
function signal = refined_tone(t, t_start, duration, f)
    interval = (t >= t_start);

    signal = zeros(size(t));
    signal = tone_shape(t - t_start, duration) .* sin(2 * pi * f * t);
