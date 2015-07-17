%% play_music: Play music using a certain generator.
function play_music(generator)
    f_sample = 8e3;
    sound(make_music(generator, f_sample), f_sample);
