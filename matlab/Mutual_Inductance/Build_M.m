% Pre-calculate Inductance Matrix
close all, clear all

%% Coordinates of the conductive structures
coord = init_coord;

figure, clf, hold on
plot(coord.VertStab.R, coord.VertStab.Z, 'color', "#0072BD", 'LineStyle', 'none','Marker','.', 'LineWidth', 0.3, 'DisplayName','exVertStab')
plot(coord.HorStab.R, coord.HorStab.Z, 'color', "#D95319", 'LineStyle', 'none','Marker','.', 'LineWidth', 0.3,'DisplayName','exHorStab')
plot(coord.Vessel.R, coord.Vessel.Z, 'k.', 'LineWidth', 0.2, 'DisplayName','Vessel')
plot(coord.InnerQuadr.R, coord.InnerQuadr.Z, 'color',"#D95319",'LineStyle','none','Marker', 'o', 'LineWidth', 0.2, 'DisplayName','Inner Quadrupole')
plot(coord.CopperShell.R, coord.CopperShell.Z, 'k.', 'LineWidth', 0.2, 'DisplayName','Copper Shell')
legend('Location','northeastoutside');
axis square
hold off

% TODO: Add Iron core and Diagnostic coils

%% Define grid 
dx = 0.002;
dy = 0.002;
x = 0.3:dx:0.5;
y = -0.1:dy:0.1;
[R, Z] = meshgrid(x, y);

%% External Stabilization
% Inductance matrix for Vertical and Horizontal exStab
% Matrix contains self inductance and mutual inductance
% TODO: Rozdelit na jednotlve zavity
% TODO: lepsi bude si nejdriv proste zvlast napocitat jednotlive matice
% obvodu, tj. selfinductance a teprve pak ty vzajemne typu Mvh, apod.

% TODO: NUTNO FCE OTESTOVAT + zkontrolovat vzorce!!!

c.mu0 = 4*pi*1e-7;

coord_exStab_v.Nc = 4;
coord_exStab_v.R = [0.21; 0.21; 0.65; 0.65];
coord_exStab_v.Z = [0.28; -0.28; 0.233; -0.257];
coord_exStab_v.Id = [-1; -1; 1; 1];

coord_exStab_h.Nc = 4;
coord_exStab_h.R = [0.27; 0.27; 0.65; 0.65];
coord_exStab_h.Z = [0.28; -0.28; 0.257; -0.233];
coord_exStab_h.Id = [-1; 1; -1; 1];

method = 'numerical'; %TODO: v Analytical nejaka chyba
% method = 'analytical';
Lv = self_inductance_circuit(coord_exStab_v, c, method, 1e6);
Lh = self_inductance_circuit(coord_exStab_h, c, method, 1e6);
Mvh = mutual_inductance(coord_exStab_v, coord_exStab_h,c,method, 1e4); 
Mhv =

% Self inductance of a circuit
% Tv = [coord_exStab_v.Id, coord_exStab_h.Id];
% Lv = Tv' * Mvh * Tv;
% Th = [coord_exStab_h.Id; zeros(coord_exStab_v.Nc, 1)];

%%
% Mutual inductance matrix for Vertical exStab and Vessel
% Mvh = mutual_inductance(coord_exV, coord_exH, 'analytical', 100); 
