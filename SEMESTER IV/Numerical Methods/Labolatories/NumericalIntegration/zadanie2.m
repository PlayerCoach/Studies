function [integration_error, Nt, ft_5, integral_1000] = zadanie2()
     % Numeryczne całkowanie metodą prostokątów.
    % Nt - wektor zawierający liczby podprzedziałów całkowania
    % integration_error - integration_error(1,i) zawiera błąd całkowania wyznaczony
    %   dla liczby podprzedziałów równej Nt(i). Zakładając, że obliczona wartość całki
    %   dla Nt(i) liczby podprzedziałów całkowania wyniosła integration_result,
    %   to integration_error(1,i) = abs(integration_result - reference_value),
    %   gdzie reference_value jest wartością referencyjną całki.
    % ft_5 - gęstość funkcji prawdopodobieństwa dla n=5
    % integral_1000 - całka od 0 do 5 funkcji gęstości prawdopodobieństwa
    %   dla 1000 podprzedziałów całkowania

   % Parameters
   mu = 10; % Mean
   sigma = 3; % Standard deviation
   reference_value = 0.0473612919396179; % Reference value for the integral

   % Function definition
   f = @(t) (1 / (sigma * sqrt(2 * pi))) * exp(-((t - mu)^2) / (2 * sigma^2));

   % Calculate f(t) for t = 5
   t = 5;
   ft_5 = f(t);
   
 

   % Calculate the integral for N = 1000
   N_1000 = 1000;
   integral_1000 = trapezoid_method(f, N_1000);

   % Initialize Nt and integration_error
   Nt = 5:50:10^4;
   integration_error = zeros(size(Nt));
   
   % Calculate integration error for different Nt values
   for i = 1:length(Nt)
       N = Nt(i);
       integral = trapezoid_method(f, N);
       integration_error(i) = abs(integral - reference_value);
   end

   % Plot the integration error
   figure;
   loglog(Nt, integration_error);
   xlabel('Number of Subintervals (N)');
   ylabel('Integration Error');
   title('Integration Error vs. Number of Subintervals');
   saveas(gcf, 'zadanie2.png');
end

  % Trapezoid method for numerical integration
  function integral = trapezoid_method(func, N)
    a = 0;
    b = 5;
    dx = (b - a) / N;
    x = linspace(a, b, N + 1);
    y = arrayfun(func, x);
    integral = sum((y(2:end) + y(1:end-1)) * dx / 2);
end
 