f_sample = 8e3;
[t, music] = make_music(@refined_tone, f_sample);
sound(music, 2 * f_sample);
