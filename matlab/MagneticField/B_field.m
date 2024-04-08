function [Br, Bz, Br_tot, Bz_tot] = B_field(coord_B, coord_ext, c, method, n)
% Returns magnetic field in units given by sc_I and sc_B
% Inputs:
%       coord_B   -> position (R,Z) in which B is interested
%       coord_ext -> position of the coils generating magnetec field at coord_B 
%                   (structure: N...number of coils, R, Z, 
%                               Id...array with current in coils
%                               sc_I, sc_B...scaling)
%       c         -> constants (structure)
%       method    -> 'analytical' (using elliptic intgrals) / 'numerical' 
%       n         -> number of coil elements (for purpose of numerical method)
% Output: 
%       Br        -> radial(horizontal) component of the magnetic field at the position coord_B
%       Bz        -> vertical component of the magnetic field at the position coord_B
%       Bpol      -> poloidal component of the magnetic field at the position coord_B 
%                    Bpol = sqrt(Br^2 + Bz^2)



Nloop = coord_ext.Nc*coord_ext.Nl;

I = coord_ext.Id * coord_ext.sc_I;

Br = zeros(1,Nloop); Bz = zeros(1,Nloop);

switch method
    case "analytical"
        for j = 1:Nloop
            [~, f1, f2, ~, ~] = Elliptic_integral(coord_B.R, coord_ext.R(j), coord_B.Z, coord_ext.Z(j));
            Br(j) = c.mu0 * I(j)/(4*pi) * (coord_ext.Z(j) - coord_B.Z) * f1 / (coord_B.R * sqrt(coord_ext.R(j)*coord_B.R));
            Bz(j) = c.mu0 * I(j)/(4*pi) * (coord_B.R*f1 + coord_ext.R(j)*f2) / (coord_B.R * sqrt(coord_ext.R(j)*coord_B.R));
        end    


    case "numerical"    
        for j = 1:Nloop
            sum_r = 0;
            sum_z = 0;
            % fprintf(['\ncoord_ext_Rj: ', num2str(coord_ext.R(j))])
            % fprintf(['\ncoord_ext_Zj: ', num2str(coord_ext.Z(j))])
            % fprintf('\n')
            for k = 0:n-1
                phi_k = 2 * pi * k / n;
                Dk = ((coord_B.R - coord_ext.R(j)*cos(phi_k))^2 + ((coord_ext.R(j) * sin(phi_k))^2) + ((coord_B.Z - coord_ext.Z(j))^2))^(3/2);
                sum_r = sum_r + cos(phi_k)/Dk;
                sum_z = sum_z + (coord_ext.R(j)*(sin(phi_k)^2) - cos(phi_k)*(coord_B.R - coord_ext.R(j) * cos(phi_k)))/Dk;
            end
            dl = 2*pi*coord_ext.R(j)/n; 
            Br(j) = 1e-7 * I(j) * dl * (coord_B.Z - coord_ext.Z(j)) * sum_r;
            Bz(j) = 1e-7 * I(j) * dl * sum_z;
        end
end

 Br_tot = sum(Br) * coord_ext.sc_B;
 Bz_tot = sum(Bz) * coord_ext.sc_B;

end