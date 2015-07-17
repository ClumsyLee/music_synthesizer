%% tone: generate a tone of a certain frequency
function signal = tone(f, duration)
    t = [0:(1/8e3):duration];
    signal = sin(2*pi*f*t);
