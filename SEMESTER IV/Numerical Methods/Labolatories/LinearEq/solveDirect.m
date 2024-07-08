function [x,time_direct,err_norm] = solveDirect(A, b)
    tic;
    x = A\b;
    time_direct = toc;
    err_norm = norm(A*x-b);
    end