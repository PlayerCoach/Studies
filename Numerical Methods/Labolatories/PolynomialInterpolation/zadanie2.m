function [nodes_Chebyshev, V, V2, original_Runge, interpolated_Runge, interpolated_Runge_Chebyshev] = zadanie2()
    % nodes_Chebyshev - wektor wierszowy zawierający N=16 węzłów Czebyszewa drugiego rodzaju
    % V - macierz Vandermonde obliczona dla 16 węzłów interpolacji rozmieszczonych równomiernie w przedziale [-1,1]
    % V2 - macierz Vandermonde obliczona dla węzłów interpolacji zdefiniowanych w wektorze nodes_Chebyshev
    % original_Runge - wektor wierszowy zawierający wartości funkcji Runge dla wektora x_fine=linspace(-1, 1, 1000)
    % interpolated_Runge - wektor wierszowy wartości funkcji interpolującej określonej dla równomiernie rozmieszczonych węzłów interpolacji
    % interpolated_Runge_Chebyshev - wektor wierszowy wartości funkcji interpolującej wyznaczonej
    %       przy zastosowaniu 16 węzłów Czebyszewa zawartych w nodes_Chebyshev 
        N = 16;
        x_fine = linspace(-1, 1, 1000);
        nodes_Chebyshev = get_Chebyshev_nodes(N);
    
        V = vandermonde_matrix(N);
        V2 = vandermonde_matrix_Chebyshev(nodes_Chebyshev);

        original_Runge = runge(x_fine);
        nodes = linspace(-1, 1, N);

        runge_values = runge(nodes);
        runge_values = runge_values';
        c_runge = V \ runge_values;
        interpolated_Runge = polyval(flipud(c_runge), x_fine);

        runge_values_Chebyshev = runge(nodes_Chebyshev);
        runge_values_Chebyshev = runge_values_Chebyshev';
        c_runge_Chebyshev = V2 \ runge_values_Chebyshev;
        interpolated_Runge_Chebyshev = polyval(flipud(c_runge_Chebyshev), x_fine);

        subplot(2,1,1);
        plot(x_fine, original_Runge);
        title('Interpolacja funkcji Rungego');
        xlabel('x');
        ylabel('y');
        hold on;
        plot(nodes, runge_values, 'o');
        plot(x_fine, interpolated_Runge);
        legend;
        hold off;

        subplot(2,1,2);
        plot(x_fine, original_Runge);
        title('Interpolacja funkcji Rungego - węzły Czebyszewa');
        xlabel('x');
        ylabel('y');
        hold on;
        plot(nodes_Chebyshev, runge_values_Chebyshev, 'o');
        plot(x_fine, interpolated_Runge_Chebyshev);
        legend;
        hold off;

        saveas(gcf, 'zadanie2.png');
        

        
    end
    
    function nodes = get_Chebyshev_nodes(N)
        % oblicza N węzłów Czebyszewa drugiego rodzaju
        nodes = zeros(1, N);
        for i = 0:N-1
            nodes(i+1) = cos(i*pi/(N-1));
        end
    end

    function V = vandermonde_matrix(N)
        % Generuje macierz Vandermonde dla N równomiernie rozmieszczonych w przedziale [-1, 1] węzłów interpolacji
        x_coarse = linspace(-1,1,N);
        V = zeros(N,N);
        for i = 1:N
            V(:,i) = x_coarse.^(i-1);
        end
    end

    function V2 = vandermonde_matrix_Chebyshev(nodes)
        % Generuje macierz Vandermonde dla węzłów interpolacji zdefiniowanych w wektorze nodes
        N = length(nodes);
        V2 = zeros(N,N);
        for i = 1:N
            V2(:,i) = nodes.^(i-1);
        end
    end

    function y = runge(x)
        % Funkcja obliczająca wartości funkcji Rungego w punktach x
        y = 1./(1+25*x.^2);
    end