function M = mutual_inductance(coord_i, coord_j, c, method, n)
% Inputs:
%       coord_i -> position of the coils (R,Z) with a current 
%                   (structure: Nc...number of coils, 
%                               Nw...number of loop of each coil, 
%                               R... horizontal coordinates of the coils
%                               Z...vertcal coordinates of the coils
%                               Id...current direction in each of the coils (1 or -1))
%       coord_j -> position of the coils (R,Z) (structure: N...number of coils, R, Z)
%       matice vsechny civky => melo by se prenasobit smery proudu
%       c       -> constants (structure)
%       method  -> 'analytical' (using elliptic intgrals) / 'numerical' 
%       n       -> number of coil elements (for purpose of numerical method)
% Output: 
%       M       -> matrix of mutual inductance M_ij of circuit i and j [Nc_i x Nc_j]

% TODO: promyslet jak pocitat indukcnost vinuti vs. indukcnost mezi
% jednotlivymi vinutimi (nejak univerzalne)
% Zatim vsude uvazovan pouze jeden zavit, ve skutecnosti bych ji napr u
% externi stabilizace melo byt N = 8! -> promylet zda to pujde nejak
% zahrnout do vztahu (vynasobeni N^2), nebo bude nutne definovat souradnice a pocitat
% pro kazdy zavit zvlast (metoda s eliptickymi integrali ale bude dost mozna vice nepresna)

% TODO: promyslet orientaci proudu - kde to delat

Nloop_i = coord_i.Nc * coord_i.Nl;
Nloop_j = coord_j.Nc * coord_j.Nl;

M = zeros(Nloop_i, Nloop_j);

d = 3.33e-3; % wire radius -> TOBE changed (e.g. for plasma) -> move it among the inputs

switch method

    case "analytical"
        for i = 1:coord_i.Nc % tady bude problem -> promyslet rozmer
            for j = 1:coord_j.Nc
                if i==j
%                     % self-inductance
%                     Y = 0; % for ideal skin effect; 
%                     % Y = 1/4; % for homogenous current flow in the coil (no skin effect)
%                 
%                     M(i,j) = c.mu0 * coord_i.R(i) * (log(8*coord_i.R(i)/d) - 2 + Y/2);
                else
                    % mutual inductance
                    [k2, f1, f2, K, E] = Elliptic_integral(coord_i.R(i), coord_j.R(j), coord_i.Z(i), coord_j.Z(j));
                    M(i,j) = 2 * c.mu0 *coord_i.R(i) * coord_j.R(j)/(sqrt((coord_i.R(i)+coord_j.R(j))^2 + ((coord_j.Z(j) - coord_i.Z(i))^2))) * ((2-k2)*K - 2*E)/k2;                    
                end
            end   
        end    

    case "numerical"    
        for i = 1:coord_i.Nc
            for j = 1:coord_j.Nc
                if i == j
%                     self-inductance
%                     Y = 0; % for ideal skin effect; 
%                     Y = 1/4; % for homogenous current flow in the coil (no skin effect)
% 
%                     M(i,j) = c.mu0 * coord_i.R(i) * (log(8*coord_i.R(i)/d) - 2 + Y/2);
                else    
                    % mutual inductance
                    sum = 0;
                    for k = 0:n-1
                        phi = 2 * pi * k / n;
                        Dk = sqrt((coord_i.R(j) - coord_j.R(i)*cos(phi))^2 + ((coord_i.R(i) * sin(phi))^2) + ((coord_i.Z(j) - coord_j.Z(i))^2));
                        sum = sum + cos(phi)/Dk;
                    end
                    %TODO: Zkontrolovat vzorec; V BP A.K. prohozene i,j
                    %oproti PhD Havlicka    
                    M(i, j) = c.mu0 * coord_i.R(i)*coord_j.R(j) * pi/n * sum;
                end
            end
        end
end

M = coord_i.Id * M * coord_i.Id';

