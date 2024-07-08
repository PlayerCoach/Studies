a = 1;
b = 50;
ytolerance = 1e-12;
max_iterations = 100;
fun = @impedance_magnitude;

[omega_bisection,ysolution_bisection,iterations_bisection,xtab_bisection,xdif_bisection] = bisection_method(a,b,max_iterations,ytolerance,fun);
[omega_secant,ysolution_secant,iterations_secant,xtab_secant,xdif_secant] = secant_method(a,b,max_iterations,ytolerance,fun);

figure;

subplot(2,1,1);
plot(xtab_bisection, 'b', 'LineWidth', 2);
hold on;
plot(xtab_secant, 'r', 'LineWidth', 2);
hold off;
xlabel('Iteration');
ylabel('xtab');
legend('Bisection Method', 'Secant Method');
title('Approximation of Solution (xtab)');

subplot(2,1,2);
semilogy(xdif_bisection, 'b', 'LineWidth', 2);
hold on;
semilogy(xdif_secant, 'r', 'LineWidth', 2);
hold off;
xlabel('Iteration');
ylabel('xdif');
legend('Bisection Method', 'Secant Method');
title('Difference between Approximations (xdif)');

saveas(gcf, 'zad4.png')