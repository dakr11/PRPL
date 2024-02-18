function Bcoils = get_Bcoil(coord_ext,Bcoils, fname, c, n)
% Inputs:
%       coord_ext -> position of the coils generating magnetec field at coord_B 
%                   (structure: N...number of coils, R, Z, 
%                               Id...array with current in coils
%                               sc_I, sc_B...scaling)
%       Bcoils    -> structure, includes meshgrid
%       c         -> constants (structure)
%       n         -> number of coil elements (for purpose of numerical method)
% Output: 
%       Bcoils    -> structure

    x = Bcoils.meshgrid.x; 
    y = Bcoils.meshgrid.y;
    
    Br_num = zeros(numel(x), numel(y));
    Bz_num = zeros(numel(x), numel(y));
    Br_ell = zeros(numel(x), numel(y));
    Bz_ell = zeros(numel(x), numel(y));
    Br_loops_num = zeros(numel(x), numel(y), coord_ext.Nc*coord_ext.Nl);
    Bz_loops_num = zeros(numel(x), numel(y), coord_ext.Nc*coord_ext.Nl);
    Br_loops_ell = zeros(numel(x), numel(y), coord_ext.Nc*coord_ext.Nl);
    Bz_loops_ell = zeros(numel(x), numel(y), coord_ext.Nc*coord_ext.Nl);
    
    for i = 1:numel(x)
        coord_B.R = x(i);
        for j = 1:numel(y)
            coord_B.Z = y(j);
    %       % Numerical approach
            [Br_loops_num, Bz_loops_num, Br_num(i,j), Bz_num(i,j)] = B_field(coord_B, coord_ext, c, 'numerical', n);
    %       % Analytical approach (using Elliptic integrals)
            [Br_loops_ell, Bz_loops_ell, Br_ell(i,j), Bz_ell(i,j)] = B_field(coord_B, coord_ext, c, 'analytical', n);
        end   
    end
    
    %% Store results into structure
    Bcoils.(fname).coord = coord_ext;
    Bcoils.(fname).num.info.n = n;
    
    Bcoils.(fname).num.Br_sum = Br_num;
    Bcoils.(fname).num.Bz_sum = Bz_num;
    Bcoils.(fname).num.Br_loops = Br_loops_num;
    Bcoils.(fname).num.Bz_loops = Bz_loops_num;
    
    Bcoils.(fname).ell.Br_sum = Br_ell;
    Bcoils.(fname).ell.Bz_sum = Bz_ell;
    Bcoils.(fname).ell.Br_loops = Br_loops_ell;
    Bcoils.(fname).ell.Bz_loops = Bz_loops_ell;

end