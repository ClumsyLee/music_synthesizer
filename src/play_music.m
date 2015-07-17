%% play_music: Play music using a certain generator.
function play_music(generator)
    f_sample = 8e3;
    [t, music] = make_music(generator, f_sample);
    sound(music, f_sample);
