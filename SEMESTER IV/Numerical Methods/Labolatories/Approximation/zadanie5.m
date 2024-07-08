function [country, source, degrees, x_coarse, x_fine, y_original, y_yearly, y_approximation, mse, msek] = zadanie5(energy)
    % Głównym celem tej funkcji jest wyznaczenie danych na potrzeby analizy dokładności aproksymacji cosinusowej.
    % 
    % energy - struktura danych wczytana z pliku energy.mat
    % country - [String] nazwa kraju
    % source  - [String] źródło energii
    % x_coarse - wartości x danych aproksymowanych
    % x_fine - wartości, w których wyznaczone zostaną wartości funkcji aproksymującej
    % y_original - dane wejściowe, czyli pomiary produkcji energii zawarte w wektorze energy.(country).(source).EnergyProduction
    % y_yearly - wektor danych rocznych
    % y_approximation - tablica komórkowa przechowująca wartości nmax funkcji aproksymujących dane roczne.
    %   - nmax = length(y_yearly)-1
    %   - y_approximation{1,i} stanowi aproksymację stopnia i
    %   - y_approximation{1,i} stanowi wartości funkcji aproksymującej w punktach x_fine
    % mse - wektor mający nmax wierszy: mse(i) zawiera wartość błędu średniokwadratowego obliczonego dla aproksymacji stopnia i.
    %   - mse liczony jest dla aproksymacji wyznaczonej dla wektora x_coarse
    % msek - wektor mający nmax wierszy: msek zawiera wartości błędów różnicowych zdefiniowanych w treści zadania 5
    %   - msek(i) porównuj aproksymacje wyznaczone dla i-tego oraz (i+1) stopnia wielomianu
    %   - msek liczony jest dla aproksymacji wyznaczonych dla wektora x_fine
    
    country = 'Poland';
    source = 'Coal';
    degrees = 1:4;
    x_coarse = [];
    x_fine = [];
    y_original = [];
    y_yearly = [];
    y_approximation = [];
    mse = [];
    msek = [];

    % Sprawdzenie dostępności danych
    if isfield(energy, country) && isfield(energy.(country), source)
        % Przygotowanie danych do aproksymacji
        dates = energy.(country).(source).Dates;
        y_original = energy.(country).(source).EnergyProduction;

        % Obliczenie danych rocznych
        n_years = floor(length(y_original) / 12);
        y_cut = y_original(end-12*n_years+1:end);
        y4sum = reshape(y_cut, [12 n_years]);
        y_yearly = sum(y4sum, 1)';

        N = length(y_yearly);
        P = (N-1)*8+1;
        x_coarse = linspace(0, 1, N)';
        x_fine = linspace(0, 1, P)';

        % Inicjalizacja przechowywania aproksymacji
        y_approximation = cell(1, N-1);
        mse = zeros(N, 1);
        msek = zeros(N-1, 1);

        % Pętla po różnych stopniach aproksymacji
        for i = 1:N
            X = dct2_custom(y_yearly, N);
            y_approximation{i} = idct2_custom(X, i, N, P);
            y_approx_coarse = idct2_custom(X, i, N, N);
            mse(i) = mean((y_yearly - y_approx_coarse).^2);
        end
        
        % Obliczenie błędów różnicowych między kolejnymi aproksymacjami
        for i = 1:N-1
            y_diff = y_approximation{i} - y_approximation{i+1};
            msek(i) = mean(y_diff.^2);
        end

        % Rysowanie wyników
        colors = ['r', 'g', 'm', 'c'];
        figure;

        % Rysowanie oryginalnych i aproksymowanych danych
        subplot(3, 1, 1);
        plot(x_coarse, y_yearly, 'b', 'DisplayName', 'Oryginalne dane roczne');
        hold on;
        for i = 1:length(degrees)
            plot(x_fine, y_approximation{degrees(i)}, colors(i), 'DisplayName', ['Stopień ', num2str(degrees(i))]);
        end
        hold off;
        legend('show');
        title(['Aproksymacja cosinusowa danych rocznych dla (country=', country, ') oraz (source=', source, ')']);
        xlabel('Znormalizowany czas');
        ylabel('Produkcja energii [GWh]');

        % Rysowanie MSE
        subplot(3, 1, 2);
        semilogy(1:N, mse, '-o');
        title('Błąd średniokwadratowy w funkcji stopnia aproksymacji');
        xlabel('Stopień aproksymacji');
        ylabel('Błąd średniokwadratowy');

        % Rysowanie błędów różnicowych
        subplot(3, 1, 3);
        semilogy(1:N-1, msek, '-o');
        title('Błąd różnicowy w funkcji różnicy stopni aproksymacji');
        xlabel('Różnica stopni aproksymacji');
        ylabel('Błąd różnicowy');

        % Zapisanie wykresu
        saveas(gcf, 'zadanie5.png');

    else
        disp(['Dane dla (country=', country, ') oraz (source=', source, ') nie są dostępne.']);
    end
end

function X = dct2_custom(x, kmax)
    % Wyznacza kmax pierwszych współczynników DCT-2 dla wektora wejściowego x.
    N = length(x);
    X = zeros(kmax, 1);
    c2 = sqrt(2/N);
    c3 = pi/2/N;
    nn = (1:N)';

    X(1) = sqrt(1/N) * sum( x(nn) );
    for k = 2:kmax
        X(k) = c2 * sum( x(nn) .* cos(c3 * (2*(nn-1)+1) * (k-1)) );
    end
end

function x = idct2_custom(X, kmax, N, P)
    % Wyznacza wartości aproksymacji cosinusowej x.
    % X - współczynniki DCT
    % kmax - liczba współczynników DCT zastosowanych do wyznaczenia wektora x
    % N - liczba danych dla których została wyznaczona macierz X
    % P - długość zwracanego wektora x (liczba wartości funkcji aproksymującej w przedziale [0,1])
    x = zeros(P, 1);
    kk = (2:kmax)';
    c1 = sqrt(1/N);
    c2 = sqrt(2/N);
    c3 = pi*(N - 1)/(2*N*(P - 1));
    c4 = -(pi*(N - P))/(2*N*(P - 1));

    for n = 1:P
        x(n) = c1*X(1) + c2*sum( X(kk) .* cos((c3*(2*(n-1)+1)+c4) * (kk-1)) );
    end
end
    