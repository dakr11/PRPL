% Get slices based on experiment
close all, clear all

%% Coordinates of the conductive structures
coord = init_coord;

%% Load precomputed magnetic fields
load Bcoils_stabilization.mat;

%%
I = 0.1; % [kA]
field = 'Br_sum'; fname = 'VertStab'; method = 'ell';
Br = abs(Bcoils.(fname).(method).(field)')*I;
figure('Name', [field,'_',fname])
idx_z = find(Bcoils.meshgrid.y >=0, 1,'first');
plot(Bcoils.meshgrid.x, Br(:,idx_z), 'DisplayName','B_r')
ylabel('B_r [mT]'); xlabel('r')

%%
I = 0.1; % [kA]
field = 'Bz_sum'; fname = 'HorStab'; method = 'ell';
Br = abs(Bcoils.(fname).(method).(field)')*I;
figure('Name', [field,'_',fname])
idx_z = find(Bcoils.meshgrid.y >=0, 1,'first');
plot(Bcoils.meshgrid.x, Br(:,idx_z), 'DisplayName','B_z')
ylabel('B_z [mT]'); xlabel('r')