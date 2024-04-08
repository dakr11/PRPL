% Pre-calculate Inductance Matrix
close all, clear all

%% Coordinates of the conductive structures
coord = init_coord;
plot_coord = false;
if plot_coord
    figure, clf, hold on
    plot(coord.VertStab.R, coord.VertStab.Z, 'color', "#0072BD", 'LineStyle', 'none','Marker','.', 'LineWidth', 0.3, 'DisplayName','exVertStab')
    plot(coord.HorStab.R, coord.HorStab.Z, 'color', "#D95319", 'LineStyle', 'none','Marker','.', 'LineWidth', 0.3,'DisplayName','exHorStab')
    plot(coord.Vessel.R, coord.Vessel.Z, 'k.', 'LineWidth', 0.2, 'DisplayName','Vessel')
    plot(coord.InnerQuadr.R, coord.InnerQuadr.Z, 'color',"#D95319",'LineStyle','none','Marker', 'o', 'LineWidth', 0.2, 'DisplayName','Inner Quadrupole')
    plot(coord.CopperShell.R, coord.CopperShell.Z, 'k.', 'LineWidth', 0.2, 'DisplayName','Copper Shell')
    legend('Location','northeastoutside');
    axis square
    hold off
end
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

method = 'numerical'; 
% method = 'analytical';%TODO: v Analytical nejaka chyba

Lv = self_inductance_circuit(coord.VertStab, c, method, 1e6);
Lh = self_inductance_circuit(coord.HorStab, c, method, 1e6);
Mvh = mutual_inductance(coord.VertStab, coord.HorStab, c, method, 1e4); 

% Maa is symmetric
Maa = [Lv Mvh;
       Mvh Lh];

fprintf('\nLv:'), disp(Lv)
fprintf('\nLh:'), disp(Lh)
fprintf('\nMvh:'), disp(Mvh)
fprintf('\n Matrix M\n: '), disp(Maa)

%% Step response (aka calculate currents in the coils)
% dpsidt = U = M * dIdt + R * I  
%       dIdt = M^{-1} * U - M^{-1}*(R*I) ..ODE for I
% U...voltage vector (na x 1) is input, 
% I...currents vector (na x 1) is unknown; 
% M (na x na) is Matrix of inductance
% State-Space representation, i.e. dxdt = Ax + Bu; y = Cx + Du
% -> Matlab fcn 'step' can be used

% TODO: zrejme spatne indukcnost (+ odpor), proudy nevypadaji dobre :(

na = 2; % Vertical stabilization circuit & Horizontal stabilization circuit
% U = ones(na, 1) * 20;
% Start simply -> let R = 0
R = eye(na) * 10;
A = -Maa\R; % Maa is symmetric & positive definite => invertible
B = inv(Maa);
C = eye(size(Maa)); D = zeros(size(C,1),size(B,2));
sys = ss(A,B,C,D);

[Ia,time] = step(sys(:, 1), 2);
time = time'; Ia=Ia'; % transpose because we like time in the last dimension
figure(1); clf; set(gcf,'position',[100 100 400 300])
plot(time,Ia);
xlabel('Time [s]'); ylabel('Current [A]')
hl = legend(G.dima,'interpreter','none','location','eastoutside');
print(gcf,'-depsc',' circuit equation');

%%
i_coil = 1;
  
Tf = 5; % Final time
dt = 1e-3; % time step
t  = 0:dt:Tf;
V_step = 100; %[V]
[Y,~,X] = step(sys(:,i_coil)*V_step,t); %100V 
Ia = Y(:,1:na)'; % active coils current

figure()
plot(t,Ia)
title(['Coils current (coil ',coil_str,': ',num2str(V_step),'V step)'],'Interpreter','none')
xlabel('t [s]')
ylabel('I_a [A]')
grid on


%%
% Self inductance of a circuit
% Tv = [coord_exStab_v.Id, coord_exStab_h.Id];
% Lv = Tv' * Mvh * Tv;
% Th = [coord_exStab_h.Id; zeros(coord_exStab_v.Nc, 1)];

%%
% Mutual inductance matrix for Vertical exStab and Vessel
% Mvh = mutual_inductance(coord_exV, coord_exH, 'analytical', 100); 
