%% plot_with_highlight: Plot a curve with some points highlighted.
function plot_with_highlight(x, y, highlight_index)
    figure;
    plot(x, y);
    plot(x, y);
    hold on;
    stem(x(highlight_index), y(highlight_index), 'LineWidth', 4);
