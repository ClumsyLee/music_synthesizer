%% period_avg: Calculate the avg in a period of time
function avg = period_avg(x, period)
    row = period;
    col = floor(length(x) / row);
    avg = mean(reshape(x(1:row*col), [row, col])')';
