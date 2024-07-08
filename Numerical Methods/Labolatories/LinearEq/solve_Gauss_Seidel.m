function [A,b,M,bm,x,err_norm,time,iterations,index_number] = solve_Gauss_Seidel(N)
    % A - macierz rzadka z równania macierzowego A * x = b
    % b - wektor prawej strony równania macierzowego A * x = b
    % M - macierz pomocnicza opisana w instrukcji do Laboratorium 3 – sprawdź wzór (7) w instrukcji, który definiuje M jako M_{GS}
    % bm - wektor pomocniczy opisany w instrukcji do Laboratorium 3 – sprawdź wzór (7) w instrukcji, który definiuje bm jako b_{mGS}
    % x - rozwiązanie równania macierzowego
    % err_norm - norma błędu rezydualnego rozwiązania x; err_norm = norm(A*x-b)
    % time - czas wyznaczenia rozwiązania x
    % iterations - liczba iteracji wykonana w procesie iteracyjnym metody Gaussa-Seidla
    % index_number - Twój numer indeksu
    index_number = 193415 ;
    L1 = 5;
    [A,b] = generate_matrix(N, L1);
    
    L = tril(A, -1); % trójkątna dolna
    U = triu(A, 1); % trójkątna górna
    D = diag(diag(A)); % diagonalna


    M = -(D+L)\U;
    bm = (D+L)\b;
    x = ones(N,1); % wektor startowy
    iterations = 0;
    err_norm = 1;
   tic;
    for i = 1:1000
        x = M * x + bm;
        err_norm = norm(A*x-b);
        iterations = iterations + 1;
        if err_norm < 1e-12
            break;
        end
    end

    time = toc;
    end
    