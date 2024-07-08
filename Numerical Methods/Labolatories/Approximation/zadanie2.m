function [country, source, degrees, y_original, y_movmean, y_approximation, mse] = zadanie2(energy)
    % Głównym celem tej funkcji jest wyznaczenie aproksymacji wygładzonych danych o produkcji energii elektrycznej w wybranym kraju i z wybranego źródła energii.
    % Wygładzenie danych wykonane jest poprzez wywołanie funkcji movmean.
    % Wybór kraju i źródła energii należy określić poprzez nadanie w tej funkcji wartości zmiennym typu string: country, source.
    % Dopuszczalne wartości tych zmiennych można sprawdzić poprzez sprawdzenie zawartości struktury energy zapisanej w pliku energy.mat.
    % 
    % energy - struktura danych wczytana z pliku energy.mat
    % country - [String] nazwa kraju
    % source  - [String] źródło energii
    % degrees - wektor zawierający cztery stopnie wielomianu dla których wyznaczono aproksymację
    % y_original - dane wejściowe, czyli pomiary produkcji energii zawarte w wektorze energy.(country).(source).EnergyProduction
    % y_movmean - średnia 12-miesięczna danych wejściowych, y_movmean = movmean(y_original,[11,0]);
    % y_approximation - tablica komórkowa przechowująca cztery wartości funkcji aproksymującej wygładzone dane wejściowe. y_approximation stanowi aproksymację stopnia degrees(i).
    % mse - wektor o rozmiarze 4x1: mse(i) zawiera wartość błędu średniokwadratowego obliczonego dla aproksymacji stopnia degrees(i).
    country = 'Poland';
    source = 'Coal';
    degrees = [2,4,16,32];
    y_original = [];
    y_approximation= [];
    mse = [];
    % Sprawdzenie dostępności danych
    if isfield(energy, country) && isfield(energy.(country), source)
        % Przygotowanie danych do aproksymacji
        dates = energy.(country).(source).Dates;
        y_original = energy.(country).(source).EnergyProduction;
        y_movmean = movmean(y_original,[11,0]);
    
        x = linspace(-1,1,length(y_original))';
    
        % Pętla po wielomianach różnych stopni
        for i = 1:length(degrees)
            % Wyznaczenie współczynników wielomianu
            p = polyfit(x, y_movmean, degrees(i));
            % Obliczenie wartości wielomianu dla punktów x
            y_approximation{i} = polyval(p, x);
            % Obliczenie błędu średniokwadratowego
            mse(i) = mean((y_movmean - y_approximation{i}).^2);
        end

        colors = ['r', 'g', 'm', 'c']; 
        figure;
        subplot(2,1,1); 
        plot(dates, y_original, 'b');
        hold on;
        for i = 1:length(degrees)
            plot(dates, y_approximation{i}, colors(i), 'DisplayName', ['Stopień ', num2str(degrees(i))]);
        end
        plot(dates, y_movmean, 'k', 'DisplayName', 'Średnia 12-miesięczna');
        hold off;
        legend('Dane oryginalne', 'Stopień 2', 'Stopień 4', 'Stopień 16', 'Stopień 32', 'Średnia 12-miesięczna');
        title(['Aproksymacja danych dla (country=', country, ') oraz (source=', source, ')']);
        xlabel('Data');
        ylabel('Produkcja energii [GWh]');

        subplot(2,1,2)
        bar(mse);
        set(gca, 'XTickLabel', degrees);
        title('Błąd średniokwadratowy dla różnych stopni aproksymacji');
        xlabel('Stopień aproksymacji');
        ylabel('Błąd średniokwadratowy');

        saveas(gcf, 'zadanie2.png'); 
    
    else
        disp(['Dane dla (country=', country, ') oraz (source=', source, ') nie są dostępne.']);
    end
    
    end