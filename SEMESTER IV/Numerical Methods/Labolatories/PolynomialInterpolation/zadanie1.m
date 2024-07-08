function [V, original_Runge, original_sine, interpolated_Runge, interpolated_sine] = zadanie1()
    % Rozmiar tablic komórkowych (cell arrays) V, interpolated_Runge, interpolated_sine: [1,4].
    % V{i} zawiera macierz Vandermonde wyznaczoną dla liczby węzłów interpolacji równej N(i)
    % original_Runge - wektor wierszowy zawierający wartości funkcji Runge dla wektora x_fine=linspace(-1, 1, 1000)
    % original_sine - wektor wierszowy zawierający wartości funkcji sinus dla wektora x_fine
    % interpolated_Runge{i} stanowi wierszowy wektor wartości funkcji interpolującej 
    %       wyznaczonej dla funkcji Runge (wielomian stopnia N(i)-1) w punktach x_fine
    % interpolated_sine{i} stanowi wierszowy wektor wartości funkcji interpolującej
    %       wyznaczonej dla funkcji sinus (wielomian stopnia N(i)-1) w punktach x_fine
        N = 4:4:16;
        x_fine = linspace(-1, 1, 1000);
        original_Runge = runge(x_fine);
    
        subplot(2,1,1);
     

        plot(x_fine, original_Runge);
        title('Interpolacja funkcji Rungego');
        xlabel('x');
        ylabel('y');
        hold on;
        for i = 1:length(N)
            V{i} = vandermonde_matrix(N(i));% macierz Vandermonde
            nodes = linspace(-1, 1, N(i)); % węzły interpolacji
            runge_values = runge(nodes);  % wartości funkcji interpolowanej w węzłach interpolacji
            runge_values = runge_values'; % transpozycja
            c_runge = V{i} \ runge_values; % współczynniki wielomianu interpolującego
            interpolated_Runge{i} = polyval(flipud(c_runge), x_fine); % interpolacja
            plot(x_fine, interpolated_Runge{i}, 'DisplayName', ['Interpolacja dla N = ', num2str(N(i))]);
          
        end
        legend;
        hold off
    
        original_sine = sin(2 * pi * x_fine);
        subplot(2,1,2);
        plot(x_fine, original_sine);
        title('Interpolacja funkcji sin(x)');
        xlabel('x');
        ylabel('y');
        hold on;
        for i = 1:length(N)
            nodes = linspace(-1, 1, N(i)); % węzły interpolacji
            sine_values = sin(2 * pi * nodes);  % wartości funkcji interpolowanej w węzłach interpolacji
            sine_values = sine_values'; % transpozycja
            c_sine = V{i} \ sine_values; % współczynniki wielomianu interpolującego
            interpolated_sine{i} = polyval(flipud(c_sine), x_fine); % interpolacja
            plot(x_fine, interpolated_sine{i}, 'DisplayName', ['Interpolacja dla N = ', num2str(N(i))]);
        end
        legend;
        hold off
        saveas(gcf, 'zadanie1.png');
    end
    
    function V = vandermonde_matrix(N)
        % Generuje macierz Vandermonde dla N równomiernie rozmieszczonych w przedziale [-1, 1] węzłów interpolacji
        x_coarse = linspace(-1,1,N);
        V = zeros(N,N);
        for i = 1:N
            V(:,i) = x_coarse.^(i-1);
        end
    end

    function y = runge(x)
        % Funkcja Rungego
        y = 1./(1+25*x.^2);
    end
