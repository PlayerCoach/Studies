function impedance_delta = impedance_magnitude(omega)

    R = 525 ;
    C = 7 * 10^(-5);
    L = 3;
    M = 75; % docelowa wartość modułu impedancji

    if omega <= 0
        error('Omega cannot be less than or equal to 0');   
    end
    
    
    Z = 1/(sqrt(1/R^2 + (omega*C - 1/(omega*L))^2));
    
    
    impedance_delta = abs(Z) - M;
    
    end