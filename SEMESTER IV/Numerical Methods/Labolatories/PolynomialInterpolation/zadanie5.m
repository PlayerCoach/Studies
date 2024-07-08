function [M,N,P,R,x_coarse,y_coarse,F_coarse,x_fine,y_fine,F_fine] = zadanie5()
    P = 155; % liczba unikalnych współrzędnych x punktów dla których będzie obliczana interpolacja
    R = 155; % liczba unikalnych współrzędnych y punktów dla których będzie obliczana interpolacja
    M = 30; % liczba węzłów interpolacji wzdłuż osi X (stopień wielomianu zmiennej x: M-1)
    N = 30; % liczba węzłów interpolacji wzdłuż osi Y (stopień wielomianu zmiennej y: N-1)
    
    x_coarse = linspace(0, 1, M);
    y_coarse = linspace(0, 1, N);
    [X_coarse, Y_coarse] = meshgrid(x_coarse, y_coarse);
    
    F_coarse = sin(X_coarse*2*pi) .* abs(Y_coarse-0.5);
    
    MN = M*N;
    xvec_coarse = reshape(X_coarse, MN, 1);
    yvec_coarse = reshape(Y_coarse, MN, 1);
    fvec_coarse = reshape(F_coarse, MN, 1);
    
    V = zeros(M*N, M*N);
    for i = 0:(M-1)
        for j = 0:(N-1)
            V(:, i*N + j + 1) = xvec_coarse.^i .* yvec_coarse.^j;
        end
    end
    
    coeffs = V \ fvec_coarse;
    
    x_fine = linspace(0, 1, P);
    y_fine = linspace(0, 1, R);
    [X_fine, Y_fine] = meshgrid(x_fine, y_fine);
    
    F_fine = zeros(size(X_fine));
    
    for i = 0:(M-1)
        for j = 0:(N-1)
            F_fine = F_fine + coeffs(i*N + j + 1) * X_fine.^i .* Y_fine.^j;
        end
    
    end

    subplot(2,1,1);
    surf(X_coarse, Y_coarse, F_coarse);
    title('Original function values at the nodes');
    xlabel('x');
    ylabel('y');
    zlabel('f(x,y)');

    subplot(2,1,2);
    surf(X_fine, Y_fine, F_fine);
    title('Interpolated function values');
    xlabel('x');
    ylabel('y');
    zlabel('f(x,y)');

    saveas(gcf, 'zadanie5.png');
end