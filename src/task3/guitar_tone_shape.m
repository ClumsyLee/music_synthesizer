%% tone_shape: Volumn at a certain time point.
function amp = tone_shape(t, duration)
    % Parameters.
    impulse_ratio = 0.01;
    decay_ratio = 0.1;
    stay_ratio = 0.1;
    peak_amp = 1;
    stay_amp = 0.5;
    fade_coefficient = 2.5;

    impulse_end = impulse_ratio * duration;
    decay_end = impulse_end + decay_ratio * duration;
    stay_end = decay_end + stay_ratio * duration;

    % Stages.
    impulse = (t >= 0 & t < impulse_end);
    decay = (t >= impulse_end & t < decay_end);
    stay = (t >= decay_end & t < stay_end);
    fade = (t >= stay_end);

    amp = zeros(size(t));
    amp(t < 0) = 0;
    amp(impulse) = linspace(0, peak_amp, sum(impulse));
    amp(decay) = linspace(peak_amp, stay_amp, sum(decay));
    amp(stay) = stay_amp;
    amp(fade) = stay_amp * exp(fade_coefficient * ...
                               (stay_end - t(fade)) / duration);
