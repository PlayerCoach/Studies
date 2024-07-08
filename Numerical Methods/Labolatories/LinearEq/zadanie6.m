load('filtr_dielektryczny.mat');

% Solve using direct method

[x,time_direct,err_norm] = solveDirect(A, b);
residual_error_direct = err_norm;

plot(err_norm);
xlabel('Iteration');
ylabel('Error Norm');
title('Error Norm for Direct');
saveas(gcf, 'zadanie6_1.png');

plot(x);
xlabel('X');
ylabel('Y');
title('Value for Driect Method');
saveas(gcf, 'zadanie6_2.png');


[M,bm,x,err_norm,time,iterations] = solveJacobi(A,b);
residual_error_jacobi = err_norm;

plot(err_norm);
xlabel('Iteration');
ylabel('Error Norm');
title('Error Norm for Jacobi Method');
saveas(gcf, 'zadanie6_3.png');

plot(x);
xlabel('X');
ylabel('Y');
title('Value for Jacobi Method');
saveas(gcf, 'zadanie6_4.png');

% Solve using Gauss method
% $PLACEHOLDER$
[M,bm,x,err_norm,time,iterations] = solveGauss(A,b);
residual_error_gauss = err_norm;

plot(err_norm);
xlabel('Iteration');
ylabel('Error Norm');
title('Error Norm for Gauss Method');
saveas(gcf, 'zadanie6_5.png');

plot(x);
xlabel('X');
ylabel('Y');
title('Value for GaussMethod');
saveas(gcf, 'zadanie6_6.png');