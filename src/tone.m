%% tone: generate a tone of a certain frequency
function signal = tone(t, t_start, duration, f)
    interval = (t >= t_start & t < t_start + duration);

    signal = zeros(size(t));
    signal(interval) = sin(2 * pi * f * t(interval));
