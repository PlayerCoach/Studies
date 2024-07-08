function plot_problem_5(N,time_Jacobi,time_Gauss_Seidel,iterations_Jacobi,iterations_Gauss_Seidel)
  
    
    subplot(2,1,1);
    plot(N, time_Jacobi);
    hold on;
    plot(N, time_Gauss_Seidel);
    hold off;
    title('Time of Computations vs Matrix Size');
    xlabel('Matrix Size');
    ylabel('Time (s)');
    legend('Jacobi', 'Gauss-Seidel', 'Location', 'eastoutside');

    subplot(2,1,2);
    bar(N, [iterations_Jacobi ; iterations_Gauss_Seidel]);
    title('Number of Iterations vs Matrix Size');
    xlabel('Matrix Size');
    ylabel('Number of Iterations');
    legend('Jacobi', 'Gauss-Seidel', 'Location', 'eastoutside');
end