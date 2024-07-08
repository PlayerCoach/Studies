function [country, source, degrees, y_original, y_approximation, mse] = zadanie1(energy)
    % Głównym celem tej funkcji jest wyznaczenie aproksymacji danych o produkcji energii elektrycznej w wybranym kraju i z wybranego źródła energii.
    % Wybór kraju i źródła energii należy określić poprzez nadanie w tej funkcji wartości zmiennym typu string: country, source.
    % Dopuszczalne wartości tych zmiennych można sprawdzić poprzez sprawdzenie zawartości struktury energy zapisanej w pliku energy.mat.
    % 
    % energy - struktura danych wczytana z pliku energy.mat
    % country - [String] nazwa kraju
    % source  - [String] źródło energii
    % degrees - wektor zawierający cztery stopnie wielomianu dla których wyznaczono aproksymację
    % y_original - dane wejściowe, czyli pomiary produkcji energii zawarte w wektorze energy.(country).(source).EnergyProduction
    % y_approximation - tablica komórkowa przechowująca cztery wartości funkcji aproksymującej dane wejściowe. y_approximation stanowi aproksymację stopnia degrees(i).
    % mse - wektor o rozmiarze 4x1: mse(i) zawiera wartość błędu średniokwadratowego obliczonego dla aproksymacji stopnia degrees(i).
    
    country = 'Poland';
    source = 'Coal';
    degrees = [1,5,10,20];
    y_original = [];
    y_approximation= [];
    mse = [];
    
    
    % Sprawdzenie dostępności danych
    if isfield(energy, country) && isfield(energy.(country), source)
        % Przygotowanie danych do aproksymacji
        y_original = energy.(country).(source).EnergyProduction;
        dates = energy.(country).(source).Dates;
    
        x = linspace(-1,1,length(y_original))';
    
        % Pętla po wielomianach różnych stopni
        for i = 1:length(degrees)
            % Wyznaczenie współczynników wielomianu
            p = polyfit(x, y_original, degrees(i));
            % Obliczenie wartości wielomianu dla punktów x
            y_approximation{i} = polyval(p, x);
            % Obliczenie błędu średniokwadratowego
            mse(i) = mean((y_original - y_approximation{i}).^2);
        end
        colors = ['r', 'g', 'm', 'c']; 
        figure;
        subplot(2,1,1); 
        plot(dates, y_original, 'b');
        hold on;
        for i = 1:length(degrees)
            plot(dates, y_approximation{i}, colors(i), 'DisplayName', ['Stopień ', num2str(degrees(i))]);
        end
        hold off;
        legend('Dane oryginalne', 'Stopień 1', 'Stopień 5', 'Stopień 10', 'Stopień 20');
        title(['Aproksymacja danych dla (country=', country, ') oraz (source=', source, ')']);
        xlabel('Data');
        ylabel('Produkcja energii [GWh]');

        subplot(2,1,2)
        bar(mse);
        set(gca, 'XTickLabel', degrees);
        title('Błąd średniokwadratowy dla różnych stopni aproksymacji');
        xlabel('Stopień aproksymacji');
        ylabel('Błąd średniokwadratowy');

        saveas(gcf, 'zadanie1.png'); 
        
    
    else
        disp(['Dane dla (country=', country, ') oraz (source=', source, ') nie są dostępne.']);
    end
    
    end