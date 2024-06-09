function [] = plotConstellation(constellation1, constellation2, titleText, limits)
    figure;
    subplot(2, 1, 1);
    scatter(real(constellation1), imag(constellation1), 'filled');
    xlim(limits);
    ylim(limits);
    line(xlim, [0 0], 'Color', 'k');
    line([0 0], ylim, 'Color', 'k');
    xlabel('Real Part');
    ylabel('Imaginary Part');
    title([titleText, ' - ideal constellation']);
    grid on;
    subplot(2, 1, 2);
    scatter(real(constellation2), imag(constellation2), 'filled');
    xlim(limits);
    ylim(limits);
    line(xlim, [0 0], 'Color', 'k');
    line([0 0], ylim, 'Color', 'k');
    xlabel('Real Part');
    ylabel('Imaginary Part');
    title([titleText, ' - received constellation']);
    grid on;
    saveas(gcf, ['./graphs/', titleText, '_constellations', '.png']);
end