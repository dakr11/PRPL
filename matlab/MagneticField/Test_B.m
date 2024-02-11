%% Simple tests of correct calculation of magnetic field B
% Analytical solution exists for the axix, i.e. at R = 0
% Assuming dipole approximation: Position of coord_B far away from position
% of the coil, i.e. |coord_ext.R - coord_B.R| >> coord_ext.R
% Note that this test can not be performed for elliptic integrals as R is
% in denominator!!!

% Define coordinates of one coil
% good agreement for ext.R = 1, B.Z = 5 and n = 1e4
coord_ext.R = 1;
coord_ext.Z = 0;
coord_ext.Nc = numel(coord_ext.R);
coord_ext.Nl = 1; %loops per coil

% Analytical solution exists for the axis
coord_B.R = 0;
coord_B.Z = 5;

I = 1;
n = 1e4;

c.mu0 = 4*pi*1e-7;

% Perform test
% Numerical approach
[Br_num, Bz_num, Br_tot_num, Bz_tot_num] = B_field(coord_B, coord_ext, I, c, 'numerical', n);

% Analytical solution
Bz_anal = c.mu0 * I * coord_ext.R / (2*((coord_B.Z^2 + coord_ext.R^2)^(3/2)));

% Results
fprintf(['\nBz_num: ', num2str(Bz_num)])
fprintf(['\nBz_anal: ', num2str(Bz_anal), '\n'])


%% Test for elliptic integral
% Numerical approach works -> lets compare elliptic integrals approach with
% numerical one

% Define coordinates of one coil
% The agreement worsens with increasing distance between coord_ext and
% coord_B

coord_ext.R = 1;
coord_ext.Z = 0;
coord_ext.Nc = numel(coord_ext.R);

% Analytical solution exists for the axis
coord_B.R = 0.5;
coord_B.Z = 0.2;

I = 1;
n = 1e4;

c.mu0 = 4*pi*1e-7;

% Perform test
% Elliptic integral
[Br_ell, Bz_ell, Br_tot_ell, Bz_tot_ell] = B_field(coord_B, coord_ext, I, c, 'analytical', n);

% Numerical approach
[Br_num, Bz_num, Br_tot_num, Bz_tot_num] = B_field(coord_B, coord_ext, I, c, 'numerical', n);

% Results
fprintf(['\nBz_ell: ', num2str(Bz_ell)])
fprintf(['\nBz_num: ', num2str(Bz_num), '\n'])



