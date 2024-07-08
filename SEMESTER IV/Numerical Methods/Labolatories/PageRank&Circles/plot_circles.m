function plot_circles(a, circles, index_number)
    % Set up the plot
    figure;
    axis equal;
    axis([0 a 0 a]);

    % Hold on to allow adding new circles without clearing previous ones
    hold on;

    % Loop through circles and plot them
    for i = 1:size(circles, 2)
        plot_circle(circles(1, i), circles(2, i), circles(3, i));
    
    end

    % Hold off to stop adding new elements to the plot
    hold off;
end
