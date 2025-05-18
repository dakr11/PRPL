function [k2, f1, f2, K, E] = Elliptic_integral(R0, R1, Z0, Z1)

    k2 = 4 * R0 * R1 / ((R0 + R1)^2 + ((Z0 - Z1)^2)); 
    
    load elliptic_integral_constants
    ell = elliptic_integral_constants;
    
    m = 1-k2;
    K = ell.a.K(1) + m * (ell.a.K(2) + m * (ell.a.K(3) + m * (ell.a.K(4) + m*ell.a.K(5)))) + ell.b.K(1) + m * (ell.b.K(2) + m * (ell.b.K(3) + m *(ell.b.K(4) + m *ell.b.K(5)))) * log(1/m); 
    E = 1 + m * (ell.a.E(1) + m * (ell.a.E(2) + m * (ell.a.E(3) * + m*ell.a.E(4)))) + m * (ell.b.E(1) + m * (ell.b.E(2) + m *(ell.b.E(3) + m *ell.b.E(4)))) * log(1/m); 
    
    f1 = sqrt(k2) * (K - (2-k2)/(2*(1-k2))*E);
    f2 = k2^(3/2) / (2*(1 - k2)) * E;
    
end