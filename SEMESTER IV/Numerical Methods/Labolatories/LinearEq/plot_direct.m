function plot_direct(N,vtime_direct)
    % N - wektor zawierający rozmiary macierzy dla których zmierzono czas obliczeń metody bezpośredniej
    % vtime_direct - czas obliczeń metody bezpośredniej dla kolejnych wartości N
    % Plotting the results
    figure;
    plot(N, vtime_direct, 'b-o');
    xlabel('Matrix Size (N)');
    ylabel('Computation Time (s)');
    title('Computation Time vs Matrix Size');
    grid on;

end