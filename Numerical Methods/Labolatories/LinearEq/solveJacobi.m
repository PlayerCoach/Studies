function [M,bm,x,err_norm,time,iterations] = solveJacobi(A,b)
    
    L = tril(A, -1); % trójkątna dolna
    U = triu(A, 1); % trójkątna górna
    D = diag(diag(A)); % diagonalna

    M = -D\(L + U);
    bm = D\b;
    x = ones(size(A, 1),1); % wektor startowy
    err_norm = zeros(1000,1);
    iterations = 0;
    err_norm(1) = norm(A*x-b); % initial error norm
    tic;
    for i = 1:1000
        x = M * x + bm;
        iterations = iterations + 1;
        err_norm(iterations+1) = norm(A*x-b); % add error norm to vector
        if err_norm(iterations+1) < 1e-12
            break;
        end
    end

    time = toc;

    
end
    