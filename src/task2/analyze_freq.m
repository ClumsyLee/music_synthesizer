%% analyze_freq: Analyze the freq of a signal.
function [baseband, band_wights] = analyze_freq(sig, f_sample)
    error_ratio = 0.01;

    f = abs(fft(sig));
    f = f(1:ceil(length(f) / 2));  % Only use the lower half.
    f(f < 0.1 * max(f)) = 0;  % Truncate insignificant bands.

    %% Only care about the most significant band.
    [max_wight, max_band] = max(f);

    %% Find base band.
    baseband = max_band;
    base_wight = max_wight;
    for ratio = [2, 3, 4]
        band = (max_band - 1) / ratio + 1;
        [maximum, index] = max_around(f, band, error_ratio);
        if maximum > 0.4 * max_wight
            baseband = index;
            base_wight = maximum;
        end
    end

    %% Calculate wights.
    band_wights = [base_wight];
    for ratio = [2, 3, 4]
        band_wights(ratio) = max_around(f, ratio * baseband, error_ratio);
    end
    band_wights = band_wights / base_wight;

    %% Calculate baseband.
    baseband = (baseband - 1) / length(sig) * f_sample;
end

%% max_around: Find maximum around a index.
function [maximum, index] = max_around(x, index, error_ratio)
    from = ceil(index *  (1 - error_ratio));
    to   = floor(index * (1 + error_ratio));
    [maximum, index] = max(x(from:to));
    index = index + from - 1;
end
