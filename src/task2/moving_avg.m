%% moving_avg: Shifted moving average.
function avg = moving_avg(x, lag_from, lag_to)
    lag = lag_from - lag_to + 1;
    shifted = [zeros(lag_to, 1); x(1:length(x)-lag_to)];
    avg = movavg(shifted, lag, lag, 0);

