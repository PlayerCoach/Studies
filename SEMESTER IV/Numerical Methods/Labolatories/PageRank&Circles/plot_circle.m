function plot_circle(R, X, Y)
    % R - promień okręgu
    % X - współrzędna x środka okręgu
    % Y - współrzędna y środka okręgu
    theta = linspace(0,2*pi);
    x = R*cos(theta) + X;
    y = R*sin(theta) + Y;
    plot(x,y)
end
