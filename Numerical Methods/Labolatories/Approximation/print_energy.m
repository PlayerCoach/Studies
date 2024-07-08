function print_energy(energy)

countries = {'Brazil', 'China', 'Czechia', 'France', 'Germany', 'India', 'Italy', 'Latvia', 'Poland', 'Slovakia', 'Spain', 'Sweden', 'USA', 'Ukraine', 'United_Kingdom'};
sources = {'Bioenergy', 'Coal', 'Gas', 'Hydro', 'Nuclear', 'Other_Fossil', 'Other_Renewables', 'Solar', 'Wind'};

for cid=1:length(countries)
    country = countries{cid};
    for sid=1:length(sources)
        source = sources{sid};
        if isfield(energy, country) && isfield(energy.(country), source)
            y_original = energy.(country).(source).EnergyProduction;
            tt = energy.(country).(source).Dates;
            fprintf('%-30s | liczba danych: %5d\n', [country, '.', source], length(y_original));
        end
    end
end

end
