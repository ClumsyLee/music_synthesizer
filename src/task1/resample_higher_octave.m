f_sample = 8e3;
[Q, P] = rat(2^(1/12), 0.0000001);  % Find the rational approximation.
[t, music] = make_music(@refined_tone, f_sample);
sound(resample(music, P, Q), f_sample);
