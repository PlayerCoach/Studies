function [country, source, degrees, x_coarse, x_fine, y_original, y_yearly, y_approximation, mse, msek] = zadanie4(energy)
    % Głównym celem tej funkcji jest wyznaczenie danych na potrzeby analizy dokładności aproksymacji wielomianowej.
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
        P = (N-1)*10+1;
        x_coarse = linspace(-1, 1, N)';
        x_fine = linspace(-1, 1, P)';
    
        % Inicjalizacja przechowywania aproksymacji
        y_approximation = cell(1, N-1);
        mse = zeros(N-1, 1);
        msek = zeros(N-2, 1);
    
        % Pętla po wielomianach różnych stopni
        for i = 1:N-1
            % Wyznaczenie współczynników wielomianu
            p = my_polyfit(x_coarse, y_yearly, i);
            % Obliczenie wartości wielomianu w punktach x_coarse
            y_approx = polyval(p, x_coarse);
            % Obliczenie wartości wielomianu w punktach x_fine
            y_approximation{i} = polyval(p, x_fine);
            % Obliczenie MSE dla tego stopnia
            mse(i) = mean((y_yearly - y_approx).^2);
        end
        
        % Obliczenie błędów różnicowych między kolejnymi aproksymacjami
        for i = 1:N-2
            y_diff = y_approximation{i} - y_approximation{i+1};
            msek(i) = mean(y_diff.^2);
        end

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
        title(['Aproksymacja danych rocznych dla (country=', country, ') oraz (source=', source, ')']);
        xlabel('Znormalizowany czas');
        ylabel('Produkcja energii [GWh]');
        
        % Rysowanie MSE
        subplot(3, 1, 2);
        semilogy(1:N-1, mse, '-o');
        title('Błąd średniokwadratowy w funkcji stopnia wielomianu');
        xlabel('Stopień wielomianu');
        ylabel('Błąd średniokwadratowy');
        
        % Rysowanie błędów różnicowych
        subplot(3, 1, 3);
        semilogy(1:N-2, msek, '-o');
        title('Błąd różnicowy w funkcji różnicy stopni wielomianów');
        xlabel('Różnica stopni wielomianów');
        ylabel('Błąd różnicowy');
        
        % Zapisanie wykresu
        saveas(gcf, 'zadanie4.png');
    
    else
        disp(['Dane dla (country=', country, ') oraz (source=', source, ') nie są dostępne.']);
    end
end

function p = my_polyfit(x, y, deg)
    V = zeros(length(x), deg + 1);
    for i = 0:deg
        V(:, deg + 1 - i) = x.^i;
    end
    
    [Q, R] = qr(V, 0);
    p = R \ (Q' * y);
    p = p';
    end
        