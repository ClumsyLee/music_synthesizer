beat = 0.5;
f = [349.23, 392, 440, 466.16, 523.25, 587.33, 659.25, 698.46];

music = [tone(f(5), beat), tone(f(5), 0.5*beat), tone(f(6), 0.5*beat), tone(f(2), 2*beat), tone(f(1), beat), tone(f(1), 0.5*beat), tone(f(6)/2, 0.5*beat), tone(f(2), 2*beat)];
sound(music)
