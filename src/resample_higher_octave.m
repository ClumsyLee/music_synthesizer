f_sample = 8e3;
[t, music] = make_music(@refined_tone, f_sample);
sound(resample(music, 70, 99), f_sample);  % sqr(2) ~= 99 / 70
