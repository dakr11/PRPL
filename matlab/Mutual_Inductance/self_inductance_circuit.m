function L = self_inductance_circuit(coord, c, method, n)
% Inputs:
%       coord -> position of the coils (R,Z) with a current 
%                   (structure: Nc...number of coils, 
%                               Nw...number of loop of each coil, 
%                               R... horizontal coordinates of the coils
%                               Z...vertcal coordinates of the coils
%                               Id...current direction in each of the coils (1 or -1))
%       c       -> constants (structure)
%       method  -> 'analytical' (using elliptic intgrals) / 'numerical' 
%       n       -> number of coil elements (for purpose of numerical method)
% Output: 
%       L       -> Self-indutance of a given cirucuit

% TODO: promyslet jak pocitat indukcnost vinuti vs. indukcnost mezi
% jednotlivymi vinutimi (nejak univerzalne)
% Zatim vsude uvazovan pouze jeden zavit, ve skutecnosti bych ji napr u
% externi stabilizace melo byt N = 8! -> promylet zda to pujde nejak
% zahrnout do vztahu (vynasobeni N^2), nebo bude nutne definovat souradnice a pocitat
% pro kazdy zavit zvlast (metoda s eliptickymi integrali ale bude dost mozna vice nepresna)

%TODO: ZKONTROLOVAT VZOREC PRO NUMERICKY VYPOCET + OTESTOVAT PO VZORU
% Test_B.m - Self inductance by mela byt dobre porovnatelna s
% experimentem!!!

Nloop = coord.Nc * coord.Nl;

M = zeros(Nloop, Nloop);

d = 3.33e-3; % wire radius -> TOBE changed (e.g. for plasma) -> move it among the inputs

switch method
    case "analytical"
        for i = 1:coord.Nc % tady bude problem -> promyslet rozmer
            for j = 1:coord.Nc
                if i==j
                    % self-inductance
                    Y = 0; % for ideal skin effect; 
                    % Y = 1/4; % for homogenous current flow in the coil (no skin effect)

                    M(i,j) = c.mu0 * coord.R(i) * (log(8*coord.R(i)/d) - 2 + Y/2);
                else
                    % mutual inductance
                    M(i,j) = Elliptic_integral(coord.R(i), coord.R(j), coord.Z(i), coord.Z(j));
                end
            end   
        end    

    case "numerical"    
        for i = 1:coord.Nc
            for j = 1:coord.Nc
                if i == j
                    % self-inductance
                    Y = 0; % for ideal skin effect; 
                    % Y = 1/4; % for homogenous current flow in the coil (no skin effect)

                    M(i,j) = c.mu0 * coord.R(i) * (log(8*coord.R(i)/d) - 2 + Y/2);
                else    
                    % mutual inductance
                    sum = 0;
                    for k = 0:n-1
                        phi = 2 * pi * k / n;
                        Dk = sqrt((coord.R(j) - coord.R(i)*cos(phi))^2 + ((coord.R(i) * sin(phi))^2) + ((coord.Z(j) - coord.Z(i))^2));
                        sum = sum + cos(phi)/Dk;
                    end
                    %TODO: Zkontrolovat vzorec; V BP A.K. prohozene i,j
                    %oproti PhD Havlicka
                    M(i, j) = c.mu0 * coord.R(i)*coord.R(j) * pi/n * sum;
                end
            end
        end
end

L = coord.Id * M * coord.Id';

