function [integration_error, Nt, ft_5, xr, yr, yrmax] = zadanie4()
    % Numeryczne całkowanie metodą Monte Carlo.

    % Reference value of the integral
    reference_value = 0.0473612919396179;

    mu = 10; 
    sigma = 3; 
    
    f = @(t) (1 / (sigma * sqrt(2 * pi))) * exp(-((t - mu)^2) / (2 * sigma^2));
   
    t = 5;
    ft_5 = f(t);

    yrmax = ft_5 * 1.1; % Slightly larger than ft_5 for safety margin

    a = 0;
    b = 5;

    Nt = 5:50:10^4;
    integration_error = zeros(size(Nt));
  
    xr = cell(size(Nt));
    yr = cell(size(Nt));

    for i = 1:length(Nt)
        N = Nt(i);
        [integral, x_points, y_points] = MonteCarlo_method(f, N, a, b, yrmax);
        integration_error(i) = abs(integral - reference_value);
        xr{i} = x_points;
        yr{i} = y_points;
    end

    figure;
    loglog(Nt, integration_error);
    xlabel('Number of Sampled Points (N)');
    ylabel('Integration Error');
    title('Integration Error vs. Number of Sampled Points (Monte Carlo)');
    saveas(gcf, 'zadanie4.png');
end

function [integral, x_points, y_points] = MonteCarlo_method(f, N, a, b, yrmax)
    x_points = a + (b - a) * rand(1, N);
    y_points = yrmax * rand(1, N);
    fx = arrayfun(f, x_points);
    points_below_curve = sum(y_points <= fx);
    area_rect = (b - a) * yrmax;
    integral = area_rect * (points_below_curve / N);
end
