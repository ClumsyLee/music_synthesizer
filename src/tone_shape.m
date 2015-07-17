%% tone_shape: Volumn at a certain time point.
function amp = tone_shape(t, duration)
    % Parameters.
    t_impulse = 0.1;
    t_decay = 0.06;
    t_stay = 0.5 * duration;
    peak_amp = 1;
    stay_amp = 0.8;
    fade_coefficient = 20;

    impulse_end = t_impulse;
    decay_end = impulse_end + t_decay;
    stay_end = decay_end + t_stay;

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
    amp(fade) = stay_amp * exp(fade_coefficient * (stay_end - t(fade)));
