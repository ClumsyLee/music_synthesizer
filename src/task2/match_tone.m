%% match_tone: Find the closest tone to a certain frequency.
function tone = match_tone(f)
    load tones
    [value, index] = min(abs(tone_freqs - f));
    tone = tone_names{index};
